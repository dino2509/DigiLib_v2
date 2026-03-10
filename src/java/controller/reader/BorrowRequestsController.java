package controller.reader;

import dal.BorrowRequestDBContext;
import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import model.BorrowRequest;
import model.RequestHistoryRow;
import model.ReservationRequest;
import model.Reader;

/**
 * Reader merged page:
 *  - /reader/borrow-requests
 * Filters: all / reserved / pending / approved / rejected
 *
 * - reserved = Reservation_Request (WAITING)
 * - pending/approved/rejected = Borrow_Request
 */
@WebServlet(urlPatterns = "/reader/borrow-requests")
public class BorrowRequestsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        String filter = normalizeFilter(req.getParameter("filter"));

        BorrowRequestDBContext brDAO = new BorrowRequestDBContext();
        ReservationDBContext rrDAO = new ReservationDBContext();

        List<RequestHistoryRow> rows = new ArrayList<>();

        // Borrow requests
        if (!"reserved".equals(filter)) {
            List<BorrowRequest> brs = brDAO.listWithItemsByReaderAndStatus(reader.getReaderId(), filter, 200);
            for (BorrowRequest br : brs) {
                RequestHistoryRow row = new RequestHistoryRow();
                row.setType("BORROW");
                row.setId(br.getRequestId());
                row.setReaderId(br.getReaderId());
                row.setReaderName(br.getReaderName());
                row.setStatus(br.getStatus());
                row.setCreatedAt(br.getRequestedAt());
                row.setTitleSummary(buildBorrowTitleSummary(br));
                rows.add(row);
            }
        }

        // Reservations
        if ("reserved".equals(filter) || "all".equals(filter) || "approved".equals(filter) || "rejected".equals(filter)) {
            // mapping inside DAO:
            // reserved -> WAITING, approved -> CONVERTED, rejected -> CANCELLED, all -> all
            ArrayList<ReservationRequest> rrs = rrDAO.listByReader(reader.getReaderId(), filter, 200);
            for (ReservationRequest rr : rrs) {
                RequestHistoryRow row = new RequestHistoryRow();
                row.setType("RESERVATION");
                row.setId(rr.getReservationId());
                row.setReaderId(rr.getReaderId());
                row.setReaderName(rr.getReaderName());
                row.setStatus(rr.getStatus());
                row.setCreatedAt(rr.getCreatedAt());
                row.setTitleSummary(rr.getBookTitle());
                row.setPosition(rr.getPosition());
                row.setConvertedRequestId(rr.getConvertedRequestId());
                rows.add(row);
            }
        }

        // sort newest first
        rows.sort(Comparator.comparing(RequestHistoryRow::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed()
                .thenComparing(RequestHistoryRow::getType)
                .thenComparing(RequestHistoryRow::getId, Comparator.reverseOrder()));

        req.setAttribute("rows", rows);
        req.setAttribute("filter", filter);

        // Detail
        String type = req.getParameter("type");
        int id = parseInt(req.getParameter("id"), -1);
        if (id > 0 && type != null) {
            if ("borrow".equalsIgnoreCase(type)) {
                BorrowRequest detail = brDAO.getWithItems(id);
                // safety: only allow own request
                if (detail != null && detail.getReaderId() == reader.getReaderId()) {
                    req.setAttribute("borrowDetail", detail);
                }
            } else if ("reservation".equalsIgnoreCase(type)) {
                ReservationRequest detail = rrDAO.get(id);
                if (detail != null && detail.getReaderId() == reader.getReaderId()) {
                    req.setAttribute("reservationDetail", detail);
                }
            }
        }

        req.getRequestDispatcher("/view/reader/borrow_requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        String filter = normalizeFilter(req.getParameter("filter"));

        String action = req.getParameter("action");
        if ("cancel_reservation".equalsIgnoreCase(action)) {
            int reservationId = parseInt(req.getParameter("reservationId"), -1);
            if (reservationId > 0) {
                ReservationDBContext rrDAO = new ReservationDBContext();
                rrDAO.cancel(reservationId, reader.getReaderId());
            }
            resp.sendRedirect(req.getContextPath() + "/reader/borrow-requests?filter=" + filter + "&msg=cancelled");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reader/borrow-requests?filter=" + filter);
    }

    private String buildBorrowTitleSummary(BorrowRequest br) {
        if (br == null || br.getItems() == null || br.getItems().isEmpty()) return "(Không có sách)";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < br.getItems().size(); i++) {
            String t = br.getItems().get(i).getBookTitle();
            if (t == null) t = "(Unknown)";
            if (i > 0) sb.append(", ");
            sb.append(t);
        }
        return sb.toString();
    }

    private Reader requireReader(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (Reader) session.getAttribute("user");
    }

    private String normalizeFilter(String filter) {
        if (filter == null || filter.trim().isEmpty()) return "all";
        filter = filter.trim().toLowerCase();
        return switch (filter) {
            case "all", "reserved", "pending", "approved", "rejected" -> filter;
            default -> "all";
        };
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }
}
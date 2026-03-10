package controller.librarian;

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
import model.Employee;
import model.RequestHistoryRow;
import model.ReservationRequest;

@WebServlet(urlPatterns = "/librarian/borrow-requests")
public class BorrowRequestsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Employee)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Employee emp = (Employee) session.getAttribute("user");
        if (emp.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
            return;
        }

        String filter = normalizeFilter(req.getParameter("filter"));

        BorrowRequestDBContext brDAO = new BorrowRequestDBContext();
        ReservationDBContext rrDAO = new ReservationDBContext();

        List<RequestHistoryRow> rows = new ArrayList<>();

        // Borrow requests
        if (!"reserved".equals(filter)) {
            ArrayList<BorrowRequest> brs = brDAO.listByStatus(filter, 200);
            for (BorrowRequest br : brs) {
                RequestHistoryRow row = new RequestHistoryRow();
                row.setType("BORROW");
                row.setId(br.getRequestId());
                row.setReaderId(br.getReaderId());
                row.setReaderName(br.getReaderName());
                row.setStatus(br.getStatus());
                row.setCreatedAt(br.getRequestedAt());
                row.setTitleSummary("Borrow request");
                rows.add(row);
            }
        }

        // Reservations (reserved tab OR all/approved/rejected tab)
        if ("reserved".equals(filter) || "all".equals(filter) || "approved".equals(filter) || "rejected".equals(filter)) {
            ArrayList<ReservationRequest> rrs = rrDAO.listForLibrarian(filter, 200);
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

        rows.sort(Comparator.comparing(RequestHistoryRow::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed()
                .thenComparing(RequestHistoryRow::getType)
                .thenComparing(RequestHistoryRow::getId, Comparator.reverseOrder()));

        req.setAttribute("rows", rows);
        req.setAttribute("filter", filter);

        String type = req.getParameter("type");
        int id = parseInt(req.getParameter("id"), -1);
        if (id > 0 && type != null) {
            if ("borrow".equalsIgnoreCase(type)) {
                BorrowRequest detail = brDAO.getWithItems(id);
                req.setAttribute("borrowDetail", detail);
            } else if ("reservation".equalsIgnoreCase(type)) {
                ReservationRequest detail = rrDAO.get(id);
                req.setAttribute("reservationDetail", detail);
            }
        }

        req.getRequestDispatcher("/view/librarian/borrow_requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Employee)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Employee emp = (Employee) session.getAttribute("user");
        if (emp.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
            return;
        }

        String filter = normalizeFilter(req.getParameter("filter"));

        String action = req.getParameter("action");

        // Borrow approve/reject
        int requestId = parseInt(req.getParameter("requestId"), -1);
        String note = trimToNull(req.getParameter("decisionNote"));
        int dueDays = parseInt(req.getParameter("dueDays"), 14);
        if (dueDays < 7) dueDays = 7;
        if (dueDays > 14) dueDays = 14;

        BorrowRequestDBContext brDAO = new BorrowRequestDBContext();

        if (requestId > 0 && "approve".equalsIgnoreCase(action)) {
            boolean ok = brDAO.approve(requestId, emp.getEmployeeId(), note, dueDays);
            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=" + filter + "&type=borrow&id=" + requestId + "&error=not_enough_copies");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=approved");
            return;
        }

        if (requestId > 0 && "reject".equalsIgnoreCase(action)) {
            brDAO.reject(requestId, emp.getEmployeeId(), note);
            resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=rejected");
            return;
        }

        // Reservation cancel
        if ("cancel_reservation".equalsIgnoreCase(action)) {
            int reservationId = parseInt(req.getParameter("reservationId"), -1);
            if (reservationId > 0) {
                ReservationDBContext rrDAO = new ReservationDBContext();
                rrDAO.cancelByLibrarian(reservationId);
            }
            resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=" + filter + "&msg=cancelled");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=" + filter);
    }

    private String normalizeFilter(String filter) {
        if (filter == null || filter.trim().isEmpty()) return "pending";
        filter = filter.trim().toLowerCase();
        return switch (filter) {
            case "pending", "approved", "rejected", "all", "reserved" -> filter;
            default -> "pending";
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

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
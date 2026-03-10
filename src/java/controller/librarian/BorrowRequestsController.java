package controller.librarian;

import dal.BorrowExtendDBContext;
import dal.BorrowRequestDBContext;
import dal.ReservationDBContext;
import dal.ReturnRequestDBContext;
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
import model.BorrowExtendRequest;
import model.BorrowRequest;
import model.Employee;
import model.RequestHistoryRow;
import model.ReturnRequest;

@WebServlet(urlPatterns = "/librarian/requests")
public class BorrowRequestsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        String typeFilter = normalizeTypeFilter(req.getParameter("typeFilter"));
        String statusFilter = normalizeStatusFilter(req.getParameter("statusFilter"));

        BorrowRequestDBContext brDAO = new BorrowRequestDBContext();
        ReturnRequestDBContext rrDAO = new ReturnRequestDBContext();
        BorrowExtendDBContext beDAO = new BorrowExtendDBContext();

        List<RequestHistoryRow> rows = new ArrayList<>();

        if ("all".equals(typeFilter) || "borrow".equals(typeFilter)) {
            ArrayList<BorrowRequest> brs = brDAO.listByStatus(statusFilter, 200);
            for (BorrowRequest br : brs) {
                RequestHistoryRow row = new RequestHistoryRow();
                row.setType("BORROW");
                row.setId(br.getRequestId());
                row.setReaderId(br.getReaderId());
                row.setReaderName(br.getReaderName());
                row.setStatus(br.getStatus());
                row.setCreatedAt(br.getRequestedAt());
                row.setTitleSummary("Yêu cầu mượn sách");
                rows.add(row);
            }
        }

        if ("all".equals(typeFilter) || "return".equals(typeFilter)) {
            for (ReturnRequest rr : rrDAO.listForLibrarian(statusFilter, 200)) {
                RequestHistoryRow row = new RequestHistoryRow();
                row.setType("RETURN");
                row.setId(rr.getReturnRequestId());
                row.setReaderId(rr.getReaderId() == null ? 0 : rr.getReaderId());
                row.setReaderName(rr.getReaderName());
                row.setStatus(rr.getStatus());
                row.setCreatedAt(rr.getCreatedAt());
                row.setTitleSummary(rr.getItems().isEmpty() ? "Yêu cầu trả sách" : rr.getItems().get(0).getBook().getTitle());
                row.setBorrowItemId(rr.getItems().isEmpty() ? null : rr.getItems().get(0).getBorrowItemId());
                row.setOldDueDate(rr.getItems().isEmpty() ? null : rr.getItems().get(0).getDueDate());
                rows.add(row);
            }
        }

        if ("all".equals(typeFilter) || "extend".equals(typeFilter)) {
            for (BorrowExtendRequest be : beDAO.listForLibrarian(typeFilter, statusFilter, 200)) {
                RequestHistoryRow row = new RequestHistoryRow();
                row.setType("EXTEND");
                row.setId(be.getExtendId());
                row.setReaderId(be.getReaderId());
                row.setReaderName(be.getReaderName());
                row.setStatus(be.getStatus());
                row.setCreatedAt(be.getRequestedAt());
                row.setTitleSummary(be.getBook() == null ? "Yêu cầu gia hạn" : be.getBook().getTitle());
                row.setBorrowItemId(be.getBorrowItemId());
                row.setRequestedDays(be.getRequestedDays());
                row.setMaxAllowedDays(be.getMaxAllowedDays());
                row.setOldDueDate(be.getOldDueDate());
                row.setRequestedDueDate(be.getRequestedDueDate());
                row.setApprovedDueDate(be.getApprovedDueDate());
                rows.add(row);
            }
        }

        rows.sort(Comparator.comparing(RequestHistoryRow::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed()
                .thenComparing(RequestHistoryRow::getType)
                .thenComparing(RequestHistoryRow::getId, Comparator.reverseOrder()));

        req.setAttribute("rows", rows);
        req.setAttribute("typeFilter", typeFilter);
        req.setAttribute("statusFilter", statusFilter);

        String detailType = normalizeDetailType(req.getParameter("detailType"));
        int id = parseInt(req.getParameter("id"), -1);
        if (id > 0 && detailType != null) {
            switch (detailType) {
                case "borrow" -> req.setAttribute("borrowDetail", brDAO.getWithItems(id));
                case "return" -> req.setAttribute("returnDetail", rrDAO.getDetailed(id));
                case "extend" -> req.setAttribute("extendDetail", beDAO.getDetailed(id));
            }
        }

        req.getRequestDispatcher("/view/librarian/borrow_requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        String action = req.getParameter("action");
        String typeFilter = normalizeTypeFilter(req.getParameter("typeFilter"));
        String statusFilter = normalizeStatusFilter(req.getParameter("statusFilter"));
        String qs = "?typeFilter=" + typeFilter + "&statusFilter=" + statusFilter;

        BorrowRequestDBContext brDAO = new BorrowRequestDBContext();
        ReturnRequestDBContext rrDAO = new ReturnRequestDBContext();
        BorrowExtendDBContext beDAO = new BorrowExtendDBContext();
        ReservationDBContext resDAO = new ReservationDBContext();

        int requestId = parseInt(req.getParameter("requestId"), -1);
        int returnRequestId = parseInt(req.getParameter("returnRequestId"), -1);
        int extendId = parseInt(req.getParameter("extendId"), -1);
        int reservationId = parseInt(req.getParameter("reservationId"), -1);
        int dueDays = parseInt(req.getParameter("dueDays"), 14);
        int approvedDays = parseInt(req.getParameter("approvedDays"), -1);
        String note = trimToNull(req.getParameter("decisionNote"));

        if (dueDays < 1) dueDays = 1;
        if (dueDays > 14) dueDays = 14;

        if (requestId > 0 && "approve_borrow".equalsIgnoreCase(action)) {
            boolean ok = brDAO.approve(requestId, emp.getEmployeeId(), note, dueDays);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests" + (ok ? "?statusFilter=approved&typeFilter=borrow" : qs + "&detailType=borrow&id=" + requestId + "&error=not_enough_copies"));
            return;
        }
        if (requestId > 0 && "reject_borrow".equalsIgnoreCase(action)) {
            brDAO.reject(requestId, emp.getEmployeeId(), note);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests?statusFilter=rejected&typeFilter=borrow");
            return;
        }
        if (returnRequestId > 0 && "approve_return".equalsIgnoreCase(action)) {
            boolean ok = rrDAO.confirm(emp.getEmployeeId(), returnRequestId);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests" + (ok ? "?statusFilter=approved&typeFilter=return" : qs + "&detailType=return&id=" + returnRequestId + "&error=return_failed"));
            return;
        }
        if (returnRequestId > 0 && "reject_return".equalsIgnoreCase(action)) {
            rrDAO.reject(emp.getEmployeeId(), returnRequestId, note == null ? "Từ chối yêu cầu trả sách" : note);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests?statusFilter=rejected&typeFilter=return");
            return;
        }
        if (extendId > 0 && "approve_extend".equalsIgnoreCase(action)) {
            boolean ok = beDAO.approve(extendId, emp.getEmployeeId(), approvedDays, note);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests" + (ok ? "?statusFilter=approved&typeFilter=extend" : qs + "&detailType=extend&id=" + extendId + "&error=extend_failed"));
            return;
        }
        if (extendId > 0 && "reject_extend".equalsIgnoreCase(action)) {
            beDAO.reject(extendId, emp.getEmployeeId(), note == null ? "Từ chối yêu cầu gia hạn" : note);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests?statusFilter=rejected&typeFilter=extend");
            return;
        }
        if (reservationId > 0 && "cancel_reservation".equalsIgnoreCase(action)) {
            resDAO.cancelByLibrarian(reservationId);
            resp.sendRedirect(req.getContextPath() + "/librarian/requests" + qs + "&msg=cancelled");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/librarian/requests" + qs);
    }

    private Employee requireLibrarian(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Employee)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        Employee emp = (Employee) session.getAttribute("user");
        if (emp.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
            return null;
        }
        return emp;
    }

    private String normalizeTypeFilter(String s) {
        if (s == null || s.trim().isEmpty()) return "all";
        s = s.trim().toLowerCase();
        return switch (s) {
            case "all", "borrow", "return", "extend" -> s;
            default -> "all";
        };
    }

    private String normalizeStatusFilter(String s) {
        if (s == null || s.trim().isEmpty()) return "all";
        s = s.trim().toLowerCase();
        return switch (s) {
            case "all", "pending", "approved", "rejected" -> s;
            default -> "all";
        };
    }

    private String normalizeDetailType(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        s = s.trim().toLowerCase();
        return switch (s) {
            case "borrow", "return", "extend" -> s;
            default -> null;
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
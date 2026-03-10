package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Book;
import model.BorrowExtendRequest;
import model.LibrarianBorrowItem;

public class LibrarianBorrowDBContext extends DBContext<LibrarianBorrowItem> {

    @Override
    public ArrayList<LibrarianBorrowItem> list() {
        return listByFilter("borrowing");
    }

    public ArrayList<LibrarianBorrowItem> listByFilter(String filter) {
        ArrayList<LibrarianBorrowItem> list = new ArrayList<>();
        if (filter == null) filter = "borrowing";
        filter = filter.trim().toLowerCase();

        String where = switch (filter) {
            case "all" -> "1=1";
            case "returned" -> "bi.returned_at IS NOT NULL";
            case "overdue" -> "bi.returned_at IS NULL AND bi.due_date < SYSDATETIME()";
            default -> "bi.returned_at IS NULL";
        };

        String sql = "SELECT bi.borrow_item_id, br.borrow_id, rd.reader_id, rd.full_name, bi.copy_id, bc.copy_code, "
                + "b.book_id, b.title, b.cover_url, br.borrow_date, bi.due_date, bi.returned_at, "
                + "pr.pending_return_request_id "
                + "FROM Borrow_Item bi "
                + "INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id "
                + "INNER JOIN Reader rd ON rd.reader_id = br.reader_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id "
                + "OUTER APPLY (SELECT TOP 1 r.return_request_id AS pending_return_request_id FROM Return_Request r "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "WHERE r.status = N'PENDING' AND i.borrow_item_id = bi.borrow_item_id ORDER BY r.created_at ASC, r.return_request_id ASC) pr "
                + "WHERE " + where + " ORDER BY br.borrow_date DESC, bi.borrow_item_id DESC";

        BorrowExtendDBContext extendDao = new BorrowExtendDBContext();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LibrarianBorrowItem item = new LibrarianBorrowItem();
                item.setBorrowItemId(rs.getInt("borrow_item_id"));
                item.setBorrowId(rs.getInt("borrow_id"));
                item.setReaderId(rs.getInt("reader_id"));
                item.setReaderName(rs.getString("full_name"));
                item.setCopyId(rs.getInt("copy_id"));
                item.setCopyCode(rs.getString("copy_code"));
                item.setBorrowDate(rs.getTimestamp("borrow_date"));
                item.setDueDate(rs.getTimestamp("due_date"));
                item.setReturnedAt(rs.getTimestamp("returned_at"));

                Book bk = new Book();
                bk.setBookId(rs.getInt("book_id"));
                bk.setTitle(rs.getString("title"));
                bk.setCoverUrl(rs.getString("cover_url"));
                item.setBook(bk);

                int pendingId = rs.getInt("pending_return_request_id");
                item.setPendingReturnRequestId(rs.wasNull() ? null : pendingId);

                BorrowExtendRequest pendingExt = extendDao.getPendingByBorrowItem(item.getBorrowItemId());
                if (pendingExt != null) {
                    item.setPendingExtendRequestId(pendingExt.getExtendId());
                    item.setPendingExtendRequestedDays(pendingExt.getRequestedDays());
                    item.setPendingExtendMaxDays(pendingExt.getMaxAllowedDays());
                }

                BorrowExtendDBContext.FineInfo fineInfo = extendDao.getUnpaidFineInfo(item.getBorrowItemId());
                item.setHasUnpaidFine(fineInfo.hasUnpaidFine);
                item.setUnpaidFineAmount(fineInfo.amount);
                item.setUnpaidFineSummary(fineInfo.summary);
                item.setOverdueFineAmount(fineInfo.amount);

                int overdueDays = 0;
                if (item.getDueDate() != null) {
                    java.time.LocalDate due = item.getDueDate().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate();
                    java.time.LocalDate end = item.getReturnedAt() != null
                            ? item.getReturnedAt().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate()
                            : java.time.LocalDate.now();
                    if (end.isAfter(due)) {
                        overdueDays = (int) java.time.temporal.ChronoUnit.DAYS.between(due, end);
                    }
                }
                item.setOverdueDays(Math.max(overdueDays, 0));

                if (item.getReturnedAt() != null) item.setStatus("RETURNED");
                else if (item.getDueDate() != null && item.getDueDate().before(new java.util.Date())) item.setStatus("OVERDUE");
                else item.setStatus("BORROWING");

                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public LibrarianBorrowItem get(int id) { return null; }

    @Override
    public void insert(LibrarianBorrowItem model) { }

    @Override
    public void update(LibrarianBorrowItem model) { }

    @Override
    public void delete(LibrarianBorrowItem model) { }
}
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Book;
import model.LibrarianBorrowItem;

public class LibrarianBorrowDBContext extends DBContext<LibrarianBorrowItem> {

    @Override
    public ArrayList<LibrarianBorrowItem> list() {
        return listByFilter("borrowing");
    }

    @Override
    public LibrarianBorrowItem get(int id) {
        return null;
    }

    @Override
    public void insert(LibrarianBorrowItem model) {}

    @Override
    public void update(LibrarianBorrowItem model) {}

    @Override
    public void delete(LibrarianBorrowItem model) {}

    public ArrayList<LibrarianBorrowItem> listByFilter(String filter) {

        ArrayList<LibrarianBorrowItem> list = new ArrayList<>();

        String where = "";

        switch (filter) {
            case "returned":
                where = "bi.returned_at IS NOT NULL";
                break;
            case "overdue":
                where = "bi.returned_at IS NULL AND bi.due_date < SYSDATETIME()";
                break;
            case "borrowing":
            default:
                where = "bi.returned_at IS NULL";
                break;
        }

        String sql = "SELECT bi.borrow_item_id, br.borrow_id, "
                + "rd.reader_id, rd.full_name, "
                + "bi.copy_id, bc.copy_code, "
                + "b.book_id, b.title, b.cover_url, "
                + "br.borrow_date, bi.due_date, bi.returned_at "
                + "FROM Borrow_Item bi "
                + "INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id "
                + "INNER JOIN Reader rd ON rd.reader_id = br.reader_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id "
                + "WHERE " + where
                + " ORDER BY br.borrow_date DESC";

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

                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                item.setBook(b);

                item.setBorrowDate(rs.getTimestamp("borrow_date"));
                item.setDueDate(rs.getTimestamp("due_date"));
                item.setReturnedAt(rs.getTimestamp("returned_at"));

                if (item.getReturnedAt() != null) {
                    item.setStatus("RETURNED");
                } else if (item.getDueDate().before(new java.util.Date())) {
                    item.setStatus("OVERDUE");
                } else {
                    item.setStatus("BORROWING");
                }

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
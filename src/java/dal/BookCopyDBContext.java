package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.BookCopy;
import dal.ReservationDBContext;

public class BookCopyDBContext extends DBContext<BookCopy> {

    @Override
    public ArrayList<BookCopy> list() {
        ArrayList<BookCopy> list = new ArrayList<>();
        String sql = "SELECT copy_id, book_id, copy_code, status FROM BookCopy";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookCopy bc = new BookCopy();
                bc.setCopyId(rs.getInt("copy_id"));
                bc.setBookId(rs.getInt("book_id"));
                bc.setCopyCode(rs.getString("copy_code"));
                bc.setStatus(rs.getString("status"));
                list.add(bc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public BookCopy get(int id) {
        String sql = "SELECT copy_id, book_id, copy_code, status FROM BookCopy WHERE copy_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BookCopy bc = new BookCopy();
                bc.setCopyId(rs.getInt("copy_id"));
                bc.setBookId(rs.getInt("book_id"));
                bc.setCopyCode(rs.getString("copy_code"));
                bc.setStatus(rs.getString("status"));
                return bc;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void insert(BookCopy model) {
        String sql = "INSERT INTO BookCopy (book_id, copy_code, status) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getBookId());
            ps.setString(2, model.getCopyCode());
            ps.setString(3, model.getStatus());
            ps.executeUpdate();

            // ✅ Nếu thêm copy AVAILABLE -> auto convert hàng đợi đặt trước
            if (model.getStatus() != null && model.getStatus().equalsIgnoreCase("AVAILABLE")) {
                ReservationDBContext resDao = new ReservationDBContext();
                resDao.processQueueForBook(model.getBookId());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(BookCopy model) {
        // Lấy status cũ để biết có chuyển sang AVAILABLE hay không
        String oldStatus = null;
        try (PreparedStatement ps0 = connection.prepareStatement("SELECT status FROM BookCopy WHERE copy_id = ?")) {
            ps0.setInt(1, model.getCopyId());
            ResultSet rs0 = ps0.executeQuery();
            if (rs0.next()) oldStatus = rs0.getString(1);
        } catch (Exception e) {
            // ignore -> vẫn update như bình thường
        }

        String sql = "UPDATE BookCopy SET book_id = ?, copy_code = ?, status = ? WHERE copy_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getBookId());
            ps.setString(2, model.getCopyCode());
            ps.setString(3, model.getStatus());
            ps.setInt(4, model.getCopyId());
            ps.executeUpdate();

            // ✅ Nếu status vừa chuyển sang AVAILABLE -> auto convert hàng đợi đặt trước
            boolean nowAvailable = model.getStatus() != null && model.getStatus().equalsIgnoreCase("AVAILABLE");
            boolean wasAvailable = oldStatus != null && oldStatus.equalsIgnoreCase("AVAILABLE");
            if (nowAvailable && !wasAvailable) {
                ReservationDBContext resDao = new ReservationDBContext();
                resDao.processQueueForBook(model.getBookId());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(BookCopy model) {
        String sql = "DELETE FROM BookCopy WHERE copy_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getCopyId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<BookCopy> listByBookId(int bookId) {
        ArrayList<BookCopy> list = new ArrayList<>();
        String sql = "SELECT copy_id, book_id, copy_code, status FROM BookCopy WHERE book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookCopy bc = new BookCopy();
                bc.setCopyId(rs.getInt("copy_id"));
                bc.setBookId(rs.getInt("book_id"));
                bc.setCopyCode(rs.getString("copy_code"));
                bc.setStatus(rs.getString("status"));
                list.add(bc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm số bản sao (BookCopy) đang AVAILABLE của 1 cuốn sách.
     */
    public int countAvailableByBookId(int bookId) {
        String sql = "SELECT COUNT(*) FROM BookCopy WHERE book_id = ? AND status = N'AVAILABLE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
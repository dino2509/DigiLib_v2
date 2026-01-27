package dal;

import model.BorrowedBookDTO;
import java.sql.*;
import java.util.ArrayList;

public class BorrowDBContext extends DBContext<BorrowedBookDTO> {

    // 1. Lấy danh sách chi tiết các sách ĐANG MƯỢN (cho trang List)
    public ArrayList<BorrowedBookDTO> getActiveBorrows() {
        ArrayList<BorrowedBookDTO> list = new ArrayList<>();
        String sql = """
            SELECT 
                bi.borrow_item_id, 
                r.full_name, 
                b.title, 
                bc.copy_code, 
                br.borrow_date, 
                bi.due_date, 
                bi.status 
            FROM Borrow_Item bi 
            JOIN Borrow br ON bi.borrow_id = br.borrow_id 
            JOIN Reader r ON br.reader_id = r.reader_id 
            JOIN BookCopy bc ON bi.copy_id = bc.copy_id 
            JOIN Book b ON bc.book_id = b.book_id 
            WHERE bi.status IN ('borrowed', 'overdue') 
            ORDER BY bi.due_date ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Đếm số lượng sách đang mượn (cho trang Dashboard)
    public int countActiveBorrows() {
        String sql = "SELECT COUNT(*) FROM Borrow_Item WHERE status IN ('borrowed', 'overdue')";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Map Helper
    private BorrowedBookDTO map(ResultSet rs) throws SQLException {
        return new BorrowedBookDTO(
            rs.getInt("borrow_item_id"),
            rs.getString("full_name"),
            rs.getString("title"),
            rs.getString("copy_code"),
            rs.getDate("borrow_date"),
            rs.getDate("due_date"),
            rs.getString("status")
        );
    }

    // Override các hàm abstract (để trống nếu không dùng)
    @Override public ArrayList<BorrowedBookDTO> list() { return getActiveBorrows(); }
    @Override public BorrowedBookDTO get(int id) { return null; }
    @Override public void insert(BorrowedBookDTO model) {}
    @Override public void update(BorrowedBookDTO model) {}
    @Override public void delete(BorrowedBookDTO model) {}
    
    public ArrayList<BorrowedBookDTO> searchBorrows(String keyword, String type) {
        ArrayList<BorrowedBookDTO> list = new ArrayList<>();
        
        // SQL cơ bản (lấy phần chung)
        String sql = """
            SELECT 
                bi.borrow_item_id, r.full_name, b.title, bc.copy_code, 
                br.borrow_date, bi.due_date, bi.status 
            FROM Borrow_Item bi 
            JOIN Borrow br ON bi.borrow_id = br.borrow_id 
            JOIN Reader r ON br.reader_id = r.reader_id 
            JOIN BookCopy bc ON bi.copy_id = bc.copy_id 
            JOIN Book b ON bc.book_id = b.book_id 
            WHERE bi.status IN ('borrowed', 'overdue') 
        """;

        // Xử lý SQL động dựa trên type
        if ("reader".equals(type)) {
            sql += " AND r.full_name LIKE ? "; // Chỉ tìm tên người
        } else if ("book".equals(type)) {
            sql += " AND b.title LIKE ? ";     // Chỉ tìm tên sách
        } else {
            // Mặc định: Tìm cả hai
            sql += " AND (r.full_name LIKE ? OR b.title LIKE ?) ";
        }
        
        sql += " ORDER BY bi.due_date ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            
            if ("reader".equals(type) || "book".equals(type)) {
                // Nếu chọn cụ thể, chỉ cần set 1 tham số
                ps.setString(1, searchPattern);
            } else {
                // Nếu chọn "Tất cả", cần set 2 tham số (cho OR)
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}

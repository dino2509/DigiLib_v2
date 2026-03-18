/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dal.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;

import java.sql.PreparedStatement;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;

import model.Fine;

import model.Fine;

import model.Fine;

public class FineDBContext extends DBContext<Fine> {
    
    public void setConnection(Connection conn) {
        this.connection = conn;
    }
    
    public int createOverdueFine(int borrowId, BigDecimal amount, int days) {
        
        String sql = """
        INSERT INTO Fine (
            reader_id,
            borrow_item_id,
            fine_type_id,
            amount,
            reason,
            status,
            created_at
        )
        SELECT 
            b.reader_id,
            bi.borrow_item_id,
            1,
            ?,
            CONCAT('Overdue ', ?, ' days'),
            'UNPAID',
            GETDATE()
        FROM Borrow b
        JOIN Borrow_Item bi ON b.borrow_id = bi.borrow_id
        WHERE b.borrow_id = ?
    """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setBigDecimal(1, amount);
            ps.setInt(2, days);
            ps.setInt(3, borrowId);
            
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    public Integer getFineByBorrowId(int borrowId) {
        
        String sql = """
        SELECT TOP 1 f.fine_id
        FROM Fine f
        JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id
        WHERE bi.borrow_id = ?
    """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public Connection getConnection() {
        return connection;
    }
    
    public BigDecimal getOverdueRate() {
        
        String sql = "SELECT per_day_rate FROM Fine_Type WHERE name = 'OVERDUE'";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("per_day_rate");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return new BigDecimal("5000");
    }
    
    public int createOverdueFine(int borrowId, double amount, int days) {
        
        String sql = """
        INSERT INTO Fine (
            reader_id,
            borrow_item_id,
            fine_type_id,
            amount,
            reason,
            status,
            created_at
        )
        SELECT 
            b.reader_id,
            bi.borrow_item_id,
            1,
            ?,
            CONCAT('Overdue ', ?, ' days'),
            'UNPAID',
            GETDATE()
        FROM Borrow b
        JOIN Borrow_Item bi ON b.borrow_id = bi.borrow_id
        WHERE b.borrow_id = ?
    """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setDouble(1, amount);
            ps.setInt(2, days);
            ps.setInt(3, borrowId);
            
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    public List<Fine> getFinesPaging(Integer readerId, String status,
            Integer typeId, int offset, int pageSize) {
        
        List<Fine> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
        SELECT f.*, ft.name AS type_name, r.full_name
        FROM Fine f
        JOIN Fine_Type ft ON f.fine_type_id = ft.fine_type_id
        JOIN Reader r ON f.reader_id = r.reader_id
        WHERE 1=1
    """);
        
        List<Object> params = new ArrayList<>();
        
        if (readerId != null) {
            sql.append(" AND f.reader_id = ?");
            params.add(readerId);
        }
        
        if (status != null && !status.isEmpty()) {
            sql.append(" AND f.status = ?");
            params.add(status);
        }
        
        if (typeId != null) {
            sql.append(" AND f.fine_type_id = ?");
            params.add(typeId);
        }
        
        sql.append("""
        ORDER BY f.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """);
        
        params.add(offset);
        params.add(pageSize);
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Fine f = new Fine();
                
                f.setFineId(rs.getInt("fine_id"));
                f.setAmount(rs.getBigDecimal("amount"));
                f.setStatus(rs.getString("status"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                
                f.setReaderName(rs.getString("full_name"));
                f.setFineTypeName(rs.getString("type_name"));
                
                list.add(f);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public int countFines(Integer readerId, String status, Integer typeId) {
        
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM Fine f
        WHERE 1=1
    """);
        
        List<Object> params = new ArrayList<>();
        
        if (readerId != null) {
            sql.append(" AND f.reader_id = ?");
            params.add(readerId);
        }
        
        if (status != null && !status.isEmpty()) {
            sql.append(" AND f.status = ?");
            params.add(status);
        }
        
        if (typeId != null) {
            sql.append(" AND f.fine_type_id = ?");
            params.add(typeId);
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public Fine getFineById(int id) {
        
        String sql = """
        SELECT 
            f.fine_id,
            f.reader_id,
            f.borrow_item_id,
            f.fine_type_id,
            f.amount,
            f.reason,
            f.status,
            f.created_at,
            f.paid_at,
            f.handled_by_employee_id,

            r.full_name AS reader_name,
            ft.name AS fine_type_name,
            e.full_name AS employee_name,
            r.email,         
            b.title AS book_title,
            bc.copy_code,
            bi.due_date,
            bi.returned_at

        FROM Fine f
        JOIN Reader r ON f.reader_id = r.reader_id
        JOIN Fine_Type ft ON f.fine_type_id = ft.fine_type_id
        LEFT JOIN Employee e ON f.handled_by_employee_id = e.employee_id
        LEFT JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id
        LEFT JOIN BookCopy bc ON bi.copy_id = bc.copy_id
        LEFT JOIN Book b ON bc.book_id = b.book_id

        WHERE f.fine_id = ?
    """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    
                    Fine f = new Fine();

                    // ========================
                    // BASIC
                    // ========================
                    f.setFineId(rs.getInt("fine_id"));
                    f.setReaderId(rs.getInt("reader_id"));
                    f.setBorrowItemId(rs.getInt("borrow_item_id"));
                    f.setFineTypeId(rs.getInt("fine_type_id"));
                    
                    f.setAmount(rs.getBigDecimal("amount"));
                    f.setReason(rs.getString("reason"));
                    f.setStatus(rs.getString("status"));
                    
                    f.setCreatedAt(rs.getTimestamp("created_at"));
                    f.setPaidAt(rs.getTimestamp("paid_at"));
                    
                    f.setHandledByEmployeeId(
                            (Integer) rs.getObject("handled_by_employee_id")
                    );

                    // ========================
                    // JOIN DATA
                    // ========================
                    f.setReaderName(rs.getString("reader_name"));
                    f.setFineTypeName(rs.getString("fine_type_name"));
                    f.setEmployeeName(rs.getString("employee_name"));
                    
                    f.setBookTitle(rs.getString("book_title"));
                    f.setCopyCode(rs.getString("copy_code"));
                    f.setReaderEmail(rs.getString("email"));
                    f.setDueDate(rs.getTimestamp("due_date"));
                    f.setReturnedAt(rs.getTimestamp("returned_at"));

                    // ========================
                    // COMPUTED
                    // ========================
                    f.setOverdueDays(f.calculateOverdueDays());
                    
                    return f;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public void markAsPaid(int fineId, Integer employeeId, Timestamp paidAt) {
        
        String sql = """
        UPDATE Fine
        SET status = 'PAID',
            paid_at = ?,
            handled_by_employee_id = ?
        WHERE fine_id = ?
    """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setTimestamp(1, paidAt);
            ps.setObject(2, employeeId);
            ps.setInt(3, fineId);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public ArrayList<Fine> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    @Override
    public Fine get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    @Override
    public void insert(Fine model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    @Override
    public void update(Fine model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    @Override
    public void delete(Fine model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

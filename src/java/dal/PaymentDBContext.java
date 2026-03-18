package dao;

import dal.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Payment;

public class PaymentDBContext extends DBContext {

    public boolean existsByFineId(int fineId) {

        String sql = """
        SELECT 1
        FROM Payment
        WHERE fine_id = ?
          AND payment_status = 'PAID'
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, fineId);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void insertFinePayment(int fineId, BigDecimal amount, String method) {

        String sql = """
        INSERT INTO Payment(fine_id, amount, payment_method, payment_status,
                            transaction_code, paid_at, created_at)
        VALUES (?, ?, ?, 'PAID', ?, GETDATE(), GETDATE())
        """;

        PreparedStatement ps = null;

        try {

            ps = connection.prepareStatement(sql);

            ps.setInt(1, fineId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, method);

            String txn = "TXN" + System.currentTimeMillis();
            ps.setString(4, txn);

            int rows = ps.executeUpdate();

            System.out.println("Insert Payment rows = " + rows); // debug

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close(); // chỉ đóng statement
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void setConnection(Connection conn) {
        this.connection = conn;
    }

    public void insertFinePayment(BigDecimal amount,
            String method,
            Timestamp paidAt) {

        String sql = """
        INSERT INTO Payment (
            order_id,
            amount,
            payment_method,
            payment_status,
            transaction_code,
            paid_at,
            created_at
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, 0); // ⚠️ hack vì Payment bắt buộc order_id
            ps.setBigDecimal(2, amount);
            ps.setString(3, method);
            ps.setString(4, "SUCCESS");
            ps.setString(5, "FINE-" + System.currentTimeMillis());
            ps.setTimestamp(6, paidAt);
            ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Payment> getPaymentsByPage(int page, int pageSize, String search, String status) {

        List<Payment> list = new ArrayList<>();

        try {

            String sql = """
        SELECT 
            p.payment_id,
            p.order_id,
            p.fine_id,
            p.amount,
            p.payment_method,
            p.payment_status,
            p.transaction_code,
            p.paid_at,

            CASE 
                WHEN p.fine_id IS NOT NULL THEN 'FINE'
                ELSE 'ORDER'
            END AS type,

            r.full_name

        FROM Payment p

        LEFT JOIN [Order] o ON p.order_id = o.order_id
        LEFT JOIN Fine f ON p.fine_id = f.fine_id

        LEFT JOIN Reader r 
            ON r.reader_id = COALESCE(o.reader_id, f.reader_id)

        WHERE 1=1
        """;

            // 🔍 SEARCH
            if (search != null) {
                sql += """
            AND (
                r.full_name LIKE ?
                OR CAST(p.order_id AS VARCHAR) LIKE ?
                OR CAST(p.fine_id AS VARCHAR) LIKE ?
                OR p.transaction_code LIKE ?
            )
            """;
            }

            // 🎯 STATUS
            if (status != null) {
                sql += " AND p.payment_status = ? ";
            }

            sql += """
        ORDER BY p.paid_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

            PreparedStatement ps = connection.prepareStatement(sql);

            int index = 1;

            // 🔍 set search
            if (search != null) {
                String s = "%" + search + "%";
                ps.setString(index++, s);
                ps.setString(index++, s);
                ps.setString(index++, s);
                ps.setString(index++, s);
            }

            // 🎯 set status
            if (status != null) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Payment p = new Payment();

                p.setPaymentId(rs.getInt("payment_id"));
                p.setOrderId(rs.getInt("order_id"));
                p.setFineId(rs.getInt("fine_id"));

                p.setAmount(rs.getBigDecimal("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setTransactionCode(rs.getString("transaction_code"));
                p.setPaidAt(rs.getTimestamp("paid_at"));

                p.setType(rs.getString("type"));
                p.setReaderName(rs.getString("full_name"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countPayments(String search, String status) {

        try {

            String sql = """
        SELECT COUNT(*)
        FROM Payment p
        JOIN [Order] o ON p.order_id = o.order_id
        JOIN Reader r ON o.reader_id = r.reader_id
        WHERE
        (? IS NULL OR r.full_name LIKE '%' + ? + '%'
                     OR CAST(p.order_id AS VARCHAR) LIKE '%' + ? + '%'
                     OR p.transaction_code LIKE '%' + ? + '%')
        AND
        (? IS NULL OR p.payment_status = ?)
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setString(1, search);
                ps.setString(2, search);
                ps.setString(3, search);
                ps.setString(4, search);

                ps.setString(5, status);
                ps.setString(6, status);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void createPayment(int orderId, double amount, String method) {

        String sql = """
        INSERT INTO Payment(order_id, amount, payment_method, payment_status,
                            transaction_code, paid_at, created_at)
        VALUES (?, ?, ?, 'PAID', ?, GETDATE(), GETDATE())
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setDouble(2, amount);
            ps.setString(3, method);

            String transactionCode = "TXN" + System.currentTimeMillis();
            ps.setString(4, transactionCode);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void completePayment(int paymentId, String transactionCode) {

        String sql = """
        UPDATE Payment
        SET payment_status = 'PAID',
            transaction_code = ?,
            paid_at = GETDATE()
        WHERE payment_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, transactionCode);
            ps.setInt(2, paymentId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Payment> getPaymentsByPage(int page, int pageSize) {

        List<Payment> list = new ArrayList<>();

        try {

            String sql = """
        SELECT p.payment_id,
               p.order_id,
               r.full_name,
               p.amount,
               p.payment_method,
               p.payment_status,
               p.transaction_code,
               p.paid_at
        FROM Payment p
        JOIN [Order] o ON p.order_id = o.order_id
        JOIN Reader r ON o.reader_id = r.reader_id
        ORDER BY p.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Payment p = new Payment();

                p.setPaymentId(rs.getInt("payment_id"));
                p.setOrderId(rs.getInt("order_id"));
                p.setReaderName(rs.getString("full_name"));
                p.setAmount(rs.getBigDecimal("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setTransactionCode(rs.getString("transaction_code"));
                p.setPaidAt(rs.getTimestamp("paid_at"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countPayments() {

        try {

            String sql = "SELECT COUNT(*) FROM Payment";

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public ArrayList list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Object get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void insert(Object model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Object model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Object model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

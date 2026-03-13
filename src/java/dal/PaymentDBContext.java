package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Payment;

public class PaymentDBContext extends DBContext {

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

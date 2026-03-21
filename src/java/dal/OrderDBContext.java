package dao;

import dal.DBContext;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;
import model.CartItem;
import model.Order;
import model.OrderBook;
import model.OrderItem;

public class OrderDBContext extends DBContext {

    public List<OrderItem> getOrdersByReaderPaging(int readerId, int page, int pageSize) {

        List<OrderItem> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY o.created_at DESC) AS row_num,
                   o.order_id, o.status, o.created_at,
                   ob.price, ob.quantity,
                   b.title
            FROM [Order] o
            JOIN Order_Book ob ON o.order_id = ob.order_id
            JOIN Book b ON ob.book_id = b.book_id
            WHERE o.reader_id = ?
        ) t
        WHERE row_num BETWEEN ? AND ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;

            ps.setInt(1, readerId);
            ps.setInt(2, start);
            ps.setInt(3, end);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem o = new OrderItem();
                o.setOrderId(rs.getInt("order_id"));
                o.setBookTitle(rs.getString("title"));
                o.setPrice(rs.getBigDecimal("price"));
                o.setQuantity(rs.getInt("quantity"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countOrdersByReader(int readerId) {

        String sql = """
        SELECT COUNT(DISTINCT o.order_id)
        FROM [Order] o
        WHERE o.reader_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void confirmQRPayment(int orderId) {

        String transactionCode = "QR-" + orderId + "-" + System.currentTimeMillis();

        String sql1 = """
        UPDATE Payment
        SET payment_status = 'SUCCESS',
            transaction_code = ?,
            paid_at = GETDATE(),
            expired_at = NULL         -- 🔥 QUAN TRỌNG
        WHERE order_id = ?
    """;

        String sql2 = """
        UPDATE [Order]
        SET status = 'WAITING_PICKUP',
            expired_at = NULL         -- 🔥 QUAN TRỌNG
        WHERE order_id = ?
    """;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps1 = connection.prepareStatement(sql1); PreparedStatement ps2 = connection.prepareStatement(sql2)) {

                ps1.setString(1, transactionCode);
                ps1.setInt(2, orderId);

                ps2.setInt(1, orderId);

                ps1.executeUpdate();
                ps2.executeUpdate();

                connection.commit();

            }

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
            }
        }
    }

    public boolean isOrderOwnedByReader(int orderId, int readerId) {
        String sql = "SELECT 1 FROM [Order] WHERE order_id = ? AND reader_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, readerId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public String getOrderStatus(int orderId) {
        String sql = "SELECT status FROM [Order] WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("status");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public String getPaymentStatus(int orderId) {
        String sql = "SELECT payment_status FROM Payment WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean isOrderExpired(int orderId) {
        String sql = """
        SELECT 1 FROM [Order]
        WHERE order_id = ?
        AND expired_at < SYSDATETIME()
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public String generateQRUrl(int orderId, double amount) {

        // 🔥 cấu hình của bạn
        String bankId = "970422";        // MB Bank (có thể đổi)
        String accountNo = "0333740740";  // STK của bạn

        String description = "DigiLib " + orderId;

        return "https://img.vietqr.io/image/"
                + bankId + "-" + accountNo + "-compact2.png"
                + "?amount=" + (int) amount
                + "&addInfo=" + URLEncoder.encode(description, StandardCharsets.UTF_8);
    }

    public String getReaderName(int orderId) {
        String sql = """
        SELECT r.full_name
        FROM [Order] o
        JOIN Reader r ON o.reader_id = r.reader_id
        WHERE o.order_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "Unknown";
    }

    public double getOrderTotal(int orderId) {
        String sql = "SELECT total_amount FROM [Order] WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total_amount");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public String getPaymentMethod(int orderId) {
        String sql = "SELECT payment_method FROM Payment WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("payment_method");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void cancelOrder(int orderId) {

        try {
            connection.setAutoCommit(false);

            // 🔹 update payment
            String paymentSql = """
            UPDATE Payment
            SET payment_status = 'FAILED'
            WHERE order_id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(paymentSql)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            // 🔹 update order
            String orderSql = """
            UPDATE [Order]
            SET status = 'FAILED'
            WHERE order_id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(orderSql)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            throw new RuntimeException(e);

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
            }
        }
    }

    public boolean isOrderBelongToReader(int orderId, int readerId) {

        String sql = "SELECT COUNT(*) FROM [Order] WHERE order_id = ? AND reader_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, readerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // 🔹 1. GET CART ITEMS
    // =========================
    public List<CartItem> getCartItemsByIds(String[] ids) {
        List<CartItem> list = new ArrayList<>();

        if (ids == null || ids.length == 0) {
            return list;
        }

        StringBuilder sql = new StringBuilder(
                "SELECT ci.cart_item_id, ci.book_id, ci.quantity, b.title, b.price, b.currency "
                + "FROM Cart_Item ci "
                + "JOIN Book b ON ci.book_id = b.book_id "
                + "WHERE ci.cart_item_id IN ("
        );

        for (int i = 0; i < ids.length; i++) {
            sql.append("?");
            if (i < ids.length - 1) {
                sql.append(",");
            }
        }
        sql.append(")");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setBookTitle(rs.getString("title"));
                    item.setPrice(rs.getDouble("price"));
                    item.setCurrency(rs.getString("currency"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void expireQRPayments() {

        String sqlOrder = """
        UPDATE o
        SET o.status = 'FAILED'
        FROM [Order] o
        JOIN Payment p ON o.order_id = p.order_id
        WHERE o.status = 'WAITING_PAYMENT'
        AND p.payment_method = 'QR'
        AND o.expired_at IS NOT NULL
        AND o.expired_at < GETDATE()
    """;

        String sqlPayment = """
        UPDATE Payment
        SET payment_status = 'FAILED'
        WHERE payment_status = 'PENDING'
        AND payment_method = 'QR'
        AND expired_at IS NOT NULL
        AND expired_at < GETDATE()
    """;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps1 = connection.prepareStatement(sqlOrder); PreparedStatement ps2 = connection.prepareStatement(sqlPayment)) {

                ps1.executeUpdate();
                ps2.executeUpdate();

                connection.commit();
            }

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
            }
        }
    }

    public int createFullOrderQR(int readerId, List<CartItem> items, double total, String paymentMethod) {

        int orderId = -1;

        try {
            connection.setAutoCommit(false);

            // 🔥 1. INSERT ORDER (có expired_at)
            String orderSql = """
            INSERT INTO [Order] (reader_id, total_amount, currency, status, created_at, expired_at)
            VALUES (?, ?, ?, ?, GETDATE(), 
                CASE 
                    WHEN ? = 'QR' THEN DATEADD(MINUTE, 15, GETDATE()) 
                    ELSE NULL 
                END
            )
        """;

            try (PreparedStatement psOrder = connection.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {

                psOrder.setInt(1, readerId);
                psOrder.setDouble(2, total);
                psOrder.setString(3, items.get(0).getCurrency());
                psOrder.setString(4, "WAITING_PAYMENT"); // 🔥 FIX
                psOrder.setString(5, paymentMethod);     // dùng cho CASE

                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            // 🔥 2. INSERT ORDER_BOOK
            String itemSql = "INSERT INTO Order_Book (order_id, book_id, price, quantity) VALUES (?, ?, ?, ?)";

            try (PreparedStatement psItem = connection.prepareStatement(itemSql)) {

                for (CartItem item : items) {
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getBookId());
                    psItem.setDouble(3, item.getPrice());
                    psItem.setInt(4, item.getQuantity());
                    psItem.addBatch();
                }

                psItem.executeBatch();
            }

            // 🔥 3. INSERT PAYMENT (có expired_at)
            String paySql = """
            INSERT INTO Payment (order_id, amount, payment_method, payment_status, created_at, expired_at)
            VALUES (?, ?, ?, ?, GETDATE(),
                CASE 
                    WHEN ? = 'QR' THEN DATEADD(MINUTE, 15, GETDATE()) 
                    ELSE NULL 
                END
            )
        """;

            try (PreparedStatement psPay = connection.prepareStatement(paySql)) {

                psPay.setInt(1, orderId);
                psPay.setDouble(2, total);
                psPay.setString(3, paymentMethod);
                psPay.setString(4, "PENDING"); // 🔥 FIX
                psPay.setString(5, paymentMethod);

                psPay.executeUpdate();
            }

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            throw new RuntimeException(e);

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
            }
        }

        return orderId;
    }

    // =========================
    // 🔹 2. CREATE FULL ORDER
    // =========================
    public int createFullOrder(int readerId, List<CartItem> items, double total, String paymentMethod) {

        int orderId = -1;

        try {
            connection.setAutoCommit(false);

            // 1. INSERT ORDER
            String orderSql = "INSERT INTO [Order] (reader_id, total_amount, currency, status, created_at) "
                    + "VALUES (?, ?, ?, ?, GETDATE())";

            try (PreparedStatement psOrder = connection.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {

                psOrder.setInt(1, readerId);
                psOrder.setDouble(2, total);
                psOrder.setString(3, items.get(0).getCurrency());
                psOrder.setString(4, "INIT");

                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            // 2. INSERT ORDER_BOOK
            String itemSql = "INSERT INTO Order_Book (order_id, book_id, price, quantity) VALUES (?, ?, ?, ?)";

            try (PreparedStatement psItem = connection.prepareStatement(itemSql)) {

                for (CartItem item : items) {
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getBookId());
                    psItem.setDouble(3, item.getPrice());
                    psItem.setInt(4, item.getQuantity());
                    psItem.addBatch();
                }

                psItem.executeBatch();
            }

            // 3. INSERT PAYMENT
            String paySql = "INSERT INTO Payment (order_id, amount, payment_method, payment_status, created_at) "
                    + "VALUES (?, ?, ?, ?, GETDATE())";

            try (PreparedStatement psPay = connection.prepareStatement(paySql)) {

                psPay.setInt(1, orderId);
                psPay.setDouble(2, total);
                psPay.setString(3, paymentMethod);
                psPay.setString(4, "INIT");

                psPay.executeUpdate();
            }

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            throw new RuntimeException(e);

        } finally {
            try {
                connection.setAutoCommit(true); // 🔥 BẮT BUỘC
            } catch (Exception e) {
            }
        }

        return orderId;
    }

    // =========================
    // 🔹 3. UPDATE ORDER STATUS
    // =========================
    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET status = ? WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // 🔹 4. UPDATE PAYMENT STATUS
    // =========================
    public void updatePaymentStatus(int orderId, String status, String transactionCode) {

        String sql = "UPDATE Payment SET payment_status = ?, transaction_code = ?, paid_at = GETDATE() "
                + "WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, transactionCode);
            ps.setInt(3, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // 🔹 5. REMOVE CART ITEMS
    // =========================
    public void removeCartItems(String[] ids) {

        if (ids == null || ids.length == 0) {
            return;
        }

        StringBuilder sql = new StringBuilder("DELETE FROM Cart_Item WHERE cart_item_id IN (");

        for (int i = 0; i < ids.length; i++) {
            sql.append("?");
            if (i < ids.length - 1) {
                sql.append(",");
            }
        }
        sql.append(")");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // 🔹 6. GET EMAIL
    // =========================
    public String getReaderEmailByOrder(int orderId) {

        String sql = "SELECT r.email FROM [Order] o "
                + "JOIN Reader r ON o.reader_id = r.reader_id "
                + "WHERE o.order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("email");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // 🔹 7. VNPAY URL
    // =========================
    public String createVNPayPayment(int orderId, double total) {
        return "http://sandbox.vnpayment.vn/payment?orderId=" + orderId + "&amount=" + total;
    }

    // =========================
    // 🔹 8. EMAIL - WAITING PAYMENT (CASH)
    // =========================
    public void sendWaitingPaymentEmail(String email, int orderId) {
        System.out.println("EMAIL: Please come to library to pay");
        System.out.println("Order: " + orderId);
    }

    // =========================
    // 🔹 9. EMAIL - VNPAY SUCCESS
    // =========================
    public void sendPaymentSuccessEmail(String email, int orderId) {
        System.out.println("EMAIL: Payment success - come pick up books");
    }

    // =========================
    // 🔹 10. EMAIL - INVOICE
    // =========================
    public void sendInvoiceEmail(String email, int orderId) {
        System.out.println("EMAIL: Invoice sent for order " + orderId);
    }

    // =========================
    // 🔹 11. LIBRARIAN CONFIRM CASH
    // =========================
    public void confirmCashPayment(int orderId) {

        try {
            connection.setAutoCommit(false);

            String updatePayment = """
            UPDATE Payment 
            SET payment_status = 'SUCCESS',
                transaction_code = ?,
                paid_at = GETDATE()
            WHERE order_id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(updatePayment)) {
                ps.setString(1, "CASH_" + System.currentTimeMillis());
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            String updateOrder = "UPDATE [Order] SET status = 'COMPLETED' WHERE order_id = ?";

            try (PreparedStatement ps = connection.prepareStatement(updateOrder)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            throw new RuntimeException(e);

        } finally {
            try {
                connection.setAutoCommit(true); // 🔥 FIX TREO
            } catch (Exception e) {
            }
        }
    }

    public void updatePaymentStatus(int orderId, String status) {
        String sql = "UPDATE Payment SET payment_status = ?, paid_at = GETDATE() WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Order> getAllOrders() {

        List<Order> list = new ArrayList<>();

        try {

            String sql = """
            SELECT o.order_id,
                   o.reader_id,
                   r.full_name,
                   o.total_amount,
                   o.currency,
                   o.status,
                   o.created_at
            FROM [Order] o
            JOIN Reader r ON o.reader_id = r.reader_id
            ORDER BY o.created_at DESC
        """;

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Order o = new Order();

                o.setOrderId(rs.getInt("order_id"));
                o.setReaderId(rs.getInt("reader_id"));
                o.setReaderName(rs.getString("full_name"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setCurrency(rs.getString("currency"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<OrderItem> getOrdersByReader(int readerId) {

        List<OrderItem> list = new ArrayList<>();

        String sql = """
            SELECT o.order_id,
                   b.title AS book_title,
                   ob.price,
                   ob.quantity,
                   (ob.price * ob.quantity) AS total,
                   o.status,
                   o.created_at
            FROM [Order] o
            JOIN Order_Book ob ON o.order_id = ob.order_id
            JOIN Book b ON ob.book_id = b.book_id
            WHERE o.reader_id = ?
            ORDER BY o.created_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    OrderItem item = new OrderItem();

                    item.setOrderId(rs.getInt("order_id"));
                    item.setBookTitle(rs.getString("book_title"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTotal(rs.getBigDecimal("total"));
                    item.setStatus(rs.getString("status"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Order getOrderById(int orderId) {

        String sql = """
        SELECT o.order_id,
               o.reader_id,
               r.full_name,
               o.total_amount,
               o.currency,
               o.status,
               o.created_at
        FROM [Order] o
        JOIN Reader r ON o.reader_id = r.reader_id
        WHERE o.order_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setReaderId(rs.getInt("reader_id"));
                    o.setReaderName(rs.getString("full_name"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    o.setCurrency(rs.getString("currency"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    return o;
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    public List<OrderBook> getOrderBooks(int orderId) {

        List<OrderBook> list = new ArrayList<>();

        String sql = """
            SELECT ob.order_book_id,
                   ob.order_id,
                   ob.book_id,
                   ob.price,
                   ob.quantity,
                   b.title
            FROM Order_Book ob
            JOIN Book b ON ob.book_id = b.book_id
            WHERE ob.order_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    OrderBook ob = new OrderBook();

                    ob.setOrderBookId(rs.getInt("order_book_id"));
                    ob.setOrderId(rs.getInt("order_id"));
                    ob.setBookId(rs.getInt("book_id"));
                    ob.setPrice(rs.getBigDecimal("price"));
                    ob.setQuantity(rs.getInt("quantity"));
                    ob.setBookTitle(rs.getString("title"));

                    list.add(ob);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int createOrder(int readerId, double totalAmount) {

        String sql = """
            INSERT INTO [Order] (reader_id, total_amount, currency, status, created_at)
            VALUES (?, ?, 'VND' , 'PAID', GETDATE());
            SELECT SCOPE_IDENTITY();
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);
            ps.setDouble(2, totalAmount);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public void insertOrderBook(int orderId, int bookId, double price, int quantity) {

        String sql = """
            INSERT INTO Order_Book (order_id, book_id, price, quantity)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, bookId);
            ps.setDouble(3, price);
            ps.setInt(4, quantity);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<CartItem> getCartItemsWithPrice(int cartId) {

        List<CartItem> list = new ArrayList<>();

        String sql = """
            SELECT ci.cart_item_id,
                   ci.book_id,
                   ci.quantity,
                   b.title,
                   b.price
            FROM Cart_Item ci
            JOIN Book b ON ci.book_id = b.book_id
            WHERE ci.cart_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, cartId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    CartItem item = new CartItem();

                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setBookTitle(rs.getString("title"));
                    item.setPrice(rs.getDouble("price"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Order> getOrdersByPage(int page, int pageSize) {

        List<Order> list = new ArrayList<>();

        try {

            String sql = """
            SELECT o.order_id,
                   o.reader_id,
                   r.full_name,
                   o.total_amount,
                   o.currency,
                   o.status,
                   o.created_at
            FROM [Order] o
            JOIN Reader r ON o.reader_id = r.reader_id
            ORDER BY o.created_at DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Order o = new Order();

                o.setOrderId(rs.getInt("order_id"));
                o.setReaderId(rs.getInt("reader_id"));
                o.setReaderName(rs.getString("full_name"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setCurrency(rs.getString("currency"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countOrders() {

        try {

            String sql = "SELECT COUNT(*) FROM [Order]";

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

    public List<Order> getOrdersByPage(int page, int pageSize, String search, String status) {

        List<Order> list = new ArrayList<>();

        try {

            String sql = """
        SELECT o.order_id,
               o.reader_id,
               r.full_name,
               o.total_amount,
               o.currency,
               o.status,
               o.created_at
        FROM [Order] o
        JOIN Reader r ON o.reader_id = r.reader_id
        WHERE
        (? IS NULL OR r.full_name LIKE '%' + ? + '%' 
                     OR CAST(o.order_id AS VARCHAR) LIKE '%' + ? + '%')
        AND
        (? IS NULL OR o.status = ?)
        ORDER BY o.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setString(1, search);
                ps.setString(2, search);
                ps.setString(3, search);

                ps.setString(4, status);
                ps.setString(5, status);

                ps.setInt(6, (page - 1) * pageSize);
                ps.setInt(7, pageSize);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        Order o = new Order();

                        o.setOrderId(rs.getInt("order_id"));
                        o.setReaderId(rs.getInt("reader_id"));
                        o.setReaderName(rs.getString("full_name"));
                        o.setTotalAmount(rs.getBigDecimal("total_amount"));
                        o.setCurrency(rs.getString("currency"));
                        o.setStatus(rs.getString("status"));
                        o.setCreatedAt(rs.getTimestamp("created_at"));

                        list.add(o);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countOrders(String search, String status) {

        try {

            String sql = """
        SELECT COUNT(*)
        FROM [Order] o
        JOIN Reader r ON o.reader_id = r.reader_id
        WHERE
        (? IS NULL OR r.full_name LIKE '%' + ? + '%' 
                     OR CAST(o.order_id AS VARCHAR) LIKE '%' + ? + '%')
        AND
        (? IS NULL OR o.status = ?)
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {

                ps.setString(1, search);
                ps.setString(2, search);
                ps.setString(3, search);

                ps.setString(4, status);
                ps.setString(5, status);

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

    public void clearCart(int cartId) {

        String sql = "DELETE FROM Cart_Item WHERE cart_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
//
//    public List<CartItem> getCartItemsByIds(String[] ids) {
//
//        List<CartItem> list = new ArrayList<>();
//
//        if (ids == null || ids.length == 0) {
//            return list;
//        }
//
//        StringBuilder sql = new StringBuilder("""
//        SELECT ci.cart_item_id,
//               ci.book_id,
//               ci.quantity,
//               b.title,
//               b.price
//        FROM Cart_Item ci
//        JOIN Book b ON ci.book_id = b.book_id
//        WHERE ci.cart_item_id IN (
//    """);
//
//        for (int i = 0; i < ids.length; i++) {
//            sql.append("?");
//            if (i < ids.length - 1) {
//                sql.append(",");
//            }
//        }
//
//        sql.append(")");
//
//        try {
//
//            PreparedStatement ps = connection.prepareStatement(sql.toString());
//
//            for (int i = 0; i < ids.length; i++) {
//                ps.setInt(i + 1, Integer.parseInt(ids[i]));
//            }
//
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//
//                CartItem item = new CartItem();
//
//                item.setCartItemId(rs.getInt("cart_item_id"));
//                item.setBookId(rs.getInt("book_id"));
//                item.setQuantity(rs.getInt("quantity"));
//                item.setBookTitle(rs.getString("title"));
//                item.setPrice(rs.getDouble("price"));
//
//                list.add(item);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }

    // DBContext abstract methods
    @Override
    public ArrayList list() {
        return new ArrayList();
    }

    @Override
    public Object get(int id) {
        return null;
    }

    @Override
    public void insert(Object model) {
    }

    @Override
    public void update(Object model) {
    }

    @Override
    public void delete(Object model) {
    }
}

package dao;

import dal.DBContext;
import java.sql.*;
import java.util.*;
import model.CartItem;
import model.Order;
import model.OrderBook;
import model.OrderItem;

public class OrderDBContext extends DBContext {

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

    public void clearCart(int cartId) {

        String sql = "DELETE FROM Cart_Item WHERE cart_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<CartItem> getCartItemsByIds(String[] ids) {

        List<CartItem> list = new ArrayList<>();

        if (ids == null || ids.length == 0) {
            return list;
        }

        StringBuilder sql = new StringBuilder("""
        SELECT ci.cart_item_id,
               ci.book_id,
               ci.quantity,
               b.title,
               b.price
        FROM Cart_Item ci
        JOIN Book b ON ci.book_id = b.book_id
        WHERE ci.cart_item_id IN (
    """);

        for (int i = 0; i < ids.length; i++) {
            sql.append("?");
            if (i < ids.length - 1) {
                sql.append(",");
            }
        }

        sql.append(")");

        try {

            PreparedStatement ps = connection.prepareStatement(sql.toString());

            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                CartItem item = new CartItem();

                item.setCartItemId(rs.getInt("cart_item_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setBookTitle(rs.getString("title"));
                item.setPrice(rs.getDouble("price"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

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

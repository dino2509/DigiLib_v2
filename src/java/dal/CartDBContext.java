package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;

public class CartDBContext extends DBContext<CartItem> {

    public List<CartItem> getCartItemsFull(int cartId) {
        List<CartItem> list = new ArrayList<>();

        String sql = """
        SELECT ci.cart_item_id,
               ci.quantity,
               b.book_id,
               b.title,
               b.price,
               b.currency,
               b.cover_url,
               a.author_name
        FROM Cart_Item ci
        JOIN Book b ON ci.book_id = b.book_id
        JOIN Author a ON b.author_id = a.author_id
        WHERE ci.cart_id = ?
        ORDER BY ci.cart_item_id DESC
    """;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, cartId);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();

                item.setCartItemId(rs.getInt("cart_item_id"));
                item.setQuantity(rs.getInt("quantity"));

                item.setBookTitle(rs.getString("title"));
                item.setPrice(rs.getDouble("price"));
                item.setCurrency(rs.getString("currency"));
                item.setCoverUrl(rs.getString("cover_url"));
                item.setAuthorName(rs.getString("author_name"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // lấy cart của reader
    public int getCartIdByReader(int readerId) {

        String sql = """
                     SELECT cart_id
                     FROM Cart
                     WHERE reader_id = ?
                     AND status = 'ACTIVE'
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("cart_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return createCart(readerId);
    }

    // tạo cart mới
    public int createCart(int readerId) {

        String sql = """
                     INSERT INTO Cart (reader_id, status, created_at)
                     VALUES (?, 'ACTIVE', GETDATE());
                     SELECT SCOPE_IDENTITY();
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

        return -1;
    }

    // lấy danh sách cart item
    public List<CartItem> getCartItems(int cartId) {

        List<CartItem> list = new ArrayList<>();

        String sql = """
                     SELECT ci.cart_item_id,
                            ci.cart_id,
                            ci.book_id,
                            ci.quantity,
                            ci.added_at,
                            b.title AS book_title
                     FROM Cart_Item ci
                     JOIN Book b ON ci.book_id = b.book_id
                     WHERE ci.cart_id = ?
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, cartId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                CartItem item = new CartItem();

                item.setCartItemId(rs.getInt("cart_item_id"));
                item.setCartId(rs.getInt("cart_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setAddedAt(rs.getTimestamp("added_at"));
                item.setBookTitle(rs.getString("book_title"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // thêm sách vào cart
    public void addToCart(int cartId, int bookId) {

        String checkSql = """
                          SELECT quantity
                          FROM Cart_Item
                          WHERE cart_id = ? AND book_id = ?
                          """;

        try (PreparedStatement check = connection.prepareStatement(checkSql)) {

            check.setInt(1, cartId);
            check.setInt(2, bookId);

            ResultSet rs = check.executeQuery();

            if (rs.next()) {

                String updateSql = """
                                   UPDATE Cart_Item
                                   SET quantity = quantity + 1
                                   WHERE cart_id = ? AND book_id = ?
                                   """;

                try (PreparedStatement ps = connection.prepareStatement(updateSql)) {

                    ps.setInt(1, cartId);
                    ps.setInt(2, bookId);
                    ps.executeUpdate();
                }

            } else {

                String insertSql = """
                                   INSERT INTO Cart_Item(cart_id, book_id, quantity, added_at)
                                   VALUES (?, ?, 1, GETDATE())
                                   """;

                try (PreparedStatement ps = connection.prepareStatement(insertSql)) {

                    ps.setInt(1, cartId);
                    ps.setInt(2, bookId);
                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateQuantity(int cartItemId, int quantity) {

        String sql = "UPDATE Cart_Item SET quantity = ? WHERE cart_item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // xóa cart item
    public boolean removeCartItem(int cartItemId) {

        String sql = "DELETE FROM Cart_Item WHERE cart_item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, cartItemId);

            int rows = ps.executeUpdate();

            return rows > 0; // ✔ biết có xoá thành công không

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // abstract methods (không dùng)
    @Override
    public ArrayList<CartItem> list() {
        return new ArrayList<>();
    }

    @Override
    public CartItem get(int id) {
        return null;
    }

    @Override
    public void insert(CartItem model) {
    }

    @Override
    public void update(CartItem model) {
    }

    @Override
    public void delete(CartItem model) {
    }
}

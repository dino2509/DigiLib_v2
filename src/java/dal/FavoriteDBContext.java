package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Book;
import model.FavoriteItem;

/**
 * Favorites dùng Cart/Cart_Item (status='FAVORITES').
 * Không cần tạo bảng mới.
 */
public class FavoriteDBContext extends DBContext<FavoriteItem> {

    private static final String FAVORITES_STATUS = "FAVORITES";

    @Override
    public ArrayList<FavoriteItem> list() {
        throw new UnsupportedOperationException("Use listFavoritesByReader(readerId)");
    }

    @Override
    public FavoriteItem get(int id) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void insert(FavoriteItem model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void update(FavoriteItem model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void delete(FavoriteItem model) {
        throw new UnsupportedOperationException("Not supported");
    }

    public int getOrCreateFavoritesCartId(int readerId) {
        Integer cartId = findFavoritesCartId(readerId);
        if (cartId != null) return cartId;

        String insert = "INSERT INTO Cart (reader_id, status, created_at, updated_at) VALUES (?, ?, GETDATE(), GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(insert, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, readerId);
            ps.setString(2, FAVORITES_STATUS);
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        cartId = findFavoritesCartId(readerId);
        return cartId != null ? cartId : -1;
    }

    private Integer findFavoritesCartId(int readerId) {
        String sql = "SELECT TOP 1 cart_id FROM Cart WHERE reader_id = ? AND status = ? ORDER BY cart_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setString(2, FAVORITES_STATUS);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("cart_id");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<FavoriteItem> listFavoritesByReader(int readerId) {
        ArrayList<FavoriteItem> list = new ArrayList<>();
        int cartId = getOrCreateFavoritesCartId(readerId);
        if (cartId <= 0) return list;

        String sql =
                "SELECT "
                + " ci.cart_item_id, ci.cart_id, ci.book_id, ci.quantity, ci.added_at, "
                + " b.title, b.cover_url, b.currency, b.price "
                + "FROM Cart_Item ci "
                + "INNER JOIN Book b ON b.book_id = ci.book_id "
                + "WHERE ci.cart_id = ? "
                + "ORDER BY ci.added_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FavoriteItem it = new FavoriteItem();
                it.setCartItemId(rs.getInt("cart_item_id"));
                it.setCartId(rs.getInt("cart_id"));
                it.setQuantity(rs.getInt("quantity"));
                it.setAddedAt(rs.getTimestamp("added_at"));

                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                b.setCurrency(rs.getString("currency"));
                b.setPrice(rs.getBigDecimal("price"));
                it.setBook(b);

                list.add(it);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean isFavorite(int readerId, int bookId) {
        Integer cartId = findFavoritesCartId(readerId);
        if (cartId == null) return false;

        String sql = "SELECT 1 FROM Cart_Item WHERE cart_id = ? AND book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void addFavorite(int readerId, int bookId) {
        int cartId = getOrCreateFavoritesCartId(readerId);
        if (cartId <= 0) return;

        String check = "SELECT 1 FROM Cart_Item WHERE cart_id = ? AND book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(check)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return;
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        String insert = "INSERT INTO Cart_Item (cart_id, book_id, quantity, added_at) VALUES (?, ?, 1, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(insert)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        touchCart(cartId);
    }

    public void removeFavorite(int readerId, int bookId) {
        Integer cartId = findFavoritesCartId(readerId);
        if (cartId == null) return;

        String del = "DELETE FROM Cart_Item WHERE cart_id = ? AND book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(del)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        touchCart(cartId);
    }

    private void touchCart(int cartId) {
        String sql = "UPDATE Cart SET updated_at = GETDATE() WHERE cart_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (Exception e) {
            // ignore
        }
    }
}

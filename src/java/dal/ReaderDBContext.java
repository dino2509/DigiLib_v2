package dal;

import java.security.Timestamp;
import model.Reader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReaderDBContext extends DBContext<Reader> {

    // =========================
    // LIST ALL READERS
    // =========================
    @Override
    public ArrayList<Reader> list() {
        ArrayList<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Reader";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                readers.add(mapReader(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return readers;
    }

    // =========================
    // GET READER BY ID
    // =========================
    @Override
    public Reader get(int id) {
        String sql = "SELECT * FROM Reader WHERE reader_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapReader(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // =========================
    // INSERT READER
    // =========================
    @Override
    public void insert(Reader r) {
        String sql = """
            INSERT INTO Reader
            (full_name, email, password_hash, phone, avatar, status, role_id)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, r.getFullName());
            ps.setString(2, r.getEmail());
            ps.setString(3, r.getPasswordHash());
            ps.setString(4, r.getPhone());
            ps.setString(5, r.getAvatar());
            ps.setString(6, r.getStatus());
            ps.setInt(7, r.getRoleId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // UPDATE READER
    // =========================
    @Override
    public void update(Reader r) {
        String sql = """
            UPDATE Reader
            SET full_name = ?,
                email = ?,
                phone = ?,
                avatar = ?,
                status = ?,
                role_id = ?
            WHERE reader_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, r.getFullName());
            ps.setString(2, r.getEmail());
            ps.setString(3, r.getPhone());
            ps.setString(4, r.getAvatar());
            ps.setString(5, r.getStatus());
            ps.setInt(6, r.getRoleId());
            ps.setInt(7, r.getReaderId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // DELETE READER (HARD DELETE)
    // =========================
    @Override
    public void delete(Reader r) {
        String sql = "DELETE FROM Reader WHERE reader_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, r.getReaderId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void updatePassword(int readerId, String newPasswordHash) {
        String sql = "UPDATE Reader SET password_hash = ? WHERE reader_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, readerId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Reader getByEmail(String email) {
        String sql = "SELECT * FROM Reader WHERE email = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapReader(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public int insertId(Reader r) {
        String sql = """
        INSERT INTO Reader
        (full_name, email, password_hash, phone, avatar, status, role_id)
        OUTPUT INSERTED.reader_id
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, r.getFullName());
            ps.setString(2, r.getEmail());

            // ⚠️ BẮT BUỘC cho Google login
            ps.setString(3,
                    r.getPasswordHash() != null ? r.getPasswordHash() : "GOOGLE");

            ps.setString(4, r.getPhone());
            ps.setString(5, r.getAvatar());
            ps.setString(6, r.getStatus());
            ps.setInt(7, r.getRoleId());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("reader_id");
            }

        } catch (SQLException ex) {
            Logger.getLogger(ReaderDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public void insert(Reader r, String passwordHash) {
        String sql = """
        INSERT INTO Reader
        (full_name, email, password_hash, phone, status, created_at, role_id)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getFullName());
            ps.setString(2, r.getEmail());
            ps.setString(3, passwordHash);
            ps.setString(4, r.getPhone());
            ps.setString(5, r.getStatus());
//            ps.setTimestamp(5, r.getCreatedAt());

            ps.setObject(5, LocalDateTime.now());
            ps.setInt(7, r.getRoleId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static class ResetInfo {

        private int userId;
        private String userType;

        public ResetInfo(int userId, String userType) {
            this.userId = userId;
            this.userType = userType;
        }

        public int getUserId() {
            return userId;
        }

        public String getUserType() {
            return userType;
        }
    }

    /* =========================
       1. GET READER BY EMAIL
       ========================= */
    public Reader getReaderByEmail(String email) {
        String sql = """
            SELECT reader_id, full_name, email, password_hash
            FROM Reader
            WHERE email = ?
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                Reader r = new Reader();
                r.setReaderId(rs.getInt("reader_id"));
                r.setFullName(rs.getString("full_name"));
                r.setEmail(rs.getString("email"));
                r.setPasswordHash(rs.getString("password_hash"));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /* =========================
       2. INSERT RESET TOKEN
       ========================= */
    public void insertResetToken(String type, int userId,
            String token, LocalDateTime expiredAt) {

        String sql = """
            INSERT INTO Password_Reset
            (user_type, user_id, token, expired_at, used, created_at)
            VALUES (?, ?, ?, ?, 0, ?)
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, type);
            stm.setInt(2, userId);
            stm.setString(3, token);
            stm.setObject(5, LocalDateTime.now());
            stm.setObject(4, expiredAt);
//            stm.setTimestamp(4, Timestamp.valueOf(expiredAt));
//            stm.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* =========================
       3. CHECK TOKEN VALID
       ========================= */
    public boolean isValidToken(String token) {
        String sql = """
            SELECT 1
            FROM Password_Reset
            WHERE token = ?
              AND used = 0
              AND expired_at > SYSDATETIME()
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, token);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* =========================
       4. GET RESET INFO
       ========================= */
    public ResetInfo getResetInfo(String token) {
        String sql = """
            SELECT user_id, user_type
            FROM Password_Reset
            WHERE token = ?
              AND used = 0
              AND expired_at > SYSDATETIME()
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, token);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                return new ResetInfo(
                        rs.getInt("user_id"),
                        rs.getString("user_type")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /* =========================
       5. UPDATE READER PASSWORD
       ========================= */
    public void updateReaderPassword(int readerId, String hash) {
        String sql = """
            UPDATE Reader
            SET password_hash = ?
            WHERE reader_id = ?
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, hash);
            stm.setInt(2, readerId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* =========================
       6. MARK TOKEN USED
       ========================= */
    public void markTokenUsed(String token) {
        String sql = """
            UPDATE Password_Reset
            SET used = 1
            WHERE token = ?
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, token);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =========================
    // MAP RESULTSET → READER
    // =========================
    private Reader mapReader(ResultSet rs) throws SQLException {
        Reader r = new Reader();
        r.setReaderId(rs.getInt("reader_id"));
        r.setFullName(rs.getNString("full_name"));
        r.setEmail(rs.getString("email"));
        r.setPasswordHash(rs.getString("password_hash"));
        r.setPhone(rs.getString("phone"));
        r.setAvatar(rs.getString("avatar"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        r.setRoleId(rs.getInt("role_id"));
        return r;
    }
}

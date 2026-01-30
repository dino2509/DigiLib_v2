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

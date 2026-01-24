package dal;

import model.ReaderAccount;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReaderAccountDBContext extends DBContext<ReaderAccount> {

    // =========================
    // LIST ALL READER ACCOUNTS
    // =========================
    @Override
    public ArrayList<ReaderAccount> list() {
        ArrayList<ReaderAccount> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Reader_Account";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                accounts.add(mapReaderAccount(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return accounts;
    }

    // =========================
    // GET BY ACCOUNT ID
    // =========================
    @Override
    public ReaderAccount get(int id) {
        String sql = "SELECT * FROM Reader_Account WHERE account_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapReaderAccount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // =========================
    // INSERT
    // =========================
    @Override
    public void insert(ReaderAccount acc) {
        String sql = """
            INSERT INTO Reader_Account
            (reader_id, provider, provider_user_id)
            VALUES (?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, acc.getReaderId());
            ps.setString(2, acc.getProvider());
            ps.setString(3, acc.getProviderUserId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // UPDATE
    // =========================
    @Override
    public void update(ReaderAccount acc) {
        String sql = """
            UPDATE Reader_Account
            SET reader_id = ?,
                provider = ?,
                provider_user_id = ?
            WHERE account_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, acc.getReaderId());
            ps.setString(2, acc.getProvider());
            ps.setString(3, acc.getProviderUserId());
            ps.setInt(4, acc.getAccountId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // DELETE
    // =========================
    @Override
    public void delete(ReaderAccount acc) {
        String sql = "DELETE FROM Reader_Account WHERE account_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, acc.getAccountId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // GET BY READER + PROVIDER
    // (Rất quan trọng cho login social)
    // =========================
    public ReaderAccount getByReaderAndProvider(int readerId, String provider) {
        String sql = """
            SELECT * FROM Reader_Account
            WHERE reader_id = ? AND provider = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setString(2, provider);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapReaderAccount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ReaderAccount getByProviderAndProviderUserId(String provider, String providerUserId) {
        String sql = """
        SELECT * FROM Reader_Account
        WHERE provider = ? AND provider_user_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, provider);
            ps.setString(2, providerUserId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapReaderAccount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReaderAccountDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // =========================
    // MAP RESULTSET → READER ACCOUNT
    // =========================
    private ReaderAccount mapReaderAccount(ResultSet rs) throws SQLException {
        ReaderAccount acc = new ReaderAccount();
        acc.setAccountId(rs.getInt("account_id"));
        acc.setReaderId(rs.getInt("reader_id"));
        acc.setProvider(rs.getString("provider"));
        acc.setProviderUserId(rs.getString("provider_user_id"));
        acc.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return acc;
    }
}

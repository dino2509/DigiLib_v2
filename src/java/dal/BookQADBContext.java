package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import model.BookAnswer;
import model.BookQuestion;

/**
 * Q&A theo sách.
 *
 * Yêu cầu DB: 2 bảng
 * - Book_QA_Question(question_id, book_id, reader_id, question_text, status, created_at)
 * - Book_QA_Answer(answer_id, question_id, employee_id, answer_text, created_at)
 */
public class BookQADBContext extends DBContext<BookQuestion> {

    @Override
    public ArrayList<BookQuestion> list() {
        throw new UnsupportedOperationException("Use listByBook(bookId) or listUnanswered()");
    }

    @Override
    public BookQuestion get(int id) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void insert(BookQuestion model) {
        throw new UnsupportedOperationException("Use insertQuestion(...) ");
    }

    @Override
    public void update(BookQuestion model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void delete(BookQuestion model) {
        throw new UnsupportedOperationException("Not supported");
    }

    public void insertQuestion(int bookId, int readerId, String questionText) {
        String sql = "INSERT INTO Book_QA_Question (book_id, reader_id, question_text, status, created_at) "
                + "VALUES (?, ?, ?, N'OPEN', SYSDATETIME())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.setInt(2, readerId);
            ps.setString(3, questionText);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insertAnswer(int questionId, int employeeId, String answerText) {
        String sql = "INSERT INTO Book_QA_Answer (question_id, employee_id, answer_text, created_at) "
                + "VALUES (?, ?, ?, SYSDATETIME())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.setInt(2, employeeId);
            ps.setString(3, answerText);
            ps.executeUpdate();

            // đánh dấu đã trả lời
            String upd = "UPDATE Book_QA_Question SET status = N'ANSWERED' WHERE question_id = ?";
            try (PreparedStatement ps2 = connection.prepareStatement(upd)) {
                ps2.setInt(1, questionId);
                ps2.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<BookQuestion> listByBook(int bookId) {
        String sql = "SELECT "
                + " q.question_id, q.book_id, q.reader_id, r.full_name AS reader_name, q.question_text, q.status, q.created_at AS q_created_at, "
                + " a.answer_id, a.employee_id, e.full_name AS employee_name, a.answer_text, a.created_at AS a_created_at "
                + "FROM Book_QA_Question q "
                + "INNER JOIN Reader r ON r.reader_id = q.reader_id "
                + "LEFT JOIN Book_QA_Answer a ON a.question_id = q.question_id "
                + "LEFT JOIN Employee e ON e.employee_id = a.employee_id "
                + "WHERE q.book_id = ? "
                + "ORDER BY q.created_at DESC, a.created_at ASC";

        Map<Integer, BookQuestion> map = new LinkedHashMap<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int qid = rs.getInt("question_id");
                BookQuestion q = map.get(qid);
                if (q == null) {
                    q = new BookQuestion();
                    q.setQuestionId(qid);
                    q.setBookId(rs.getInt("book_id"));
                    q.setReaderId(rs.getInt("reader_id"));
                    q.setReaderName(rs.getString("reader_name"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setStatus(rs.getString("status"));
                    q.setCreatedAt(rs.getTimestamp("q_created_at"));
                    map.put(qid, q);
                }

                int aid = rs.getInt("answer_id");
                if (!rs.wasNull()) {
                    BookAnswer a = new BookAnswer();
                    a.setAnswerId(aid);
                    a.setQuestionId(qid);
                    a.setEmployeeId(rs.getInt("employee_id"));
                    a.setEmployeeName(rs.getString("employee_name"));
                    a.setAnswerText(rs.getString("answer_text"));
                    a.setCreatedAt(rs.getTimestamp("a_created_at"));
                    q.getAnswers().add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    public ArrayList<BookQuestion> listUnanswered() {
        ArrayList<BookQuestion> list = new ArrayList<>();
        String sql = "SELECT TOP 200 "
                + " q.question_id, q.book_id, b.title AS book_title, q.reader_id, r.full_name AS reader_name, q.question_text, q.status, q.created_at "
                + "FROM Book_QA_Question q "
                + "INNER JOIN Reader r ON r.reader_id = q.reader_id "
                + "INNER JOIN Book b ON b.book_id = q.book_id "
                + "WHERE q.status = N'OPEN' "
                + "ORDER BY q.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookQuestion q = new BookQuestion();
                q.setQuestionId(rs.getInt("question_id"));
                q.setBookId(rs.getInt("book_id"));
                q.setReaderId(rs.getInt("reader_id"));
                // gộp để hiển thị nhanh ở Librarian list
                q.setReaderName(rs.getString("reader_name") + " • " + rs.getString("book_title"));
                q.setQuestionText(rs.getString("question_text"));
                q.setStatus(rs.getString("status"));
                q.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

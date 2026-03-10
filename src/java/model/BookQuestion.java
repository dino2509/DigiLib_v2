package model;

import java.sql.Timestamp;
import java.util.ArrayList;

public class BookQuestion {
    private int questionId;
    private int bookId;
    private int readerId;
    private String readerName;
    private String questionText;
    private String status;
    private Timestamp createdAt;
    private ArrayList<BookAnswer> answers = new ArrayList<>();

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }

    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public ArrayList<BookAnswer> getAnswers() { return answers; }
    public void setAnswers(ArrayList<BookAnswer> answers) { this.answers = answers; }
}

package model;

import java.sql.Timestamp;

/**
 * DTO cho Reader Home: Continue Reading.
 */
public class ReadingHistoryEntry {
    private int historyId;
    private int readerId;
    private Book book;

    private Integer lastReadPosition; // có thể null
    private Timestamp lastReadAt;      // có thể null

    public ReadingHistoryEntry() {
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public Integer getLastReadPosition() {
        return lastReadPosition;
    }

    public void setLastReadPosition(Integer lastReadPosition) {
        this.lastReadPosition = lastReadPosition;
    }

    public Timestamp getLastReadAt() {
        return lastReadAt;
    }

    public void setLastReadAt(Timestamp lastReadAt) {
        this.lastReadAt = lastReadAt;
    }
}

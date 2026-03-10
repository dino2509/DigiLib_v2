package model;

import java.sql.Timestamp;

public class BorrowedBook {

    private int borrowItemId;
    private int bookId;
    private String title;
    private String copyCode;
    private Timestamp dueDate;
    private Timestamp returnedAt;
    private String status;

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCopyCode() {
        return copyCode;
    }

    public void setCopyCode(String copyCode) {
        this.copyCode = copyCode;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getReturnedAt() {
        return returnedAt;
    }

    public void setReturnedAt(Timestamp returnedAt) {
        this.returnedAt = returnedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

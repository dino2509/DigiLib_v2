package model;

import java.sql.Timestamp;

/**
 * Item của ReturnRequest (1 borrow_item_id).
 */
public class ReturnRequestItem {
    private int returnRequestItemId;
    private int returnRequestId;
    private int borrowItemId;

    private int borrowId;
    private int copyId;
    private String copyCode;
    private Book book;
    private Timestamp borrowDate;
    private Timestamp dueDate;
    private Timestamp returnedAt;

    public int getReturnRequestItemId() { return returnRequestItemId; }
    public void setReturnRequestItemId(int returnRequestItemId) { this.returnRequestItemId = returnRequestItemId; }

    public int getReturnRequestId() { return returnRequestId; }
    public void setReturnRequestId(int returnRequestId) { this.returnRequestId = returnRequestId; }

    public int getBorrowItemId() { return borrowItemId; }
    public void setBorrowItemId(int borrowItemId) { this.borrowItemId = borrowItemId; }

    public int getBorrowId() { return borrowId; }
    public void setBorrowId(int borrowId) { this.borrowId = borrowId; }

    public int getCopyId() { return copyId; }
    public void setCopyId(int copyId) { this.copyId = copyId; }

    public String getCopyCode() { return copyCode; }
    public void setCopyCode(String copyCode) { this.copyCode = copyCode; }

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }

    public Timestamp getBorrowDate() { return borrowDate; }
    public void setBorrowDate(Timestamp borrowDate) { this.borrowDate = borrowDate; }

    public Timestamp getDueDate() { return dueDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }

    public Timestamp getReturnedAt() { return returnedAt; }
    public void setReturnedAt(Timestamp returnedAt) { this.returnedAt = returnedAt; }
}
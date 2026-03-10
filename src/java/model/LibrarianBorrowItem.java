package model;

import java.sql.Timestamp;

public class LibrarianBorrowItem {

    private int borrowItemId;
    private int borrowId;

    private int readerId;
    private String readerName;

    private int copyId;
    private String copyCode;

    private Book book;

    private Timestamp borrowDate;
    private Timestamp dueDate;
    private Timestamp returnedAt;

    private String status; // BORROWING / RETURNED / OVERDUE / EXTENDED

    // ====== Return request + fine (for librarian UI) ======
    private Integer pendingReturnRequestId; // null if none
    private int overdueDays; // 0 if not overdue
    private java.math.BigDecimal overdueFineAmount; // null if none

    public int getBorrowItemId() { return borrowItemId; }
    public void setBorrowItemId(int borrowItemId) { this.borrowItemId = borrowItemId; }

    public int getBorrowId() { return borrowId; }
    public void setBorrowId(int borrowId) { this.borrowId = borrowId; }

    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }

    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }

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

    public Integer getPendingReturnRequestId() { return pendingReturnRequestId; }
    public void setPendingReturnRequestId(Integer pendingReturnRequestId) { this.pendingReturnRequestId = pendingReturnRequestId; }

    public int getOverdueDays() { return overdueDays; }
    public void setOverdueDays(int overdueDays) { this.overdueDays = overdueDays; }

    public java.math.BigDecimal getOverdueFineAmount() { return overdueFineAmount; }
    public void setOverdueFineAmount(java.math.BigDecimal overdueFineAmount) { this.overdueFineAmount = overdueFineAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
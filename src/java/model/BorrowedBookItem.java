package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class BorrowedBookItem {
    private int borrowId;
    private int borrowItemId;

    private int copyId;
    private String copyCode;

    private Book book;

    private Timestamp borrowDate;
    private Timestamp dueDate;
    private Timestamp returnedAt;

    private String borrowStatus;
    private String borrowItemStatus;

    private Integer pendingExtendRequestId;
    private Integer pendingExtendMaxDays;
    private Integer pendingExtendRequestedDays;
    private boolean hasUnpaidFine;
    private BigDecimal unpaidFineAmount;
    private String unpaidFineSummary;

    public BorrowedBookItem() {
    }

    public int getBorrowId() { return borrowId; }
    public void setBorrowId(int borrowId) { this.borrowId = borrowId; }

    public int getBorrowItemId() { return borrowItemId; }
    public void setBorrowItemId(int borrowItemId) { this.borrowItemId = borrowItemId; }

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

    public String getBorrowStatus() { return borrowStatus; }
    public void setBorrowStatus(String borrowStatus) { this.borrowStatus = borrowStatus; }

    public String getBorrowItemStatus() { return borrowItemStatus; }
    public void setBorrowItemStatus(String borrowItemStatus) { this.borrowItemStatus = borrowItemStatus; }

    public Integer getPendingExtendRequestId() { return pendingExtendRequestId; }
    public void setPendingExtendRequestId(Integer pendingExtendRequestId) { this.pendingExtendRequestId = pendingExtendRequestId; }

    public Integer getPendingExtendMaxDays() { return pendingExtendMaxDays; }
    public void setPendingExtendMaxDays(Integer pendingExtendMaxDays) { this.pendingExtendMaxDays = pendingExtendMaxDays; }

    public Integer getPendingExtendRequestedDays() { return pendingExtendRequestedDays; }
    public void setPendingExtendRequestedDays(Integer pendingExtendRequestedDays) { this.pendingExtendRequestedDays = pendingExtendRequestedDays; }

    public boolean isHasUnpaidFine() { return hasUnpaidFine; }
    public void setHasUnpaidFine(boolean hasUnpaidFine) { this.hasUnpaidFine = hasUnpaidFine; }

    public BigDecimal getUnpaidFineAmount() { return unpaidFineAmount; }
    public void setUnpaidFineAmount(BigDecimal unpaidFineAmount) { this.unpaidFineAmount = unpaidFineAmount; }

    public String getUnpaidFineSummary() { return unpaidFineSummary; }
    public void setUnpaidFineSummary(String unpaidFineSummary) { this.unpaidFineSummary = unpaidFineSummary; }
}
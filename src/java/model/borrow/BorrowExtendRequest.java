package model.borrow;

import java.sql.Timestamp;
import model.Book;

public class BorrowExtendRequest {

    private int extendId;
    private int borrowItemId;
    private int borrowId;
    private int readerId;
    private String readerName;
    private int copyId;
    private String copyCode;
    private Book book;
    private Timestamp borrowDate;
    private Timestamp oldDueDate;
    private Timestamp requestedDueDate;
    private Timestamp approvedDueDate;
    private String status;
    private Timestamp requestedAt;
    private Timestamp processedAt;
    private String decisionNote;
    private Integer approvedByEmployeeId;
    private Integer maxAllowedDays;
    private Integer requestedDays;
    private boolean hasUnpaidFine;
    private java.math.BigDecimal unpaidFineAmount;
    private String unpaidFineSummary;

    public int getExtendId() { return extendId; }
    public void setExtendId(int extendId) { this.extendId = extendId; }

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

    public Timestamp getOldDueDate() { return oldDueDate; }
    public void setOldDueDate(Timestamp oldDueDate) { this.oldDueDate = oldDueDate; }

    public Timestamp getRequestedDueDate() { return requestedDueDate; }
    public void setRequestedDueDate(Timestamp requestedDueDate) { this.requestedDueDate = requestedDueDate; }

    public Timestamp getApprovedDueDate() { return approvedDueDate; }
    public void setApprovedDueDate(Timestamp approvedDueDate) { this.approvedDueDate = approvedDueDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getRequestedAt() { return requestedAt; }
    public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }

    public Timestamp getProcessedAt() { return processedAt; }
    public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }

    public String getDecisionNote() { return decisionNote; }
    public void setDecisionNote(String decisionNote) { this.decisionNote = decisionNote; }

    public Integer getApprovedByEmployeeId() { return approvedByEmployeeId; }
    public void setApprovedByEmployeeId(Integer approvedByEmployeeId) { this.approvedByEmployeeId = approvedByEmployeeId; }

    public Integer getMaxAllowedDays() { return maxAllowedDays; }
    public void setMaxAllowedDays(Integer maxAllowedDays) { this.maxAllowedDays = maxAllowedDays; }

    public Integer getRequestedDays() { return requestedDays; }
    public void setRequestedDays(Integer requestedDays) { this.requestedDays = requestedDays; }

    public boolean isHasUnpaidFine() { return hasUnpaidFine; }
    public void setHasUnpaidFine(boolean hasUnpaidFine) { this.hasUnpaidFine = hasUnpaidFine; }

    public java.math.BigDecimal getUnpaidFineAmount() { return unpaidFineAmount; }
    public void setUnpaidFineAmount(java.math.BigDecimal unpaidFineAmount) { this.unpaidFineAmount = unpaidFineAmount; }

    public String getUnpaidFineSummary() { return unpaidFineSummary; }
    public void setUnpaidFineSummary(String unpaidFineSummary) { this.unpaidFineSummary = unpaidFineSummary; }
}
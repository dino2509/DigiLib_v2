package model.borrow;

import java.sql.Timestamp;

public class BorrowExtend {

    private int extendId;
    private int borrowItemId;

    private Timestamp oldDueDate;
    private Timestamp requestedDueDate;
    private Timestamp approvedDueDate;

    private String status;
    private Timestamp requestedAt;

    private String bookTitle;
    private String copyCode;

    public int getExtendId() {
        return extendId;
    }

    public void setExtendId(int extendId) {
        this.extendId = extendId;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public Timestamp getOldDueDate() {
        return oldDueDate;
    }

    public void setOldDueDate(Timestamp oldDueDate) {
        this.oldDueDate = oldDueDate;
    }

    public Timestamp getRequestedDueDate() {
        return requestedDueDate;
    }

    public void setRequestedDueDate(Timestamp requestedDueDate) {
        this.requestedDueDate = requestedDueDate;
    }

    public Timestamp getApprovedDueDate() {
        return approvedDueDate;
    }

    public void setApprovedDueDate(Timestamp approvedDueDate) {
        this.approvedDueDate = approvedDueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getCopyCode() {
        return copyCode;
    }

    public void setCopyCode(String copyCode) {
        this.copyCode = copyCode;
    }
    private String readerEmail;
    private int isbn;
    private String decisionNote;

    public String getReaderEmail() {
        return readerEmail;
    }

    public void setReaderEmail(String readerEmail) {
        this.readerEmail = readerEmail;
    }

    public int getIsbn() {
        return isbn;
    }

    public void setIsbn(int isbn) {
        this.isbn = isbn;
    }

   

    public String getDecisionNote() {
        return decisionNote;
    }

    public void setDecisionNote(String decisionNote) {
        this.decisionNote = decisionNote;
    }
}

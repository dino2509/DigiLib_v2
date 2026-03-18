package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Fine {

    // ========================
    // BASIC INFO
    // ========================
    private int fineId;

    private int readerId;
    private int borrowItemId;
    private int fineTypeId;

    private BigDecimal amount;
    private String reason;
    private String status; // UNPAID / PAID / CANCELLED

    private Timestamp createdAt;
    private Timestamp paidAt;

    private Integer handledByEmployeeId;
    private String readerEmail;

    public String getReaderEmail() {
        return readerEmail;
    }

    public void setReaderEmail(String readerEmail) {
        this.readerEmail = readerEmail;
    }

    // ========================
    // JOIN DATA (VIEW)
    // ========================
    private String readerName;
    private String fineTypeName;
    private String employeeName;

    private String bookTitle;
    private String copyCode;

    private Timestamp dueDate;
    private Timestamp returnedAt;

    // ========================
    // COMPUTED FIELD
    // ========================
    private Integer overdueDays;

    // ========================
    // GETTERS & SETTERS
    // ========================
    public int getFineId() {
        return fineId;
    }

    public void setFineId(int fineId) {
        this.fineId = fineId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public int getFineTypeId() {
        return fineTypeId;
    }

    public void setFineTypeId(int fineTypeId) {
        this.fineTypeId = fineTypeId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public Integer getHandledByEmployeeId() {
        return handledByEmployeeId;
    }

    public void setHandledByEmployeeId(Integer handledByEmployeeId) {
        this.handledByEmployeeId = handledByEmployeeId;
    }

    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
    }

    public String getFineTypeName() {
        return fineTypeName;
    }

    public void setFineTypeName(String fineTypeName) {
        this.fineTypeName = fineTypeName;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
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

    public Integer getOverdueDays() {
        return overdueDays;
    }

    public void setOverdueDays(Integer overdueDays) {
        this.overdueDays = overdueDays;
    }

    // ========================
    // HELPER METHOD (AUTO CALC)
    // ========================
    public int calculateOverdueDays() {
        if (dueDate == null || returnedAt == null) {
            return 0;
        }

        long diff = returnedAt.getTime() - dueDate.getTime();
        long days = diff / (1000 * 60 * 60 * 24);

        return (int) Math.max(days, 0);
    }
}

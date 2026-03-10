package model;

import java.sql.Timestamp;

public class BorrowRequest {

    private int requestId;
    private int readerId;
    private String status;
    private String note;
    private Timestamp requestedAt;
    private Integer processedByEmployeeId;
    private Timestamp processedAt;
    private String decisionNote;

    private Reader reader;

    public BorrowRequest() {
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public Integer getProcessedByEmployeeId() {
        return processedByEmployeeId;
    }

    public void setProcessedByEmployeeId(Integer processedByEmployeeId) {
        this.processedByEmployeeId = processedByEmployeeId;
    }

    public Timestamp getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }

    public String getDecisionNote() {
        return decisionNote;
    }

    public void setDecisionNote(String decisionNote) {
        this.decisionNote = decisionNote;
    }

    public Reader getReader() {
        return reader;
    }

    public void setReader(Reader reader) {
        this.reader = reader;
    }
}

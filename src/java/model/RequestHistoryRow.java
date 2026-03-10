package model;

import java.sql.Timestamp;

public class RequestHistoryRow {

    private String type;
    private int id;
    private int readerId;
    private String readerName;
    private String status;
    private Timestamp createdAt;
    private String titleSummary;

    private Integer position;
    private Integer convertedRequestId;

    private Integer borrowItemId;
    private Integer requestedDays;
    private Integer maxAllowedDays;
    private Timestamp oldDueDate;
    private Timestamp requestedDueDate;
    private Timestamp approvedDueDate;

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }

    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTitleSummary() { return titleSummary; }
    public void setTitleSummary(String titleSummary) { this.titleSummary = titleSummary; }

    public Integer getPosition() { return position; }
    public void setPosition(Integer position) { this.position = position; }

    public Integer getConvertedRequestId() { return convertedRequestId; }
    public void setConvertedRequestId(Integer convertedRequestId) { this.convertedRequestId = convertedRequestId; }

    public Integer getBorrowItemId() { return borrowItemId; }
    public void setBorrowItemId(Integer borrowItemId) { this.borrowItemId = borrowItemId; }

    public Integer getRequestedDays() { return requestedDays; }
    public void setRequestedDays(Integer requestedDays) { this.requestedDays = requestedDays; }

    public Integer getMaxAllowedDays() { return maxAllowedDays; }
    public void setMaxAllowedDays(Integer maxAllowedDays) { this.maxAllowedDays = maxAllowedDays; }

    public Timestamp getOldDueDate() { return oldDueDate; }
    public void setOldDueDate(Timestamp oldDueDate) { this.oldDueDate = oldDueDate; }

    public Timestamp getRequestedDueDate() { return requestedDueDate; }
    public void setRequestedDueDate(Timestamp requestedDueDate) { this.requestedDueDate = requestedDueDate; }

    public Timestamp getApprovedDueDate() { return approvedDueDate; }
    public void setApprovedDueDate(Timestamp approvedDueDate) { this.approvedDueDate = approvedDueDate; }
}
package model;

import java.sql.Timestamp;
import java.util.ArrayList;

/**
 * Return request (yêu cầu trả sách).
 * - createdByType: READER hoặc LIBRARIAN (librarian tạo trực tiếp)
 * - status: PENDING / CONFIRMED
 */
public class ReturnRequest {
    private int returnRequestId;

    private Integer readerId;
    private String readerName;

    private Integer createdByEmployeeId;
    private String createdByEmployeeName;

    private String createdByType; // READER / LIBRARIAN
    private String status;        // PENDING / CONFIRMED

    private Timestamp createdAt;
    private Integer confirmedByEmployeeId;
    private String confirmedByEmployeeName;
    private Timestamp confirmedAt;

    private String note;

    private ArrayList<ReturnRequestItem> items = new ArrayList<>();

    public int getReturnRequestId() { return returnRequestId; }
    public void setReturnRequestId(int returnRequestId) { this.returnRequestId = returnRequestId; }

    public Integer getReaderId() { return readerId; }
    public void setReaderId(Integer readerId) { this.readerId = readerId; }

    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }

    public Integer getCreatedByEmployeeId() { return createdByEmployeeId; }
    public void setCreatedByEmployeeId(Integer createdByEmployeeId) { this.createdByEmployeeId = createdByEmployeeId; }

    public String getCreatedByEmployeeName() { return createdByEmployeeName; }
    public void setCreatedByEmployeeName(String createdByEmployeeName) { this.createdByEmployeeName = createdByEmployeeName; }

    public String getCreatedByType() { return createdByType; }
    public void setCreatedByType(String createdByType) { this.createdByType = createdByType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Integer getConfirmedByEmployeeId() { return confirmedByEmployeeId; }
    public void setConfirmedByEmployeeId(Integer confirmedByEmployeeId) { this.confirmedByEmployeeId = confirmedByEmployeeId; }

    public String getConfirmedByEmployeeName() { return confirmedByEmployeeName; }
    public void setConfirmedByEmployeeName(String confirmedByEmployeeName) { this.confirmedByEmployeeName = confirmedByEmployeeName; }

    public Timestamp getConfirmedAt() { return confirmedAt; }
    public void setConfirmedAt(Timestamp confirmedAt) { this.confirmedAt = confirmedAt; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public ArrayList<ReturnRequestItem> getItems() { return items; }
    public void setItems(ArrayList<ReturnRequestItem> items) { this.items = items; }
}
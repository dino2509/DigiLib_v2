package model;

import java.sql.Timestamp;

/**
 * Unified row for "Borrow requests + Reservations" history pages.
 *
 * type:
 *  - BORROW: Borrow_Request
 *  - RESERVATION: Reservation_Request
 */
public class RequestHistoryRow {

    private String type; // BORROW / RESERVATION
    private int id;      // request_id or reservation_id

    private int readerId;
    private String readerName;

    private String status;        // PENDING/APPROVED/REJECTED or WAITING/CONVERTED/CANCELLED
    private Timestamp createdAt;  // requested_at or created_at

    // display summary (borrow: "Book A, Book B" | reservation: book title)
    private String titleSummary;

    // reservation extra
    private Integer position;             // queue position (WAITING only)
    private Integer convertedRequestId;   // reservation.converted_request_id

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
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

    public String getTitleSummary() {
        return titleSummary;
    }

    public void setTitleSummary(String titleSummary) {
        this.titleSummary = titleSummary;
    }

    public Integer getPosition() {
        return position;
    }

    public void setPosition(Integer position) {
        this.position = position;
    }

    public Integer getConvertedRequestId() {
        return convertedRequestId;
    }

    public void setConvertedRequestId(Integer convertedRequestId) {
        this.convertedRequestId = convertedRequestId;
    }
}
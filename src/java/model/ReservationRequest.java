package model;

import java.sql.Timestamp;

/**
 * Reservation request (đặt trước sách khi kho hết copy).
 *
 * status:
 * - WAITING: đang trong hàng đợi
 * - CONVERTED: đã được tự động chuyển thành Borrow_Request (PENDING)
 * - CANCELLED: đã huỷ
 */
public class ReservationRequest {

    private int reservationId;
    private int readerId;
    private String readerName;

    private int bookId;
    private String bookTitle;

    private String status; // WAITING / CONVERTED / CANCELLED
    private Timestamp createdAt;

    private Integer convertedRequestId; // Borrow_Request.request_id
    private Timestamp convertedAt;

    // computed field (not stored)
    private Integer position;

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
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

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
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

    public Integer getConvertedRequestId() {
        return convertedRequestId;
    }

    public void setConvertedRequestId(Integer convertedRequestId) {
        this.convertedRequestId = convertedRequestId;
    }

    public Timestamp getConvertedAt() {
        return convertedAt;
    }

    public void setConvertedAt(Timestamp convertedAt) {
        this.convertedAt = convertedAt;
    }

    public Integer getPosition() {
        return position;
    }

    public void setPosition(Integer position) {
        this.position = position;
    }
}
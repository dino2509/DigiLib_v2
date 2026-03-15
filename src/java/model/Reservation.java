package model;

import java.sql.Timestamp;

public class Reservation {

    private int reservationId;
    private int readerId;

    // Book info (from Reservation_Item)
    private int bookId;
    private String bookTitle;
    private int quantity;

    // Reader
    private String readerName;

    // Reservation status
    private String status;

    // Time
    private Timestamp createdAt;
    private Timestamp expiresAt;
    private Timestamp fulfilledAt;

    // Optional note
    private String note;

    // UI helper (copies available in library)
    private int availableCopies;

    public Reservation() {
    }

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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Timestamp getFulfilledAt() {
        return fulfilledAt;
    }

    public void setFulfilledAt(Timestamp fulfilledAt) {
        this.fulfilledAt = fulfilledAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }
}

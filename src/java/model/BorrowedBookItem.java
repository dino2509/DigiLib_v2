package model;

import java.sql.Timestamp;

/**
 * DTO cho màn hình Reader: Sách đang mượn.
 * Không ánh xạ trực tiếp 1 bảng, chỉ gom dữ liệu từ Borrow/Borrow_Item/BookCopy/Book.
 */
public class BorrowedBookItem {
    private int borrowId;
    private int borrowItemId;

    private int copyId;
    private String copyCode;

    private Book book;

    private Timestamp borrowDate;
    private Timestamp dueDate;
    private Timestamp returnedAt;

    private String borrowStatus;     // Borrow.status
    private String borrowItemStatus; // Borrow_Item.status

    public BorrowedBookItem() {
    }

    public int getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(int borrowId) {
        this.borrowId = borrowId;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public int getCopyId() {
        return copyId;
    }

    public void setCopyId(int copyId) {
        this.copyId = copyId;
    }

    public String getCopyCode() {
        return copyCode;
    }

    public void setCopyCode(String copyCode) {
        this.copyCode = copyCode;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public Timestamp getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Timestamp borrowDate) {
        this.borrowDate = borrowDate;
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

    public String getBorrowStatus() {
        return borrowStatus;
    }

    public void setBorrowStatus(String borrowStatus) {
        this.borrowStatus = borrowStatus;
    }

    public String getBorrowItemStatus() {
        return borrowItemStatus;
    }

    public void setBorrowItemStatus(String borrowItemStatus) {
        this.borrowItemStatus = borrowItemStatus;
    }
}

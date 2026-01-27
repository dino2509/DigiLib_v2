/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author TuanBro
 */
import java.sql.Date;

public class BorrowedBookDTO {
    private int borrowItemId;
    private String readerName;
    private String bookTitle;
    private String copyCode;
    private Date borrowedDate;
    private Date dueDate;
    private String status;
    private double fineAmount; // Nếu muốn hiện tiền phạt

    public BorrowedBookDTO() {
    }

    public BorrowedBookDTO(int borrowItemId, String readerName, String bookTitle, String copyCode, Date borrowedDate, Date dueDate, String status) {
        this.borrowItemId = borrowItemId;
        this.readerName = readerName;
        this.bookTitle = bookTitle;
        this.copyCode = copyCode;
        this.borrowedDate = borrowedDate;
        this.dueDate = dueDate;
        this.status = status;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
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

    public Date getBorrowedDate() {
        return borrowedDate;
    }

    public void setBorrowedDate(Date borrowedDate) {
        this.borrowedDate = borrowedDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
}
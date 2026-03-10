package model;

public class BorrowRequestItem {
    private int requestItemId;
    private int requestId;
    private int bookId;
    private String bookTitle;
    private int quantity;

    public int getRequestItemId() { return requestItemId; }
    public void setRequestItemId(int requestItemId) { this.requestItemId = requestItemId; }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}

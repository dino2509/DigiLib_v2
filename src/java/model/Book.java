package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Book {

    private int bookId;
    private String title;
    private String summary;
    private String description;
    private String coverUrl;
    private String contentPath;
    private BigDecimal price;
    private String currency;
    private int totalPages;
    private int previewPages;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Author author;
    private Category category;
    
    private int authorId;
    private int categoryId;
    private int createdByEmployeeId;
    private int updatedByEmployeeId;


    // ===== GETTER & SETTER =====
    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCoverUrl() {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl) {
        this.coverUrl = coverUrl;
    }

    public String getContentPath() {
        return contentPath;
    }

    public void setContentPath(String contentPath) {
        this.contentPath = contentPath;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getPreviewPages() {
        return previewPages;
    }

    public void setPreviewPages(int previewPages) {
        this.previewPages = previewPages;
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

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
      public int getCreatedByEmployeeId() {
        return createdByEmployeeId;
    }

    public Author getAuthor() {
        return author;
    }

    public void setAuthor(Author author) {
        this.author = author;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
      
      

    public void setCreatedByEmployeeId(int createdByEmployeeId) {
        this.createdByEmployeeId = createdByEmployeeId;
    }

    public int getUpdatedByEmployeeId() {
        return updatedByEmployeeId;
    }

    public void setUpdatedByEmployeeId(int updatedByEmployeeId) {
        this.updatedByEmployeeId = updatedByEmployeeId;
    }
}

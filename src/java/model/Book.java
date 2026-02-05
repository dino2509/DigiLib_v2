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
    private Employee create_by;
    private Employee update_by;

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

    public Employee getCreate_by() {
        return create_by;
    }

    public void setCreate_by(Employee create_by) {
        this.create_by = create_by;
    }

    public Employee getUpdate_by() {
        return update_by;
    }

    public void setUpdate_by(Employee update_by) {
        this.update_by = update_by;
    }

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

}

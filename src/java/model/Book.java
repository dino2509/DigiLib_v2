package model;

import java.sql.Timestamp;

public class Book {

    private int id;
    private String title;

    /**
     * Backward-compatible field used by older JSPs.
     * In DB this maps to Book.cover_url.
     */
    private String cover;

    /**
     * Average rating (computed from Review).
     */
    private double rating;

    // ===== Extended fields (DB-aligned) =====
    private String summary;
    private String description;
    private Integer totalPages;

    private Integer authorId;
    private Integer categoryId;
    private String categoryName;

    private Double price;
    private String currency;
    private Integer reviewCount;
    private int bookId;

    private String coverUrl;
    private String contentPath;
    private int previewPages;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Author author;
    private Category category;
    private Employee create_by;
    private Employee update_by;

    public Book() {
    }

    public Book(int id, String title, Author author, String cover, double rating) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.cover = cover;
        this.rating = rating;
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

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
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

    public Integer getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(Integer totalPages) {
        this.totalPages = totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public Integer getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
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

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Integer getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
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

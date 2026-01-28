package model;

public class Book {

    private int id;
    private String title;
    private String author;      // author_name (join Author)

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

    public Book() {
    }

    public Book(int id, String title, String author, String cover, double rating) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.cover = cover;
        this.rating = rating;
    }

    // ===== Getters / Setters =====
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    /**
     * Alias for cover (DB: cover_url). Prefer using this in new code.
     */
    public String getCoverUrl() {
        return cover;
    }

    /**
     * Alias for cover (DB: cover_url). Prefer using this in new code.
     */
    public void setCoverUrl(String coverUrl) {
        this.cover = coverUrl;
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
}

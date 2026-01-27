package model;

public class Book {

    private int id;
    private String title;
    private String author;
    private String cover;     // tên file ảnh, ví dụ: "clean_code.jpg"
    private double rating;    // ví dụ: 4.5

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

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
}

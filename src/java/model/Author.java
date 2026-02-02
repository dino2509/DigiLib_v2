package model;

public class Author {
    private int author_id;
    private String author_name;
    private String bio;

    public Author() {
    }

    public Author(int author_id, String author_name, String bio) {
        this.author_id = author_id;
        this.author_name = author_name;
        this.bio = bio;
    }

    public int getAuthor_id() {
        return author_id;
    }

    public void setAuthor_id(int author_id) {
        this.author_id = author_id;
    }

    public String getAuthor_name() {
        return author_name;
    }

    public void setAuthor_name(String author_name) {
        this.author_name = author_name;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }
}

package model;

public class ReadingProgress {
    private Book book;
    private int progress;

    public ReadingProgress(Book book, int progress) {
        this.book = book;
        this.progress = progress;
    }

    public Book getBook() {
        return book;
    }

    public int getProgress() {
        return progress;
    }
}

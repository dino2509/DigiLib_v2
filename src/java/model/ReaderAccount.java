package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ReaderAccount implements Serializable {

    private int accountId;
    private int readerId;
    private String provider;
    private String providerUserId;
    private LocalDateTime createdAt;

    // Constructor rỗng (bắt buộc cho JDBC / JavaBean)
    public ReaderAccount() {
    }

    // Constructor đầy đủ
    public ReaderAccount(int accountId, int readerId, String provider,
                         String providerUserId, LocalDateTime createdAt) {
        this.accountId = accountId;
        this.readerId = readerId;
        this.provider = provider;
        this.providerUserId = providerUserId;
        this.createdAt = createdAt;
    }

    // Getter & Setter
    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getProviderUserId() {
        return providerUserId;
    }

    public void setProviderUserId(String providerUserId) {
        this.providerUserId = providerUserId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

package model;

import java.sql.Timestamp;

/**
 * Message/answer item under a BookQuestion.
 *
 * Historically this model represented only librarian answers (Book_QA_Answer).
 * Now it can also represent threaded replies from both Reader and Librarian
 * (Book_QA_Reply) so UI can show a conversation.
 */
public class BookAnswer {

    private int answerId;
    private int questionId;

    /** Nullable depending on senderType */
    private Integer employeeId;
    /** Nullable depending on senderType */
    private Integer readerId;

    /** READER | LIBRARIAN */
    private String senderType;
    /** full name for UI */
    private String senderName;

    // Backward compatible fields (some JSPs may still reference these names)
    private String employeeName;

    private String answerText;
    private Timestamp createdAt;

    public int getAnswerId() {
        return answerId;
    }

    public void setAnswerId(int answerId) {
        this.answerId = answerId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        this.employeeId = employeeId;
    }

    public Integer getReaderId() {
        return readerId;
    }

    public void setReaderId(Integer readerId) {
        this.readerId = readerId;
    }

    public String getSenderType() {
        return senderType;
    }

    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getEmployeeName() {
        // fallback for old code paths
        return employeeName != null ? employeeName : senderName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
        // keep senderName in sync when this instance represents librarian answer
        if (this.senderName == null) {
            this.senderName = employeeName;
        }
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

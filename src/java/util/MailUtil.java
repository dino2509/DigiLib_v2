package util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class MailUtil {

    // ⚠️ KHÔNG chia sẻ public khi nộp bài / up git
    private static final String FROM_EMAIL = "kitanobita1908@gmail.com";
    private static final String APP_PASSWORD = "puggtgqrtovnqcqx";

    public static void send(String to, String subject, String htmlContent) {

        Properties props = new Properties();

        // ===== SMTP BASIC =====
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // ===== TLS / SSL FIX (QUAN TRỌNG) =====
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(to)
            );
            message.setSubject(subject);

            // gửi HTML
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);

        } catch (MessagingException e) {
            // IN LỖI THẬT – RẤT QUAN TRỌNG
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}

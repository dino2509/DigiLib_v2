package service;

import util.MailUtil;
import util.MailUtil;

public class EmailService {

    public static void sendAsync(String to, String subject, String htmlContent) {
        new Thread(() -> {
            MailUtil.send(to, subject, htmlContent);
        }).start();
    }

}
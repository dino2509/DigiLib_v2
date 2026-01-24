package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Hash password khi đăng ký
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    // Check password khi login
    public static boolean checkPassword(String plainPassword, String hashed) {
        if (hashed == null) return false;
        return BCrypt.checkpw(plainPassword, hashed);
    }
}
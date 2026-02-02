package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

<<<<<<< HEAD
    public static boolean checkPassword(String rawPassword, String hashedPassword) {
        if (rawPassword == null || hashedPassword == null) return false;

        // jBCrypt (mindrot) phổ biến nhất: hỗ trợ $2a$
        // Nếu bạn dùng phiên bản có hỗ trợ $2b$ thì có thể thêm điều kiện.
        if (!hashedPassword.startsWith("$2a$")) {
            return false;
        }

        try {
            return BCrypt.checkpw(rawPassword, hashedPassword);
        } catch (IllegalArgumentException ex) {
            // Hash không đúng định dạng BCrypt => coi như sai mật khẩu, không ném 500
            return false;
        }
    }

    public static String hashPassword(String rawPassword) {
        if (rawPassword == null) throw new IllegalArgumentException("rawPassword is null");
        // gensalt mặc định tạo $2a$
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
    }
}
=======
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
>>>>>>> master

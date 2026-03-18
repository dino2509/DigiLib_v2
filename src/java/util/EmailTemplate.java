package util;

public class EmailTemplate {

    public static String getBaseTemplate(String title, String content) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: #f4f6f8;
                            margin: 0;
                            padding: 0;
                        }
                        .container {
                            width: 100%%;
                            padding: 20px;
                            background-color: #f4f6f8;
                        }
                        .card {
                            max-width: 600px;
                            margin: auto;
                            background: white;
                            border-radius: 10px;
                            padding: 30px;
                            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                        }
                        .header {
                            font-size: 22px;
                            font-weight: bold;
                            margin-bottom: 20px;
                            color: #333;
                        }
                        .content {
                            font-size: 16px;
                            color: #555;
                            line-height: 1.6;
                        }
                        .footer {
                            margin-top: 30px;
                            font-size: 13px;
                            color: #999;
                            text-align: center;
                        }
                        .success {
                            color: #2ecc71;
                            font-weight: bold;
                        }
                        .danger {
                            color: #e74c3c;
                            font-weight: bold;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="card">
                            <div class="header">%s</div>
                            <div class="content">
                                %s
                            </div>
                            <div class="footer">
                                DigiLib System<br/>
                                This is an automated email, please do not reply.
                            </div>
                        </div>
                    </div>
                </body>
                </html>
                """.formatted(title, content);
    }

    // ===== APPROVED TEMPLATE =====
    public static String borrowApproved(String title, int isbn, String dueDate) {

        String content = """
            <p>Your borrow request has been 
            <span class="success">APPROVED</span>.</p>

            <table style="margin-top:15px; border-collapse: collapse;">
                <tr>
                    <td><b>Book Title:</b></td>
                    <td style="padding-left:10px;">%s</td>
                </tr>
                <tr>
                    <td><b>ISBN:</b></td>
                    <td style="padding-left:10px;">%s</td>
                </tr>
                <tr>
                    <td><b>Due Date:</b></td>
                    <td style="padding-left:10px;">%s</td>
                </tr>
            </table>

            <p style="margin-top:15px;">
                Please visit the library to receive your book.
            </p>
            """.formatted(title, isbn, dueDate);

        return getBaseTemplate("Borrow Request Approved", content);
    }

    // ===== REJECTED TEMPLATE =====
    public static String borrowRejected(String title, int isbn, String note) {

        String safeNote = (note != null && !note.isBlank()) ? note : "N/A";

        String content = """
            <p>Your borrow request has been 
            <span class="danger">REJECTED</span>.</p>

            <table style="margin-top:15px;">
                <tr>
                    <td><b>Book Title:</b></td>
                    <td style="padding-left:10px;">%s</td>
                </tr>
                <tr>
                    <td><b>ISBN:</b></td>
                    <td style="padding-left:10px;">%s</td>
                </tr>
            </table>

            <p style="margin-top:15px;">
                <b>Reason:</b> %s
            </p>
            """.formatted(title, isbn, safeNote);

        return getBaseTemplate("Borrow Request Rejected", content);
    }

    // ===== RESERVATION FULFILLED =====
    public static String reservationFulfilled(String bookTitle, int quantity) {

        String content = """
        <p>Your reservation has been 
        <span class="success">FULFILLED</span>.</p>

        <table style="margin-top:15px;">
            <tr>
                <td><b>Book:</b></td>
                <td style="padding-left:10px;">%s</td>
            </tr>
            <tr>
                <td><b>Quantity:</b></td>
                <td style="padding-left:10px;">%s</td>
            </tr>
        </table>

        <p style="margin-top:15px;">
            Please proceed to borrow confirmation.
        </p>
    """.formatted(bookTitle, quantity);

        return getBaseTemplate("Reservation Fulfilled", content);
    }

// ===== RESERVATION CANCELLED =====
    public static String reservationCancelled(String bookTitle) {

        String content = """
        <p>Your reservation has been 
        <span class="danger">CANCELLED</span>.</p>

        <p><b>Book:</b> %s</p>

        <p style="margin-top:15px;">
            Please contact the library for more details.
        </p>
    """.formatted(bookTitle);

        return getBaseTemplate("Reservation Cancelled", content);
    }
}

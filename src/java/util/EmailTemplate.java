package util;

import java.sql.Timestamp;
import java.util.List;

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

    // ===== ORDER CANCELLED =====
    public static String orderCancelled(int orderId, String reason) {

        String safeReason = (reason != null && !reason.isBlank()) ? reason : "N/A";

        String content = """
        <p>Your order has been 
        <span class="danger">CANCELLED</span>.</p>

        <table style="margin-top:15px;">
            <tr>
                <td><b>Order ID:</b></td>
                <td style="padding-left:10px;">#%s</td>
            </tr>
        </table>

        <p style="margin-top:15px;">
            <b>Reason:</b> %s
        </p>

        <p style="margin-top:15px;">
            Please contact the library for more details.
        </p>
    """.formatted(orderId, safeReason);

        return getBaseTemplate("Order Cancelled", content);
    }

    public static String paymentSuccess(int orderId) {

        String content = """
        <p>Your payment has been 
        <span class="success">SUCCESSFUL</span>.</p>

        <p><b>Order ID:</b> #%s</p>

        <p style="margin-top:15px;">
            Thank you for your purchase.<br/>
            Please keep this email as your invoice.
        </p>
    """.formatted(orderId);

        return getBaseTemplate("Payment Successful", content);
    }

    public static String paymentInvoice(int orderId,
            String readerName,
            String paymentMethod,
            String createdAt,
            List<model.OrderBook> items,
            String total,
            String currency) {

        StringBuilder rows = new StringBuilder();

        for (model.OrderBook item : items) {
            rows.append("""
            <tr>
                <td>%s</td>
                <td style="text-align:center;">%s</td>
                <td style="text-align:right;">%s</td>
                <td style="text-align:right;">%s</td>
            </tr>
        """.formatted(
                    item.getBookTitle(),
                    item.getQuantity(),
                    item.getPrice(),
                    item.getPrice().multiply(new java.math.BigDecimal(item.getQuantity()))
            ));
        }

        String content = """
        <p>Your payment has been 
        <span class="success">SUCCESSFUL</span>.</p>

        <h3>📄 Invoice Information</h3>

        <table style="margin-top:10px;">
            <tr><td><b>Order ID:</b></td><td>#%s</td></tr>
            <tr><td><b>Reader:</b></td><td>%s</td></tr>
            <tr><td><b>Payment Method:</b></td><td>%s</td></tr>
            <tr><td><b>Payment Time:</b></td><td>%s</td></tr>
        </table>

        <h3 style="margin-top:20px;">📚 Books</h3>

        <table style="width:100%%; border-collapse: collapse;" border="1">
            <tr>
                <th>Book</th>
                <th>Qty</th>
                <th>Price</th>
                <th>Total</th>
            </tr>
            %s
        </table>

        <h3 style="margin-top:20px;">
            Total: %s %s
        </h3>

        <p style="margin-top:20px;">
            Please keep this email as your invoice.<br/>
            Thank you for using DigiLib!
        </p>
    """.formatted(orderId, readerName, paymentMethod, createdAt,
                rows.toString(), total, currency);

        return getBaseTemplate("Payment Invoice", content);
    }

    public static String waitingPayment(
            int orderId,
            String readerName,
            String createdAt,
            List<model.OrderBook> items,
            String total,
            String currency
    ) {

        StringBuilder rows = new StringBuilder();

        for (model.OrderBook item : items) {
            rows.append("""
        <tr>
            <td>%s</td>
            <td style="text-align:center;">%s</td>
            <td style="text-align:right;">%s</td>
            <td style="text-align:right;">%s</td>
        </tr>
        """.formatted(
                    item.getBookTitle(),
                    item.getQuantity(),
                    item.getPrice(),
                    item.getPrice().multiply(new java.math.BigDecimal(item.getQuantity()))
            ));
        }

        String content = """
    <p>Your order has been created successfully.</p>

    <p>Status: <span class="danger">WAITING FOR PAYMENT</span></p>

    <h3>📄 Order Information</h3>

    <table style="margin-top:10px;">
        <tr><td><b>Order ID:</b></td><td>#%s</td></tr>
        <tr><td><b>Reader:</b></td><td>%s</td></tr>
        <tr><td><b>Payment Method:</b></td><td>CASH</td></tr>
        <tr><td><b>Created At:</b></td><td>%s</td></tr>
    </table>

    <h3 style="margin-top:20px;">📚 Books</h3>

    <table style="width:100%%; border-collapse: collapse;" border="1">
        <tr>
            <th>Book</th>
            <th>Qty</th>
            <th>Price</th>
            <th>Total</th>
        </tr>
        %s
    </table>

    <h3 style="margin-top:20px;">
        Total: %s %s
    </h3>

    <p style="margin-top:20px;">
        Please come to the library to complete your payment.<br/>
        After payment, your order will be confirmed.
    </p>
    """.formatted(orderId, readerName, createdAt, rows.toString(), total, currency);

        return getBaseTemplate("Order Created - Waiting for Payment", content);
    }

    public static String orderCancelled(
            int orderId,
            String readerName,
            String createdAt,
            String paymentMethod,
            List<model.OrderBook> items,
            String total,
            String currency,
            String reason
    ) {

        String safeReason = (reason != null && !reason.isBlank()) ? reason : "N/A";

        StringBuilder rows = new StringBuilder();

        for (model.OrderBook item : items) {
            rows.append("""
        <tr>
            <td>%s</td>
            <td style="text-align:center;">%s</td>
            <td style="text-align:right;">%s</td>
            <td style="text-align:right;">%s</td>
        </tr>
        """.formatted(
                    item.getBookTitle(),
                    item.getQuantity(),
                    item.getPrice(),
                    item.getPrice().multiply(new java.math.BigDecimal(item.getQuantity()))
            ));
        }

        String content = """
    <p>Your order has been 
    <span class="danger">CANCELLED</span>.</p>

    <h3>📄 Order Information</h3>

    <table style="margin-top:10px;">
        <tr><td><b>Order ID:</b></td><td>#%s</td></tr>
        <tr><td><b>Reader:</b></td><td>%s</td></tr>
        <tr><td><b>Payment Method:</b></td><td>%s</td></tr>
        <tr><td><b>Created At:</b></td><td>%s</td></tr>
    </table>

    <h3 style="margin-top:20px;">📚 Books</h3>

    <table style="width:100%%; border-collapse: collapse;" border="1">
        <tr>
            <th>Book</th>
            <th>Qty</th>
            <th>Price</th>
            <th>Total</th>
        </tr>
        %s
    </table>

    <h3 style="margin-top:20px;">
        Total: %s %s
    </h3>

    <p style="margin-top:20px;">
        <b>Reason:</b> %s
    </p>

    <p style="margin-top:15px;">
        If you have any questions, please contact the library.
    </p>
    """.formatted(orderId, readerName, paymentMethod, createdAt,
                rows.toString(), total, currency, safeReason);

        return getBaseTemplate("Order Cancelled", content);
    }

    // ===== EXTEND APPROVED =====
    public static String extendApproved(String bookTitle, int isbn, Timestamp newDueDate) {

        String content = """
        <p>Your extend request has been 
        <span class="success">APPROVED</span>.</p>

        <table style="margin-top:15px;">
            <tr>
                <td><b>Book:</b></td>
                <td style="padding-left:10px;">%s</td>
            </tr>
            <tr>
                <td><b>ISBN:</b></td>
                <td style="padding-left:10px;">%s</td>
            </tr>
            <tr>
                <td><b>New Due Date:</b></td>
                <td style="padding-left:10px;">%s</td>
            </tr>
        </table>
    """.formatted(bookTitle, isbn, newDueDate);

        return getBaseTemplate("Extend Request Approved", content);
    }

    // ===== EXTEND REJECTED =====
    public static String extendRejected(String bookTitle, int isbn, String reason) {

        String safeReason = (reason != null && !reason.isBlank()) ? reason : "N/A";

        String content = """
        <p>Your extend request has been 
        <span class="danger">REJECTED</span>.</p>

        <table style="margin-top:15px;">
            <tr>
                <td><b>Book:</b></td>
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
    """.formatted(bookTitle, isbn, safeReason);

        return getBaseTemplate("Extend Request Rejected", content);
    }

}

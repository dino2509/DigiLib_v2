/*
  DigiLibExtraSeed.sql (FIXED)
  - Run AFTER db/DigiLibDBScript.sql
  - SQL Server (T-SQL)
  - Fix: Borrow.request_id is UNIQUE => always create a dedicated Borrow_Request per seeded Borrow
*/

USE DigitalLibraryDB;
GO

SET NOCOUNT ON;
GO

BEGIN TRY
    BEGIN TRAN;

    /* =========================
       0) LOOKUP ROLE IDs
       ========================= */
    DECLARE @ROLE_ADMIN INT = (SELECT role_id FROM Role WHERE role_name = N'ADMIN');
    DECLARE @ROLE_LIBRARIAN INT = (SELECT role_id FROM Role WHERE role_name = N'LIBRARIAN');
    DECLARE @ROLE_SELLER INT = (SELECT role_id FROM Role WHERE role_name = N'SELLER');
    DECLARE @ROLE_USER INT = (SELECT role_id FROM Role WHERE role_name = N'USER');

    /* =========================
       1) ADD EMPLOYEES (SELLER, EXTRA LIBRARIAN)
       ========================= */
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE email = 'seller@lib.com')
    BEGIN
        INSERT INTO Employee (full_name, email, password_hash, status, role_id)
        VALUES (N'Seller Team', 'seller@lib.com', 'hash_seller', 'active', @ROLE_SELLER);
    END

    IF NOT EXISTS (SELECT 1 FROM Employee WHERE email = 'librarian2@lib.com')
    BEGIN
        INSERT INTO Employee (full_name, email, password_hash, status, role_id)
        VALUES (N'Librarian B', 'librarian2@lib.com', 'hash_librarian2', 'active', @ROLE_LIBRARIAN);
    END

    DECLARE @EMP_ADMIN INT = (SELECT TOP 1 employee_id FROM Employee WHERE email = 'admin@lib.com');
    DECLARE @EMP_LIB_A INT = (SELECT TOP 1 employee_id FROM Employee WHERE email = 'librarian@lib.com');
    DECLARE @EMP_LIB_B INT = (SELECT TOP 1 employee_id FROM Employee WHERE email = 'librarian2@lib.com');
    DECLARE @EMP_SELLER INT = (SELECT TOP 1 employee_id FROM Employee WHERE email = 'seller@lib.com');

    /* =========================
       2) ADD READERS (MORE USERS)
       ========================= */
    IF NOT EXISTS (SELECT 1 FROM Reader WHERE email = 'd@mail.com')
    BEGIN
        INSERT INTO Reader (full_name, email, password_hash, phone, status, role_id)
        VALUES (N'Pham Thi D', 'd@mail.com', 'hash_d', '090000004', 'active', @ROLE_USER);
    END

    IF NOT EXISTS (SELECT 1 FROM Reader WHERE email = 'e@mail.com')
    BEGIN
        INSERT INTO Reader (full_name, email, password_hash, phone, status, role_id)
        VALUES (N'Hoang Van E', 'e@mail.com', 'hash_e', '090000005', 'active', @ROLE_USER);
    END

    IF NOT EXISTS (SELECT 1 FROM Reader WHERE email = 'f@mail.com')
    BEGIN
        INSERT INTO Reader (full_name, email, password_hash, phone, status, role_id)
        VALUES (N'Vu Thi F', 'f@mail.com', 'hash_f', '090000006', 'inactive', @ROLE_USER);
    END

    DECLARE @R_A INT = (SELECT reader_id FROM Reader WHERE email = 'a@mail.com');
    DECLARE @R_B INT = (SELECT reader_id FROM Reader WHERE email = 'b@mail.com');
    DECLARE @R_C INT = (SELECT reader_id FROM Reader WHERE email = 'c@mail.com');
    DECLARE @R_D INT = (SELECT reader_id FROM Reader WHERE email = 'd@mail.com');
    DECLARE @R_E INT = (SELECT reader_id FROM Reader WHERE email = 'e@mail.com');
    DECLARE @R_F INT = (SELECT reader_id FROM Reader WHERE email = 'f@mail.com');

    /* Reader_Account (multi-provider) */
    IF @R_D IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Reader_Account WHERE reader_id = @R_D AND provider = 'google')
    BEGIN
        INSERT INTO Reader_Account (reader_id, provider, provider_user_id)
        VALUES (@R_D, 'google', 'google_789');
    END

    IF @R_E IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Reader_Account WHERE reader_id = @R_E AND provider = 'local')
    BEGIN
        INSERT INTO Reader_Account (reader_id, provider, provider_user_id)
        VALUES (@R_E, 'local', NULL);
    END

    /* =========================
       3) AUTHORS & CATEGORIES (MORE)
       ========================= */
    IF NOT EXISTS (SELECT 1 FROM Author WHERE author_name = N'Robert C. Martin')
        INSERT INTO Author (author_name, bio) VALUES (N'Robert C. Martin', N'Tác giả Clean Code.');

    IF NOT EXISTS (SELECT 1 FROM Author WHERE author_name = N'Andrew S. Tanenbaum')
        INSERT INTO Author (author_name, bio) VALUES (N'Andrew S. Tanenbaum', N'Tác giả về hệ điều hành và mạng.');

    IF NOT EXISTS (SELECT 1 FROM Author WHERE author_name = N'Martin Fowler')
        INSERT INTO Author (author_name, bio) VALUES (N'Martin Fowler', N'Tác giả về kiến trúc phần mềm.');

    IF NOT EXISTS (SELECT 1 FROM Category WHERE category_name = N'Kỹ năng')
        INSERT INTO Category (category_name, description) VALUES (N'Kỹ năng', N'Sách kỹ năng mềm / phát triển bản thân');

    IF NOT EXISTS (SELECT 1 FROM Category WHERE category_name = N'Kiến trúc phần mềm')
        INSERT INTO Category (category_name, description) VALUES (N'Kiến trúc phần mềm', N'Architecture, patterns, best practices');

    IF NOT EXISTS (SELECT 1 FROM Category WHERE category_name = N'Hệ điều hành')
        INSERT INTO Category (category_name, description) VALUES (N'Hệ điều hành', N'Operating systems');

    DECLARE @AU_RCM INT = (SELECT TOP 1 author_id FROM Author WHERE author_name = N'Robert C. Martin');
    DECLARE @AU_AST INT = (SELECT TOP 1 author_id FROM Author WHERE author_name = N'Andrew S. Tanenbaum');
    DECLARE @AU_MF  INT = (SELECT TOP 1 author_id FROM Author WHERE author_name = N'Martin Fowler');

    DECLARE @CAT_ARCH  INT = (SELECT TOP 1 category_id FROM Category WHERE category_name = N'Kiến trúc phần mềm');
    DECLARE @CAT_OS    INT = (SELECT TOP 1 category_id FROM Category WHERE category_name = N'Hệ điều hành');
    DECLARE @CAT_SKILL INT = (SELECT TOP 1 category_id FROM Category WHERE category_name = N'Kỹ năng');

    /* =========================
       4) BOOKS (MORE)
       ========================= */
    IF NOT EXISTS (SELECT 1 FROM Book WHERE title = N'Clean Code')
    BEGIN
        INSERT INTO Book (
            title, summary, description, cover_url, content_path,
            price, currency, total_pages, preview_pages, status,
            author_id, category_id, created_by_employee_id
        )
        VALUES (
            N'Clean Code',
            N'Kỹ thuật viết code sạch',
            N'Tập trung vào các nguyên tắc viết code dễ đọc, dễ bảo trì.',
            N'/assets/covers/clean-code.jpg',
            N'/content/clean-code.pdf',
            180000, 'VND', 450, 25, 'active',
            @AU_RCM, @CAT_ARCH, @EMP_SELLER
        );
    END

    IF NOT EXISTS (SELECT 1 FROM Book WHERE title = N'Refactoring')
    BEGIN
        INSERT INTO Book (
            title, summary, description, cover_url, content_path,
            price, currency, total_pages, preview_pages, status,
            author_id, category_id, created_by_employee_id
        )
        VALUES (
            N'Refactoring',
            N'Cải tiến thiết kế mã nguồn',
            N'Các kỹ thuật refactor phổ biến và cách áp dụng.',
            N'/assets/covers/refactoring.jpg',
            N'/content/refactoring.pdf',
            200000, 'VND', 500, 30, 'active',
            @AU_MF, @CAT_ARCH, @EMP_SELLER
        );
    END

    IF NOT EXISTS (SELECT 1 FROM Book WHERE title = N'Operating Systems: Design and Implementation')
    BEGIN
        INSERT INTO Book (
            title, summary, description, cover_url, content_path,
            price, currency, total_pages, preview_pages, status,
            author_id, category_id, created_by_employee_id
        )
        VALUES (
            N'Operating Systems: Design and Implementation',
            N'Hệ điều hành - thiết kế và triển khai',
            N'Tập trung vào nguyên lý hệ điều hành và ví dụ minh hoạ.',
            N'/assets/covers/osdi.jpg',
            N'/content/osdi.pdf',
            220000, 'VND', 650, 20, 'active',
            @AU_AST, @CAT_OS, @EMP_SELLER
        );
    END

    IF NOT EXISTS (SELECT 1 FROM Book WHERE title = N'Nhà giả kim')
    BEGIN
        INSERT INTO Book (
            title, summary, description, cover_url, content_path,
            price, currency, total_pages, preview_pages, status,
            author_id, category_id, created_by_employee_id
        )
        VALUES (
            N'Nhà giả kim',
            N'Tiểu thuyết truyền cảm hứng',
            N'Một hành trình tìm kho báu và ý nghĩa cuộc sống.',
            N'/assets/covers/nha-gia-kim.jpg',
            N'/content/nha-gia-kim.pdf',
            90000, 'VND', 230, 15, 'active',
            NULL, @CAT_SKILL, @EMP_ADMIN
        );
    END

    /* Grab book ids for later flows */
    DECLARE @B_VE_DI_TUOI_THO INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Cho tôi xin một vé đi tuổi thơ');
    DECLARE @B_HP1 INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Harry Potter 1');
    DECLARE @B_HP2 INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Harry Potter 2');
    DECLARE @B_SQL INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Lập trình SQL cơ bản');

    DECLARE @B_CLEANCODE INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Clean Code');
    DECLARE @B_REFACTOR  INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Refactoring');
    DECLARE @B_OSDI      INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Operating Systems: Design and Implementation');
    DECLARE @B_NGK       INT = (SELECT TOP 1 book_id FROM Book WHERE title = N'Nhà giả kim');

    /* =========================
       5) BOOK COPIES (MORE)
       ========================= */
    IF @B_HP1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-005')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_HP1, N'CP-005', 'available');

    IF @B_HP1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-006')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_HP1, N'CP-006', 'reserved');

    IF @B_HP2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-007')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_HP2, N'CP-007', 'available');

    IF @B_SQL IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-008')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_SQL, N'CP-008', 'lost');

    IF @B_VE_DI_TUOI_THO IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-009')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_VE_DI_TUOI_THO, N'CP-009', 'damaged');

    IF @B_VE_DI_TUOI_THO IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-010')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_VE_DI_TUOI_THO, N'CP-010', 'available');

    IF @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-011')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_CLEANCODE, N'CP-011', 'available');

    IF @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-012')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_CLEANCODE, N'CP-012', 'borrowed');

    IF @B_REFACTOR IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-013')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_REFACTOR, N'CP-013', 'available');

    IF @B_NGK IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BookCopy WHERE copy_code = N'CP-014')
        INSERT INTO BookCopy (book_id, copy_code, status) VALUES (@B_NGK, N'CP-014', 'available');

    /* =========================
       6) CARTS
       ========================= */
    DECLARE @CART_D INT;
    SELECT @CART_D = cart_id FROM Cart WHERE reader_id = @R_D AND status = 'active';
    IF @R_D IS NOT NULL AND @CART_D IS NULL
    BEGIN
        INSERT INTO Cart (reader_id, status) VALUES (@R_D, 'active');
        SET @CART_D = SCOPE_IDENTITY();
    END

    IF @CART_D IS NOT NULL AND @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cart_Item WHERE cart_id = @CART_D AND book_id = @B_CLEANCODE)
        INSERT INTO Cart_Item (cart_id, book_id, quantity) VALUES (@CART_D, @B_CLEANCODE, 1);

    IF @CART_D IS NOT NULL AND @B_NGK IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cart_Item WHERE cart_id = @CART_D AND book_id = @B_NGK)
        INSERT INTO Cart_Item (cart_id, book_id, quantity) VALUES (@CART_D, @B_NGK, 2);

    DECLARE @CART_E INT;
    SELECT @CART_E = cart_id FROM Cart WHERE reader_id = @R_E AND status = 'active';
    IF @R_E IS NOT NULL AND @CART_E IS NULL
    BEGIN
        INSERT INTO Cart (reader_id, status) VALUES (@R_E, 'active');
        SET @CART_E = SCOPE_IDENTITY();
    END

    IF @CART_E IS NOT NULL AND @B_REFACTOR IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cart_Item WHERE cart_id = @CART_E AND book_id = @B_REFACTOR)
        INSERT INTO Cart_Item (cart_id, book_id, quantity) VALUES (@CART_E, @B_REFACTOR, 1);

    /* =========================
       7) ORDERS + PAYMENTS + OWNERSHIP
       ========================= */

    /* Reader D - paid order */
    DECLARE @ORDER_D_PAID INT;
    SELECT @ORDER_D_PAID = order_id FROM [Order] WHERE reader_id = @R_D AND status = 'paid' AND total_amount = 270000;

    IF @R_D IS NOT NULL AND @ORDER_D_PAID IS NULL
    BEGIN
        INSERT INTO [Order] (reader_id, total_amount, currency, status)
        VALUES (@R_D, 270000, 'VND', 'paid');
        SET @ORDER_D_PAID = SCOPE_IDENTITY();

        INSERT INTO Order_Book (order_id, book_id, price, quantity)
        VALUES
            (@ORDER_D_PAID, @B_CLEANCODE, 180000, 1),
            (@ORDER_D_PAID, @B_NGK, 90000, 1);

        INSERT INTO Payment (order_id, amount, payment_method, payment_status, transaction_code, paid_at)
        VALUES (@ORDER_D_PAID, 270000, 'VNPay', 'success', CONCAT('TXN-D-', @ORDER_D_PAID), SYSUTCDATETIME());

        IF NOT EXISTS (SELECT 1 FROM Reader_Book_Ownership WHERE reader_id = @R_D AND book_id = @B_CLEANCODE AND status = 'active')
            INSERT INTO Reader_Book_Ownership (reader_id, book_id, acquired_via, status) VALUES (@R_D, @B_CLEANCODE, 'order', 'active');

        IF NOT EXISTS (SELECT 1 FROM Reader_Book_Ownership WHERE reader_id = @R_D AND book_id = @B_NGK AND status = 'active')
            INSERT INTO Reader_Book_Ownership (reader_id, book_id, acquired_via, status) VALUES (@R_D, @B_NGK, 'order', 'active');
    END

    /* Reader E - pending order */
    DECLARE @ORDER_E_PENDING INT;
    SELECT @ORDER_E_PENDING = order_id FROM [Order] WHERE reader_id = @R_E AND status = 'pending' AND total_amount = 200000;

    IF @R_E IS NOT NULL AND @ORDER_E_PENDING IS NULL
    BEGIN
        INSERT INTO [Order] (reader_id, total_amount, currency, status)
        VALUES (@R_E, 200000, 'VND', 'pending');
        SET @ORDER_E_PENDING = SCOPE_IDENTITY();

        INSERT INTO Order_Book (order_id, book_id, price, quantity)
        VALUES (@ORDER_E_PENDING, @B_REFACTOR, 200000, 1);

        INSERT INTO Payment (order_id, amount, payment_method, payment_status, transaction_code)
        VALUES (@ORDER_E_PENDING, 200000, 'Momo', 'pending', CONCAT('TXN-E-', @ORDER_E_PENDING));
    END

    /* Reader C - cancelled order */
    DECLARE @ORDER_C_CANCELLED INT;
    SELECT @ORDER_C_CANCELLED = order_id FROM [Order] WHERE reader_id = @R_C AND status = 'cancelled' AND total_amount = 220000;

    IF @R_C IS NOT NULL AND @ORDER_C_CANCELLED IS NULL
    BEGIN
        INSERT INTO [Order] (reader_id, total_amount, currency, status)
        VALUES (@R_C, 220000, 'VND', 'cancelled');
        SET @ORDER_C_CANCELLED = SCOPE_IDENTITY();

        INSERT INTO Order_Book (order_id, book_id, price, quantity)
        VALUES (@ORDER_C_CANCELLED, @B_OSDI, 220000, 1);

        INSERT INTO Payment (order_id, amount, payment_method, payment_status, transaction_code)
        VALUES (@ORDER_C_CANCELLED, 220000, 'VNPay', 'failed', CONCAT('TXN-C-', @ORDER_C_CANCELLED));
    END

    /* Promo/admin_grant */
    IF @R_B IS NOT NULL AND @B_NGK IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Reader_Book_Ownership WHERE reader_id = @R_B AND book_id = @B_NGK)
        INSERT INTO Reader_Book_Ownership (reader_id, book_id, acquired_via, status) VALUES (@R_B, @B_NGK, 'promo', 'active');

    IF @R_E IS NOT NULL AND @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Reader_Book_Ownership WHERE reader_id = @R_E AND book_id = @B_CLEANCODE)
        INSERT INTO Reader_Book_Ownership (reader_id, book_id, acquired_via, status) VALUES (@R_E, @B_CLEANCODE, 'admin_grant', 'revoked');

    /* =========================
       8) BORROW REQUESTS (PENDING/REJECTED/CANCELLED)
       ========================= */

    /* Pending request by Reader D */
    DECLARE @REQ_D_PENDING INT;
    SELECT @REQ_D_PENDING = request_id FROM Borrow_Request WHERE reader_id = @R_D AND status = 'pending' AND note = N'SEED::REQ::D::PENDING';
    IF @R_D IS NOT NULL AND @REQ_D_PENDING IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note)
        VALUES (@R_D, 'pending', N'SEED::REQ::D::PENDING');
        SET @REQ_D_PENDING = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES
            (@REQ_D_PENDING, @B_CLEANCODE, 1),
            (@REQ_D_PENDING, @B_HP2, 1);
    END

    /* Rejected request by Reader E */
    DECLARE @REQ_E_REJECTED INT;
    SELECT @REQ_E_REJECTED = request_id FROM Borrow_Request WHERE reader_id = @R_E AND status = 'rejected' AND note = N'SEED::REQ::E::REJECTED';
    IF @R_E IS NOT NULL AND @REQ_E_REJECTED IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note, processed_by_employee_id, processed_at, decision_note)
        VALUES (@R_E, 'rejected', N'SEED::REQ::E::REJECTED', @EMP_LIB_A, SYSUTCDATETIME(), N'Tài khoản cần active và không có phạt quá hạn.');
        SET @REQ_E_REJECTED = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES (@REQ_E_REJECTED, @B_HP1, 1);
    END

    /* Cancelled request by Reader C */
    DECLARE @REQ_C_CANCELLED INT;
    SELECT @REQ_C_CANCELLED = request_id FROM Borrow_Request WHERE reader_id = @R_C AND status = 'cancelled' AND note = N'SEED::REQ::C::CANCELLED';
    IF @R_C IS NOT NULL AND @REQ_C_CANCELLED IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note, processed_by_employee_id, processed_at, decision_note)
        VALUES (@R_C, 'cancelled', N'SEED::REQ::C::CANCELLED', @EMP_LIB_B, SYSUTCDATETIME(), N'Reader cancelled');
        SET @REQ_C_CANCELLED = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES (@REQ_C_CANCELLED, @B_VE_DI_TUOI_THO, 1);
    END

    /* =========================
       9) BORROWS + BORROW ITEMS
       - FIX: each seeded borrow has its own Borrow_Request (request_id UNIQUE)
       ========================= */

    /* 9.1) OVERDUE borrow for Reader A using CP-010 */
    DECLARE @COPY_CP010 INT = (SELECT copy_id FROM BookCopy WHERE copy_code = N'CP-010');
    DECLARE @REQ_A_OVERDUE INT;
    SELECT @REQ_A_OVERDUE = request_id FROM Borrow_Request WHERE reader_id = @R_A AND note = N'SEED::REQ::A::OVERDUE';

    IF @R_A IS NOT NULL AND @REQ_A_OVERDUE IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note, processed_by_employee_id, processed_at, decision_note)
        VALUES (@R_A, 'approved', N'SEED::REQ::A::OVERDUE', @EMP_LIB_A, SYSUTCDATETIME(), N'Seed approved for overdue scenario');
        SET @REQ_A_OVERDUE = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES (@REQ_A_OVERDUE, @B_VE_DI_TUOI_THO, 1);
    END

    DECLARE @BORROW_A_OVERDUE INT = (SELECT borrow_id FROM Borrow WHERE request_id = @REQ_A_OVERDUE);
    IF @REQ_A_OVERDUE IS NOT NULL AND @BORROW_A_OVERDUE IS NULL AND @COPY_CP010 IS NOT NULL
    BEGIN
        INSERT INTO Borrow (reader_id, request_id, status, approved_by_employee_id)
        VALUES (@R_A, @REQ_A_OVERDUE, 'overdue', @EMP_LIB_A);
        SET @BORROW_A_OVERDUE = SCOPE_IDENTITY();
    END

    IF @BORROW_A_OVERDUE IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Borrow_Item WHERE borrow_id = @BORROW_A_OVERDUE AND copy_id = @COPY_CP010)
        BEGIN
            INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, returned_at, status)
            VALUES (
                @BORROW_A_OVERDUE,
                @COPY_CP010,
                DATEADD(day, -5, SYSUTCDATETIME()),
                NULL,
                'overdue'
            );
        END

        UPDATE BookCopy SET status = 'borrowed' WHERE copy_id = @COPY_CP010;
    END

    /* 9.2) COMPLETED borrow for Reader D using CP-011 */
    DECLARE @COPY_CP011 INT = (SELECT copy_id FROM BookCopy WHERE copy_code = N'CP-011');
    DECLARE @REQ_D_COMPLETED INT;
    SELECT @REQ_D_COMPLETED = request_id FROM Borrow_Request WHERE reader_id = @R_D AND note = N'SEED::REQ::D::COMPLETED';

    IF @R_D IS NOT NULL AND @REQ_D_COMPLETED IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note, processed_by_employee_id, processed_at, decision_note)
        VALUES (@R_D, 'approved', N'SEED::REQ::D::COMPLETED', @EMP_LIB_B, SYSUTCDATETIME(), N'Seed approved for completed scenario');
        SET @REQ_D_COMPLETED = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES (@REQ_D_COMPLETED, @B_CLEANCODE, 1);
    END

    DECLARE @BORROW_D_COMPLETED INT = (SELECT borrow_id FROM Borrow WHERE request_id = @REQ_D_COMPLETED);
    IF @REQ_D_COMPLETED IS NOT NULL AND @BORROW_D_COMPLETED IS NULL AND @COPY_CP011 IS NOT NULL
    BEGIN
        INSERT INTO Borrow (reader_id, request_id, status, approved_by_employee_id)
        VALUES (@R_D, @REQ_D_COMPLETED, 'completed', @EMP_LIB_B);
        SET @BORROW_D_COMPLETED = SCOPE_IDENTITY();
    END

    IF @BORROW_D_COMPLETED IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Borrow_Item WHERE borrow_id = @BORROW_D_COMPLETED AND copy_id = @COPY_CP011)
        BEGIN
            INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, returned_at, status)
            VALUES (
                @BORROW_D_COMPLETED,
                @COPY_CP011,
                DATEADD(day, -2, SYSUTCDATETIME()),
                SYSUTCDATETIME(),
                'returned'
            );
        END

        UPDATE BookCopy SET status = 'available' WHERE copy_id = @COPY_CP011;
    END

    /* 9.3) ACTIVE borrow for Reader B with LOST item using CP-008 */
    DECLARE @COPY_CP008 INT = (SELECT copy_id FROM BookCopy WHERE copy_code = N'CP-008');
    DECLARE @REQ_B_LOST INT;
    SELECT @REQ_B_LOST = request_id FROM Borrow_Request WHERE reader_id = @R_B AND note = N'SEED::REQ::B::LOST';

    IF @R_B IS NOT NULL AND @REQ_B_LOST IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note, processed_by_employee_id, processed_at, decision_note)
        VALUES (@R_B, 'approved', N'SEED::REQ::B::LOST', @EMP_LIB_A, SYSUTCDATETIME(), N'Seed approved for lost scenario');
        SET @REQ_B_LOST = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES (@REQ_B_LOST, @B_SQL, 1);
    END

    DECLARE @BORROW_B_ACTIVE INT = (SELECT borrow_id FROM Borrow WHERE request_id = @REQ_B_LOST);
    IF @REQ_B_LOST IS NOT NULL AND @BORROW_B_ACTIVE IS NULL AND @COPY_CP008 IS NOT NULL
    BEGIN
        INSERT INTO Borrow (reader_id, request_id, status, approved_by_employee_id)
        VALUES (@R_B, @REQ_B_LOST, 'active', @EMP_LIB_A);
        SET @BORROW_B_ACTIVE = SCOPE_IDENTITY();
    END

    IF @BORROW_B_ACTIVE IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Borrow_Item WHERE borrow_id = @BORROW_B_ACTIVE AND copy_id = @COPY_CP008)
        BEGIN
            INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, returned_at, status)
            VALUES (
                @BORROW_B_ACTIVE,
                @COPY_CP008,
                DATEADD(day, 10, SYSUTCDATETIME()),
                NULL,
                'lost'
            );
        END

        UPDATE BookCopy SET status = 'lost' WHERE copy_id = @COPY_CP008;
    END

    /* 9.4) ACTIVE borrow for Reader C with DAMAGED item using CP-009 */
    DECLARE @COPY_CP009 INT = (SELECT copy_id FROM BookCopy WHERE copy_code = N'CP-009');
    DECLARE @REQ_C_DAMAGED INT;
    SELECT @REQ_C_DAMAGED = request_id FROM Borrow_Request WHERE reader_id = @R_C AND note = N'SEED::REQ::C::DAMAGED';

    IF @R_C IS NOT NULL AND @REQ_C_DAMAGED IS NULL
    BEGIN
        INSERT INTO Borrow_Request (reader_id, status, note, processed_by_employee_id, processed_at, decision_note)
        VALUES (@R_C, 'approved', N'SEED::REQ::C::DAMAGED', @EMP_LIB_B, SYSUTCDATETIME(), N'Seed approved for damaged scenario');
        SET @REQ_C_DAMAGED = SCOPE_IDENTITY();

        INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
        VALUES (@REQ_C_DAMAGED, @B_VE_DI_TUOI_THO, 1);
    END

    DECLARE @BORROW_C_ACTIVE INT = (SELECT borrow_id FROM Borrow WHERE request_id = @REQ_C_DAMAGED);
    IF @REQ_C_DAMAGED IS NOT NULL AND @BORROW_C_ACTIVE IS NULL AND @COPY_CP009 IS NOT NULL
    BEGIN
        INSERT INTO Borrow (reader_id, request_id, status, approved_by_employee_id)
        VALUES (@R_C, @REQ_C_DAMAGED, 'active', @EMP_LIB_B);
        SET @BORROW_C_ACTIVE = SCOPE_IDENTITY();
    END

    IF @BORROW_C_ACTIVE IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Borrow_Item WHERE borrow_id = @BORROW_C_ACTIVE AND copy_id = @COPY_CP009)
        BEGIN
            INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, returned_at, status)
            VALUES (
                @BORROW_C_ACTIVE,
                @COPY_CP009,
                DATEADD(day, 7, SYSUTCDATETIME()),
                NULL,
                'damaged'
            );
        END

        UPDATE BookCopy SET status = 'damaged' WHERE copy_id = @COPY_CP009;
    END

    /* =========================
       10) BORROW EXTEND (PENDING/REJECTED)
       ========================= */
    DECLARE @BORROW_ITEM_A_OVERDUE INT =
        (SELECT TOP 1 bi.borrow_item_id
         FROM Borrow_Item bi
         JOIN Borrow b ON b.borrow_id = bi.borrow_id
         WHERE b.request_id = @REQ_A_OVERDUE AND bi.status = 'overdue'
         ORDER BY bi.borrow_item_id DESC);

    IF @BORROW_ITEM_A_OVERDUE IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Borrow_Extend WHERE borrow_item_id = @BORROW_ITEM_A_OVERDUE AND status = 'pending')
        BEGIN
            DECLARE @OLD_DUE_A DATETIME2 = (SELECT due_date FROM Borrow_Item WHERE borrow_item_id = @BORROW_ITEM_A_OVERDUE);
            INSERT INTO Borrow_Extend (
                borrow_item_id, old_due_date, requested_due_date,
                approved_due_date, status, requested_at, approved_by_employee_id, decision_note
            )
            VALUES (
                @BORROW_ITEM_A_OVERDUE,
                @OLD_DUE_A,
                DATEADD(day, 7, @OLD_DUE_A),
                NULL,
                'pending',
                SYSUTCDATETIME(),
                NULL,
                NULL
            );
        END
    END

    DECLARE @BORROW_ITEM_B_LOST INT =
        (SELECT TOP 1 bi.borrow_item_id
         FROM Borrow_Item bi
         JOIN Borrow b ON b.borrow_id = bi.borrow_id
         WHERE b.request_id = @REQ_B_LOST AND bi.status = 'lost'
         ORDER BY bi.borrow_item_id DESC);

    IF @BORROW_ITEM_B_LOST IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Borrow_Extend WHERE borrow_item_id = @BORROW_ITEM_B_LOST AND status = 'rejected')
        BEGIN
            DECLARE @OLD_DUE_B DATETIME2 = (SELECT due_date FROM Borrow_Item WHERE borrow_item_id = @BORROW_ITEM_B_LOST);
            INSERT INTO Borrow_Extend (
                borrow_item_id, old_due_date, requested_due_date,
                approved_due_date, status, requested_at, processed_at,
                approved_by_employee_id, decision_note
            )
            VALUES (
                @BORROW_ITEM_B_LOST,
                @OLD_DUE_B,
                DATEADD(day, 7, @OLD_DUE_B),
                NULL,
                'rejected',
                DATEADD(minute, -30, SYSUTCDATETIME()),
                SYSUTCDATETIME(),
                @EMP_LIB_A,
                N'Không thể gia hạn vì trạng thái bản sao không hợp lệ (lost).'
            );
        END
    END

    /* =========================
       11) FINE TYPES + FINES
       ========================= */
    IF NOT EXISTS (SELECT 1 FROM Fine_Type WHERE name = 'lost')
        INSERT INTO Fine_Type (name, description, default_amount, per_day_rate)
        VALUES ('lost', N'Phạt mất sách', 200000, NULL);

    IF NOT EXISTS (SELECT 1 FROM Fine_Type WHERE name = 'damaged')
        INSERT INTO Fine_Type (name, description, default_amount, per_day_rate)
        VALUES ('damaged', N'Phạt hư hỏng sách', 80000, NULL);

    DECLARE @FINE_LATE INT = (SELECT fine_type_id FROM Fine_Type WHERE name = 'late_return');
    DECLARE @FINE_LOST INT = (SELECT fine_type_id FROM Fine_Type WHERE name = 'lost');
    DECLARE @FINE_DMG  INT = (SELECT fine_type_id FROM Fine_Type WHERE name = 'damaged');

    IF @BORROW_ITEM_A_OVERDUE IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Fine WHERE reader_id = @R_A AND borrow_item_id = @BORROW_ITEM_A_OVERDUE AND fine_type_id = @FINE_LATE
    )
    BEGIN
        INSERT INTO Fine (reader_id, borrow_item_id, fine_type_id, amount, reason, status, handled_by_employee_id)
        VALUES (@R_A, @BORROW_ITEM_A_OVERDUE, @FINE_LATE, 25000, N'Trễ hạn 5 ngày', 'unpaid', @EMP_LIB_A);
    END

    IF @BORROW_ITEM_B_LOST IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Fine WHERE reader_id = @R_B AND borrow_item_id = @BORROW_ITEM_B_LOST AND fine_type_id = @FINE_LOST
    )
    BEGIN
        INSERT INTO Fine (reader_id, borrow_item_id, fine_type_id, amount, reason, status, paid_at, handled_by_employee_id)
        VALUES (@R_B, @BORROW_ITEM_B_LOST, @FINE_LOST, 200000, N'Mất sách', 'paid', SYSUTCDATETIME(), @EMP_LIB_A);
    END

    DECLARE @BORROW_ITEM_C_DMG INT =
        (SELECT TOP 1 bi.borrow_item_id
         FROM Borrow_Item bi
         JOIN Borrow b ON b.borrow_id = bi.borrow_id
         WHERE b.request_id = @REQ_C_DAMAGED AND bi.status = 'damaged'
         ORDER BY bi.borrow_item_id DESC);

    IF @BORROW_ITEM_C_DMG IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Fine WHERE reader_id = @R_C AND borrow_item_id = @BORROW_ITEM_C_DMG AND fine_type_id = @FINE_DMG
    )
    BEGIN
        INSERT INTO Fine (reader_id, borrow_item_id, fine_type_id, amount, reason, status, handled_by_employee_id)
        VALUES (@R_C, @BORROW_ITEM_C_DMG, @FINE_DMG, 80000, N'Hư hỏng nhẹ - miễn phí', 'waived', @EMP_LIB_B);
    END

    /* =========================
       12) READING HISTORY + BOOKMARK + REVIEW
       ========================= */
    IF @R_D IS NOT NULL AND @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Reading_History WHERE reader_id = @R_D AND book_id = @B_CLEANCODE)
        INSERT INTO Reading_History (reader_id, book_id, last_read_position, last_read_at)
        VALUES (@R_D, @B_CLEANCODE, 88, SYSUTCDATETIME());

    IF @R_D IS NOT NULL AND @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Bookmark WHERE reader_id = @R_D AND book_id = @B_CLEANCODE AND page_number = 12)
        INSERT INTO Bookmark (reader_id, book_id, page_number, note)
        VALUES (@R_D, @B_CLEANCODE, 12, N'Nguyên tắc đặt tên biến');

    IF @R_D IS NOT NULL AND @B_CLEANCODE IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Review WHERE reader_id = @R_D AND book_id = @B_CLEANCODE)
        INSERT INTO Review (reader_id, book_id, rating, comment)
        VALUES (@R_D, @B_CLEANCODE, 5, N'Rất hữu ích cho việc cải thiện chất lượng code.');

    IF @R_B IS NOT NULL AND @B_NGK IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Review WHERE reader_id = @R_B AND book_id = @B_NGK)
        INSERT INTO Review (reader_id, book_id, rating, comment)
        VALUES (@R_B, @B_NGK, 4, N'Đọc nhẹ nhàng, nhiều thông điệp.');

    /* =========================
       13) NOTIFICATIONS
       ========================= */
    IF @R_D IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Notification WHERE reader_id = @R_D AND title = N'Đơn hàng đã thanh toán')
        INSERT INTO Notification (reader_id, title, message, type, is_read)
        VALUES (@R_D, N'Đơn hàng đã thanh toán', N'Đơn hàng của bạn đã được thanh toán thành công.', 'order', 0);

    IF @R_A IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Notification WHERE reader_id = @R_A AND title = N'Nhắc nhở quá hạn')
        INSERT INTO Notification (reader_id, title, message, type, is_read)
        VALUES (@R_A, N'Nhắc nhở quá hạn', N'Bạn đang có sách mượn đã quá hạn. Vui lòng trả sách hoặc gia hạn.', 'overdue', 0);

    IF @R_C IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Notification WHERE reader_id = @R_C AND title = N'Thông báo hệ thống')
        INSERT INTO Notification (reader_id, title, message, type, is_read)
        VALUES (@R_C, N'Thông báo hệ thống', N'Hệ thống vừa được cập nhật tính năng mới.', 'system', 1);

    /* =========================
       14) RESERVATIONS
       ========================= */
    DECLARE @RES_D_ACTIVE INT;
    SELECT @RES_D_ACTIVE = reservation_id FROM Reservation WHERE reader_id = @R_D AND status = 'active';
    IF @R_D IS NOT NULL AND @RES_D_ACTIVE IS NULL
    BEGIN
        INSERT INTO Reservation (reader_id, status, expires_at, note)
        VALUES (@R_D, 'active', DATEADD(day, 3, SYSUTCDATETIME()), N'Đặt trước Harry Potter 2');
        SET @RES_D_ACTIVE = SCOPE_IDENTITY();

        INSERT INTO Reservation_Item (reservation_id, book_id, quantity)
        VALUES (@RES_D_ACTIVE, @B_HP2, 1);
    END

    DECLARE @RES_E_EXPIRED INT;
    SELECT @RES_E_EXPIRED = reservation_id FROM Reservation WHERE reader_id = @R_E AND status = 'expired';
    IF @R_E IS NOT NULL AND @RES_E_EXPIRED IS NULL
    BEGIN
        INSERT INTO Reservation (reader_id, status, expires_at, note)
        VALUES (@R_E, 'expired', DATEADD(day, -1, SYSUTCDATETIME()), N'Đặt trước nhưng hết hạn');
        SET @RES_E_EXPIRED = SCOPE_IDENTITY();

        INSERT INTO Reservation_Item (reservation_id, book_id, quantity)
        VALUES (@RES_E_EXPIRED, @B_HP1, 1);
    END

    DECLARE @RES_B_NOTIFIED INT;
    SELECT @RES_B_NOTIFIED = reservation_id FROM Reservation WHERE reader_id = @R_B AND status = 'notified';
    IF @R_B IS NOT NULL AND @RES_B_NOTIFIED IS NULL
    BEGIN
        INSERT INTO Reservation (reader_id, status, expires_at, note)
        VALUES (@R_B, 'notified', DATEADD(day, 1, SYSUTCDATETIME()), N'Đã có sách, mời đến nhận');
        SET @RES_B_NOTIFIED = SCOPE_IDENTITY();

        INSERT INTO Reservation_Item (reservation_id, book_id, quantity)
        VALUES (@RES_B_NOTIFIED, @B_CLEANCODE, 1);

        IF NOT EXISTS (SELECT 1 FROM Notification WHERE reader_id = @R_B AND title = N'Sách đã sẵn sàng')
            INSERT INTO Notification (reader_id, title, message, type, is_read)
            VALUES (@R_B, N'Sách đã sẵn sàng', N'Sách bạn đặt đã sẵn sàng. Vui lòng đến thư viện để mượn trước khi hết hạn.', 'reservation', 0);
    END

    DECLARE @RES_C_COMPLETED INT;
    SELECT @RES_C_COMPLETED = reservation_id FROM Reservation WHERE reader_id = @R_C AND status = 'completed';
    IF @R_C IS NOT NULL AND @RES_C_COMPLETED IS NULL
    BEGIN
        INSERT INTO Reservation (reader_id, status, expires_at, fulfilled_at, note)
        VALUES (@R_C, 'completed', DATEADD(day, 5, SYSUTCDATETIME()), SYSUTCDATETIME(), N'Đã nhận sách thành công');
        SET @RES_C_COMPLETED = SCOPE_IDENTITY();

        INSERT INTO Reservation_Item (reservation_id, book_id, quantity)
        VALUES (@RES_C_COMPLETED, @B_REFACTOR, 1);
    END

    DECLARE @RES_A_CANCELLED INT;
    SELECT @RES_A_CANCELLED = reservation_id FROM Reservation WHERE reader_id = @R_A AND status = 'cancelled';
    IF @R_A IS NOT NULL AND @RES_A_CANCELLED IS NULL
    BEGIN
        INSERT INTO Reservation (reader_id, status, expires_at, note)
        VALUES (@R_A, 'cancelled', DATEADD(day, 2, SYSUTCDATETIME()), N'Huỷ đặt chỗ');
        SET @RES_A_CANCELLED = SCOPE_IDENTITY();

        INSERT INTO Reservation_Item (reservation_id, book_id, quantity)
        VALUES (@RES_A_CANCELLED, @B_NGK, 1);
    END

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;

    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrLine INT = ERROR_LINE();
    RAISERROR(N'[DigiLibExtraSeed] Error at line %d: %s', 16, 1, @ErrLine, @ErrMsg);
END CATCH;
GO

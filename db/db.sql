/*
  DigiLib_FullRebuild.sql
  Generated: 2026-02-02 15:24:12

  Behavior:
  - Drops existing [DigitalLibraryDB] if it exists (SINGLE_USER WITH ROLLBACK IMMEDIATE)
  - Recreates database
  - Builds schema + constraints
  - Seeds data (base + extra + extracted db2/db3)
*/
SET NOCOUNT ON;
SET XACT_ABORT OFF;
GO

USE [master];
GO

IF DB_ID(N'DigitalLibraryDB') IS NOT NULL
BEGIN
    ALTER DATABASE [DigitalLibraryDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [DigitalLibraryDB];
END
GO

CREATE DATABASE [DigitalLibraryDB];
GO

ALTER DATABASE [DigitalLibraryDB] SET MULTI_USER;
GO

USE [DigitalLibraryDB];
GO

-- ==================================================
-- (1) Schema + base seed (from DigiLibDBScript.sql)
-- ==================================================
USE DigitalLibraryDB;
GO

CREATE TABLE Role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(30) NOT NULL UNIQUE, -- ADMIN, LIBRARIAN, SELLER, USER
    description NVARCHAR(255) NULL
);
GO

CREATE TABLE Reader (
    reader_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255) NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    phone NVARCHAR(30) NULL,
    avatar NVARCHAR(255) NULL,
    status NVARCHAR(50) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    role_id INT NOT NULL,
    CONSTRAINT FK_Reader_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO

CREATE TABLE Reader_Account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    provider NVARCHAR(50) NOT NULL,          -- local, google, facebook, github...
    provider_user_id NVARCHAR(255) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ReaderAccount_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255) NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    status NVARCHAR(50) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    role_id INT NOT NULL,
    CONSTRAINT FK_Employee_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO

CREATE TABLE Author (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(255) NOT NULL,
    bio NVARCHAR(MAX) NULL
);
GO

CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);
GO

CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    summary NVARCHAR(MAX) NULL,
    description NVARCHAR(MAX) NULL,
    cover_url NVARCHAR(255) NULL,
    content_path NVARCHAR(500) NULL,
    price DECIMAL(10,2) NULL,
    currency NVARCHAR(10) NULL,
    total_pages INT NULL,
    preview_pages INT NULL,
    status NVARCHAR(50) NULL, -- active, inactive
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,

    author_id INT NULL,
    category_id INT NULL,

    created_by_employee_id INT NULL,
    updated_by_employee_id INT NULL,

    CONSTRAINT FK_Book_Author FOREIGN KEY (author_id) REFERENCES Author(author_id),
    CONSTRAINT FK_Book_Category FOREIGN KEY (category_id) REFERENCES Category(category_id),
    CONSTRAINT FK_Book_CreatedBy FOREIGN KEY (created_by_employee_id) REFERENCES Employee(employee_id),
    CONSTRAINT FK_Book_UpdatedBy FOREIGN KEY (updated_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE BookCopy (
    copy_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT NOT NULL,
    copy_code NVARCHAR(100) NOT NULL UNIQUE,
    status NVARCHAR(30) NOT NULL, -- available, borrowed, reserved, lost, damaged
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_BookCopy_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    status NVARCHAR(30) NOT NULL, -- active, checked_out, abandoned
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Cart_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

CREATE TABLE Cart_Item (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CartItem_Cart FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    CONSTRAINT FK_CartItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE [Order] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    currency NVARCHAR(10) NULL,
    status NVARCHAR(30) NOT NULL, -- pending, paid, cancelled, refunded
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Order_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

CREATE TABLE Order_Book (
    order_book_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_OrderBook_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    CONSTRAINT FK_OrderBook_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(50) NULL,
    payment_status NVARCHAR(30) NOT NULL, -- pending, success, failed
    transaction_code NVARCHAR(100) NULL,
    paid_at DATETIME2 NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);
GO

CREATE TABLE Reader_Book_Ownership (
    ownership_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    acquired_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    acquired_via NVARCHAR(30) NULL, -- order, promo, admin_grant
    status NVARCHAR(30) NULL,       -- active, revoked
    CONSTRAINT FK_Ownership_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Ownership_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Borrow_Request (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    status NVARCHAR(30) NOT NULL, -- pending, approved, rejected, cancelled, expired
    requested_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    note NVARCHAR(MAX) NULL,

    processed_by_employee_id INT NULL,
    processed_at DATETIME2 NULL,
    decision_note NVARCHAR(MAX) NULL,

    CONSTRAINT FK_BorrowRequest_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_BorrowRequest_ProcessedBy FOREIGN KEY (processed_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Borrow_Request_Item (
    request_item_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_BRItem_Request FOREIGN KEY (request_id) REFERENCES Borrow_Request(request_id),
    CONSTRAINT FK_BRItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Borrow (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    request_id INT NULL UNIQUE, -- 1 request -> 0..1 borrow
    borrow_date DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    status NVARCHAR(30) NOT NULL, -- active, overdue, completed, cancelled
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    approved_by_employee_id INT NULL,

    CONSTRAINT FK_Borrow_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Borrow_Request FOREIGN KEY (request_id) REFERENCES Borrow_Request(request_id),
    CONSTRAINT FK_Borrow_ApprovedBy FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Borrow_Item (
    borrow_item_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_id INT NOT NULL,
    copy_id INT NOT NULL,
    due_date DATETIME2 NOT NULL,
    returned_at DATETIME2 NULL,
    status NVARCHAR(30) NOT NULL, -- borrowed, returned, overdue, lost, damaged

    CONSTRAINT FK_BorrowItem_Borrow FOREIGN KEY (borrow_id) REFERENCES Borrow(borrow_id),
    CONSTRAINT FK_BorrowItem_Copy FOREIGN KEY (copy_id) REFERENCES BookCopy(copy_id)
);
GO

CREATE TABLE Borrow_Extend (
    extend_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_item_id INT NOT NULL,

    old_due_date DATETIME2 NOT NULL,
    requested_due_date DATETIME2 NOT NULL,
    approved_due_date DATETIME2 NULL,

    status NVARCHAR(30) NOT NULL, -- pending, approved, rejected, cancelled
    requested_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    processed_at DATETIME2 NULL,
    decision_note NVARCHAR(MAX) NULL,

    approved_by_employee_id INT NULL,

    CONSTRAINT FK_Extend_BorrowItem FOREIGN KEY (borrow_item_id) REFERENCES Borrow_Item(borrow_item_id),
    CONSTRAINT FK_Extend_ApprovedBy FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Fine_Type (
    fine_type_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL, -- late_return, lost, damaged
    description NVARCHAR(MAX) NULL,
    default_amount DECIMAL(10,2) NULL,
    per_day_rate DECIMAL(10,2) NULL
);
GO

CREATE TABLE Fine (
    fine_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    borrow_item_id INT NOT NULL,
    fine_type_id INT NOT NULL,

    amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    reason NVARCHAR(MAX) NULL,
    status NVARCHAR(30) NOT NULL, -- unpaid, paid, waived
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    paid_at DATETIME2 NULL,

    handled_by_employee_id INT NULL,

    CONSTRAINT FK_Fine_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Fine_BorrowItem FOREIGN KEY (borrow_item_id) REFERENCES Borrow_Item(borrow_item_id),
    CONSTRAINT FK_Fine_Type FOREIGN KEY (fine_type_id) REFERENCES Fine_Type(fine_type_id),
    CONSTRAINT FK_Fine_HandledBy FOREIGN KEY (handled_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Reading_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    last_read_position INT NULL,
    last_read_at DATETIME2 NULL,
    CONSTRAINT FK_ReadHistory_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_ReadHistory_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Bookmark (
    bookmark_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    page_number INT NOT NULL,
    note NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Bookmark_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Bookmark_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT NULL,
    comment NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Review_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Review_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Notification (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    message NVARCHAR(MAX) NULL,
    type NVARCHAR(30) NULL, -- borrow, overdue, reservation, order, system
    is_read BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Notification_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

-- =========================
-- RESERVATION
-- =========================
CREATE TABLE Reservation (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,

    status NVARCHAR(30) NOT NULL, 
    -- active, notified, completed, cancelled, expired

    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    expires_at DATETIME2 NULL,
    fulfilled_at DATETIME2 NULL,

    note NVARCHAR(MAX) NULL,

    CONSTRAINT FK_Reservation_Reader
        FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

-- =========================
-- RESERVATION ITEM
-- =========================
CREATE TABLE Reservation_Item (
    reservation_item_id INT IDENTITY(1,1) PRIMARY KEY,
    reservation_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,

    CONSTRAINT FK_ReservationItem_Reservation
        FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),

    CONSTRAINT FK_ReservationItem_Book
        FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

-- =========================
-- ROLE
-- =========================
INSERT INTO Role (role_name, description) VALUES
(N'ADMIN', N'Administrator'),
(N'LIBRARIAN', N'Librarian'),
(N'SELLER', N'Seller'),
(N'USER', N'Normal user');

-- =========================
-- EMPLOYEE
-- =========================
INSERT INTO Employee (full_name, email, password_hash, status, role_id)
VALUES
(N'Admin System', 'admin@lib.com', 'hash_admin', 'active', 1),
(N'Librarian A', 'librarian@lib.com', 'hash_librarian', 'active', 2);

-- =========================
-- READER
-- =========================
INSERT INTO Reader (full_name, email, password_hash, phone, status, role_id)
VALUES
(N'Nguyen Van A', 'a@mail.com', 'hash_a', '090000001', 'active', 4),
(N'Tran Thi B', 'b@mail.com', 'hash_b', '090000002', 'active', 4),
(N'Le Van C', 'c@mail.com', 'hash_c', '090000003', 'active', 4);

-- =========================
-- READER ACCOUNT
-- =========================
INSERT INTO Reader_Account (reader_id, provider, provider_user_id)
VALUES
(1, 'local', NULL),
(2, 'google', 'google_123'),
(3, 'facebook', 'fb_456');

-- =========================
-- AUTHOR & CATEGORY
-- =========================
INSERT INTO Author (author_name) VALUES
(N'Nguyễn Nhật Ánh'),
(N'J.K. Rowling');

INSERT INTO Category (category_name) VALUES
(N'Thiếu nhi'),
(N'Fantasy'),
(N'Công nghệ');

-- =========================
-- BOOK
-- =========================
INSERT INTO Book (
    title, summary, price, currency, total_pages, status,
    author_id, category_id, created_by_employee_id
)
VALUES
(N'Cho tôi xin một vé đi tuổi thơ', N'Sách thiếu nhi', 50000, 'VND', 200, 'active', 1, 1, 1),
(N'Harry Potter 1', N'Fantasy nổi tiếng', 120000, 'VND', 350, 'active', 2, 2, 1),
(N'Lập trình SQL cơ bản', N'Sách học SQL', 80000, 'VND', 250, 'active', 1, 3, 2),
(N'Harry Potter 2', N'Tập tiếp theo', 130000, 'VND', 360, 'active', 2, 2, 1);

-- =========================
-- BOOK COPY
-- =========================
INSERT INTO BookCopy (book_id, copy_code, status)
VALUES
(1, 'CP-001', 'available'),
(1, 'CP-002', 'borrowed'),
(2, 'CP-003', 'available'),
(3, 'CP-004', 'available');

-- =========================
-- CART & CART ITEM
-- =========================
INSERT INTO Cart (reader_id, status) VALUES
(1, 'active');

INSERT INTO Cart_Item (cart_id, book_id, quantity)
VALUES
(1, 2, 1),
(1, 3, 1);

-- =========================
-- ORDER & ORDER BOOK
-- =========================
INSERT INTO [Order] (reader_id, total_amount, currency, status)
VALUES
(1, 200000, 'VND', 'paid');

INSERT INTO Order_Book (order_id, book_id, price, quantity)
VALUES
(1, 2, 120000, 1),
(1, 3, 80000, 1);

-- =========================
-- PAYMENT
-- =========================
INSERT INTO Payment (order_id, amount, payment_method, payment_status, transaction_code)
VALUES
(1, 200000, 'VNPay', 'success', 'TXN001');

-- =========================
-- READER BOOK OWNERSHIP (EBOOK)
-- =========================
INSERT INTO Reader_Book_Ownership (reader_id, book_id, acquired_via, status)
VALUES
(1, 2, 'order', 'active'),
(1, 3, 'order', 'active');

-- =========================
-- BORROW REQUEST
-- =========================
INSERT INTO Borrow_Request (reader_id, status, note)
VALUES
(2, 'approved', N'Mượn sách Harry Potter');

INSERT INTO Borrow_Request_Item (request_id, book_id, quantity)
VALUES
(1, 2, 1);

-- =========================
-- BORROW & BORROW ITEM
-- =========================
INSERT INTO Borrow (reader_id, request_id, status, approved_by_employee_id)
VALUES
(2, 1, 'active', 2);

INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, status)
VALUES
(1, 2, DATEADD(day, 7, SYSUTCDATETIME()), 'borrowed');

-- =========================
-- BORROW EXTEND
-- =========================
INSERT INTO Borrow_Extend (
    borrow_item_id, old_due_date, requested_due_date,
    status, approved_by_employee_id
)
VALUES
(1, DATEADD(day, 7, SYSUTCDATETIME()), DATEADD(day, 14, SYSUTCDATETIME()),
 'approved', 2);

-- =========================
-- FINE TYPE & FINE
-- =========================
INSERT INTO Fine_Type (name, default_amount, per_day_rate)
VALUES
('late_return', 10000, 5000);

INSERT INTO Fine (reader_id, borrow_item_id, fine_type_id, amount, status)
VALUES
(2, 1, 1, 15000, 'unpaid');

-- =========================
-- READING HISTORY
-- =========================
INSERT INTO Reading_History (reader_id, book_id, last_read_position)
VALUES
(1, 2, 120),
(1, 3, 50);

-- =========================
-- BOOKMARK
-- =========================
INSERT INTO Bookmark (reader_id, book_id, page_number, note)
VALUES
(1, 2, 45, N'Đoạn hay');

-- =========================
-- REVIEW
-- =========================
INSERT INTO Review (reader_id, book_id, rating, comment)
VALUES
(1, 2, 5, N'Rất hay'),
(2, 2, 4, N'Truyện hấp dẫn');

-- =========================
-- NOTIFICATION
-- =========================
INSERT INTO Notification (reader_id, title, message, type)
VALUES
(1, N'Đơn hàng thành công', N'Bạn đã mua sách thành công', 'order'),
(2, N'Quá hạn mượn', N'Sách sắp đến hạn trả', 'borrow');

-- =========================
-- RESERVATION
-- =========================
INSERT INTO Reservation (reader_id, status, expires_at)
VALUES
(3, 'active', DATEADD(day, 3, SYSUTCDATETIME()));

INSERT INTO Reservation_Item (reservation_id, book_id, quantity)
VALUES
(1, 2, 1);

-- ==================================================
-- (2) Extra seed (from DigiLibExtraSeed.sql)
-- ==================================================
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

GO

-- ==================================================
-- (3) Additional data (from db2.sql, db3.sql) with safe execution
-- ==================================================
-- Global safety: force IDENTITY_INSERT OFF for all tables that have identity columns
-- (ignore errors if a table doesn't have identity or it's already OFF)
DECLARE @__sql NVARCHAR(MAX) = N'';
SELECT @__sql = @__sql + N'BEGIN TRY SET IDENTITY_INSERT '
    + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
    + N' OFF; END TRY BEGIN CATCH END CATCH;' + CHAR(10)
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id AND c.is_identity = 1;
EXEC sys.sp_executesql @__sql;
GO

SET NOCOUNT ON;
GO

-- ---------- Extracted from db2.sql ----------
    -- ---- db2 batch 1 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Author] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Author] ON 

INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (1, N''Nguyễn Nhật Ánh'', NULL)
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (2, N''J.K. Rowling'', NULL)
SET IDENTITY_INSERT [dbo].[Author] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Author] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Author] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 1) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 2 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Book] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1, N''Cho tôi xin một vé đi tuổi thơ'', N''Sách thiếu nhi'', NULL, N''/img/1.jpg'', NULL, CAST(50000.00 AS Decimal(10, 2)), N''VND'', 200, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 1, 1, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (2, N''Harry Potter 1'', N''Fantasy nổi tiếng'', NULL, N''/img/2.jpg'', NULL, CAST(120000.00 AS Decimal(10, 2)), N''VND'', 350, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 2, 2, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (3, N''Lập trình SQL cơ bản'', N''Sách học SQL'', NULL, N''/img/3.jpg'', NULL, CAST(80000.00 AS Decimal(10, 2)), N''VND'', 250, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 1, 3, 2, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (4, N''Harry Potter 2'', N''Tập tiếp theo'', NULL, N''/img/4.jpg'', NULL, CAST(130000.00 AS Decimal(10, 2)), N''VND'', 360, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 2, 2, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1002, N''Cho tôi xin một vé đi tuổi thơ'', N''Sách thiếu nhi'', NULL, N''/img/1.jpg'', NULL, CAST(50000.00 AS Decimal(10, 2)), N''VND'', 200, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 1, 1, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1003, N''Harry Potter 1'', N''Fantasy nổi tiếng'', NULL, N''/img/2.jpg'', NULL, CAST(120000.00 AS Decimal(10, 2)), N''VND'', 350, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 2, 2, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1004, N''Lập trình SQL cơ bản'', N''Sách học SQL'', NULL, N''/img/3.jpg'', NULL, CAST(80000.00 AS Decimal(10, 2)), N''VND'', 250, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 1, 3, 2, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1005, N''Harry Potter 2'', N''Tập tiếp theo'', NULL, N''/img/4.jpg'', NULL, CAST(130000.00 AS Decimal(10, 2)), N''VND'', 360, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 2, 2, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1006, N''Cho tôi xin một vé đi tuổi thơ'', N''Sách thiếu nhi'', NULL, N''/img/1.jpg'', NULL, CAST(50000.00 AS Decimal(10, 2)), N''VND'', 200, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 1, 1, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1007, N''Harry Potter 1'', N''Fantasy nổi tiếng'', NULL, N''/img/2.jpg'', NULL, CAST(120000.00 AS Decimal(10, 2)), N''VND'', 350, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 2, 2, 1, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1008, N''Lập trình SQL cơ bản'', N''Sách học SQL'', NULL, N''/img/3.jpg'', NULL, CAST(80000.00 AS Decimal(10, 2)), N''VND'', 250, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 1, 3, 2, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by_employee_id], [updated_by_employee_id]) VALUES (1009, N''Harry Potter 2'', N''Tập tiếp theo'', NULL, N''/img/4.jpg'', NULL, CAST(130000.00 AS Decimal(10, 2)), N''VND'', 360, NULL, N''active'', CAST(N''2026-01-23T06:30:57.2090746'' AS DateTime2), NULL, 2, 2, 1, NULL)
SET IDENTITY_INSERT [dbo].[Book] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Book] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Book] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 2) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 3 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[BookCopy] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[BookCopy] ON 

INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (1, 1, N''CP-001'', N''available'', CAST(N''2026-01-23T06:30:57.2110609'' AS DateTime2))
INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (2, 1, N''CP-002'', N''borrowed'', CAST(N''2026-01-23T06:30:57.2110609'' AS DateTime2))
INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (3, 2, N''CP-003'', N''available'', CAST(N''2026-01-23T06:30:57.2110609'' AS DateTime2))
INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (4, 3, N''CP-004'', N''available'', CAST(N''2026-01-23T06:30:57.2110609'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[BookCopy] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[BookCopy] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[BookCopy] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 3) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 4 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Bookmark] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Bookmark] ON 

INSERT [dbo].[Bookmark] ([bookmark_id], [reader_id], [book_id], [page_number], [note], [created_at]) VALUES (1, 1, 2, 45, N''Đoạn hay'', CAST(N''2026-01-23T06:30:57.2607375'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Bookmark] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Bookmark] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Bookmark] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 4) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 5 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Borrow] ON 

INSERT [dbo].[Borrow] ([borrow_id], [reader_id], [request_id], [borrow_date], [status], [created_at], [approved_by_employee_id]) VALUES (1, 2, 1, CAST(N''2026-01-23T06:30:57.2431903'' AS DateTime2), N''active'', CAST(N''2026-01-23T06:30:57.2431903'' AS DateTime2), 2)
SET IDENTITY_INSERT [dbo].[Borrow] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 5) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 6 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Extend] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Borrow_Extend] ON 

INSERT [dbo].[Borrow_Extend] ([extend_id], [borrow_item_id], [old_due_date], [requested_due_date], [approved_due_date], [status], [requested_at], [processed_at], [decision_note], [approved_by_employee_id]) VALUES (1, 1, CAST(N''2026-01-30T06:30:57.2461895'' AS DateTime2), CAST(N''2026-02-06T06:30:57.2461895'' AS DateTime2), NULL, N''approved'', CAST(N''2026-01-23T06:30:57.2461895'' AS DateTime2), NULL, NULL, 2)
SET IDENTITY_INSERT [dbo].[Borrow_Extend] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Extend] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Extend] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 6) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 7 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Item] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Borrow_Item] ON 

INSERT [dbo].[Borrow_Item] ([borrow_item_id], [borrow_id], [copy_id], [due_date], [returned_at], [status]) VALUES (1, 1, 2, CAST(N''2026-01-30T06:30:57.2451740'' AS DateTime2), NULL, N''borrowed'')
SET IDENTITY_INSERT [dbo].[Borrow_Item] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Item] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Item] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 7) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 8 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Request] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Borrow_Request] ON 

INSERT [dbo].[Borrow_Request] ([request_id], [reader_id], [status], [requested_at], [note], [processed_by_employee_id], [processed_at], [decision_note]) VALUES (1, 2, N''approved'', CAST(N''2026-01-23T06:30:57.2406444'' AS DateTime2), N''Mượn sách Harry Potter'', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Borrow_Request] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Request] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Request] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 8) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 9 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Request_Item] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Borrow_Request_Item] ON 

INSERT [dbo].[Borrow_Request_Item] ([request_item_id], [request_id], [book_id], [quantity]) VALUES (1, 1, 2, 1)
SET IDENTITY_INSERT [dbo].[Borrow_Request_Item] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Request_Item] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Borrow_Request_Item] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 9) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 10 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Cart] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Cart] ON 

INSERT [dbo].[Cart] ([cart_id], [reader_id], [status], [created_at], [updated_at]) VALUES (1, 1, N''active'', CAST(N''2026-01-23T06:30:57.2155411'' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[Cart] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Cart] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Cart] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 10) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 11 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Cart_Item] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Cart_Item] ON 

INSERT [dbo].[Cart_Item] ([cart_item_id], [cart_id], [book_id], [quantity], [added_at]) VALUES (1, 1, 2, 1, CAST(N''2026-01-23T06:30:57.2175428'' AS DateTime2))
INSERT [dbo].[Cart_Item] ([cart_item_id], [cart_id], [book_id], [quantity], [added_at]) VALUES (2, 1, 3, 1, CAST(N''2026-01-23T06:30:57.2175428'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Cart_Item] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Cart_Item] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Cart_Item] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 11) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 12 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Category] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (1, N''Thiếu nhi'', NULL)
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (2, N''Fantasy'', NULL)
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (3, N''Công nghệ'', NULL)
SET IDENTITY_INSERT [dbo].[Category] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Category] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Category] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 12) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 13 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Employee] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (1, N''Admin System'', N''admin@lib.com'', N''hash_admin'', N''active'', CAST(N''2026-01-23T06:30:57.1784127'' AS DateTime2), 1)
INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (2, N''Librarian A'', N''librarian@lib.com'', N''hash_librarian'', N''active'', CAST(N''2026-01-23T06:30:57.1784127'' AS DateTime2), 2)
INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (3, N''Nhat Ngoc'', N''nhatngocvip@gmail.com'', N''$2a$10$CqfyZYFK2PXQeHb1qzpV8OtgSRXbZLcY3mHgUDqbRQYHYVZFbCbSW'', N''active'', CAST(N''2026-01-24T04:56:29.8759309'' AS DateTime2), 1)
SET IDENTITY_INSERT [dbo].[Employee] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Employee] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Employee] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 13) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 14 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Fine] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Fine] ON 

INSERT [dbo].[Fine] ([fine_id], [reader_id], [borrow_item_id], [fine_type_id], [amount], [reason], [status], [created_at], [paid_at], [handled_by_employee_id]) VALUES (1, 2, 1, 1, CAST(15000.00 AS Decimal(10, 2)), NULL, N''unpaid'', CAST(N''2026-01-23T06:30:57.2587376'' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Fine] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Fine] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Fine] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 14) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 15 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Fine_Type] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Fine_Type] ON 

INSERT [dbo].[Fine_Type] ([fine_type_id], [name], [description], [default_amount], [per_day_rate]) VALUES (1, N''late_return'', NULL, CAST(10000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[Fine_Type] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Fine_Type] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Fine_Type] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 15) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 16 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Notification] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Notification] ON 

INSERT [dbo].[Notification] ([notification_id], [reader_id], [title], [message], [type], [is_read], [created_at]) VALUES (1, 1, N''Đơn hàng thành công'', N''Bạn đã mua sách thành công'', N''order'', 0, CAST(N''2026-01-23T06:30:57.2638848'' AS DateTime2))
INSERT [dbo].[Notification] ([notification_id], [reader_id], [title], [message], [type], [is_read], [created_at]) VALUES (2, 2, N''Quá hạn mượn'', N''Sách sắp đến hạn trả'', N''borrow'', 0, CAST(N''2026-01-23T06:30:57.2638848'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Notification] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Notification] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Notification] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 16) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 17 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Order] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([order_id], [reader_id], [total_amount], [currency], [status], [created_at]) VALUES (1, 1, CAST(200000.00 AS Decimal(10, 2)), N''VND'', N''paid'', CAST(N''2026-01-23T06:30:57.2185410'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Order] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Order] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Order] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 17) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 18 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Order_Book] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Order_Book] ON 

INSERT [dbo].[Order_Book] ([order_book_id], [order_id], [book_id], [price], [quantity]) VALUES (1, 1, 2, CAST(120000.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Order_Book] ([order_book_id], [order_id], [book_id], [price], [quantity]) VALUES (2, 1, 3, CAST(80000.00 AS Decimal(10, 2)), 1)
SET IDENTITY_INSERT [dbo].[Order_Book] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Order_Book] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Order_Book] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 18) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 19 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Payment] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Payment] ON 

INSERT [dbo].[Payment] ([payment_id], [order_id], [amount], [payment_method], [payment_status], [transaction_code], [paid_at], [created_at]) VALUES (1, 1, CAST(200000.00 AS Decimal(10, 2)), N''VNPay'', N''success'', N''TXN001'', NULL, CAST(N''2026-01-23T06:30:57.2251008'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Payment] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Payment] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Payment] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 19) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 20 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reader] ON 

INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (1, N''Nguyen Van A'', N''a@mail.com'', N''hash_a'', N''090000001'', NULL, N''active'', CAST(N''2026-01-23T06:30:57.1819661'' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (2, N''Tran Thi B'', N''b@mail.com'', N''hash_b'', N''090000002'', NULL, N''active'', CAST(N''2026-01-23T06:30:57.1819661'' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (3, N''Le Van C'', N''c@mail.com'', N''hash_c'', N''090000003'', NULL, N''active'', CAST(N''2026-01-23T06:30:57.1819661'' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (4, N''Google User'', N''user@gmail.com'', N''$2a$10$z9uEGR2xbKlT37OjyWmhcOLwrerQ80BlbxoLk17i7ZBKwlsDt8/.W'', NULL, NULL, N''active'', CAST(N''2026-01-23T14:31:39.9708432'' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (5, N''Nhat Ngoc'', N''nhatngocvip@gmail.com'', N''$2a$10$CqfyZYFK2PXQeHb1qzpV8OtgSRXbZLcY3mHgUDqbRQYHYVZFbCbSW'', NULL, NULL, N''active'', CAST(N''2026-01-23T14:46:16.4224450'' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (6, N''Nhat Ngoc'', N''nhatngocvip123@gmail.com'', N''$2a$10$7GyLuDHz0wX8Po5hTpzRAudqDXqePLjcbRDUwBlBSLPN3iHVgZIfG'', NULL, NULL, N''active'', CAST(N''2026-01-23T14:57:00.0407915'' AS DateTime2), 4)
SET IDENTITY_INSERT [dbo].[Reader] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 20) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 21 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader_Account] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reader_Account] ON 

INSERT [dbo].[Reader_Account] ([account_id], [reader_id], [provider], [provider_user_id], [created_at]) VALUES (1, 1, N''local'', NULL, CAST(N''2026-01-23T06:30:57.1859808'' AS DateTime2))
INSERT [dbo].[Reader_Account] ([account_id], [reader_id], [provider], [provider_user_id], [created_at]) VALUES (2, 2, N''google'', N''google_123'', CAST(N''2026-01-23T06:30:57.1859808'' AS DateTime2))
INSERT [dbo].[Reader_Account] ([account_id], [reader_id], [provider], [provider_user_id], [created_at]) VALUES (3, 3, N''facebook'', N''fb_456'', CAST(N''2026-01-23T06:30:57.1859808'' AS DateTime2))
INSERT [dbo].[Reader_Account] ([account_id], [reader_id], [provider], [provider_user_id], [created_at]) VALUES (4, 4, N''google'', N''google_123456'', CAST(N''2026-01-23T14:31:39.9864725'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Reader_Account] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader_Account] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader_Account] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 21) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 22 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader_Book_Ownership] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reader_Book_Ownership] ON 

INSERT [dbo].[Reader_Book_Ownership] ([ownership_id], [reader_id], [book_id], [acquired_at], [acquired_via], [status]) VALUES (1, 1, 2, CAST(N''2026-01-23T06:30:57.2311003'' AS DateTime2), N''order'', N''active'')
INSERT [dbo].[Reader_Book_Ownership] ([ownership_id], [reader_id], [book_id], [acquired_at], [acquired_via], [status]) VALUES (2, 1, 3, CAST(N''2026-01-23T06:30:57.2311003'' AS DateTime2), N''order'', N''active'')
SET IDENTITY_INSERT [dbo].[Reader_Book_Ownership] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader_Book_Ownership] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader_Book_Ownership] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 22) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 23 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reading_History] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reading_History] ON 

INSERT [dbo].[Reading_History] ([history_id], [reader_id], [book_id], [last_read_position], [last_read_at]) VALUES (1, 1, 2, 120, NULL)
INSERT [dbo].[Reading_History] ([history_id], [reader_id], [book_id], [last_read_position], [last_read_at]) VALUES (2, 1, 3, 50, NULL)
SET IDENTITY_INSERT [dbo].[Reading_History] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reading_History] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reading_History] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 23) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 24 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reservation] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reservation] ON 

INSERT [dbo].[Reservation] ([reservation_id], [reader_id], [status], [created_at], [expires_at], [fulfilled_at], [note]) VALUES (1, 3, N''active'', CAST(N''2026-01-23T06:30:57.2688833'' AS DateTime2), CAST(N''2026-01-26T06:30:57.2688833'' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Reservation] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reservation] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reservation] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 24) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 25 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reservation_Item] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reservation_Item] ON 

INSERT [dbo].[Reservation_Item] ([reservation_item_id], [reservation_id], [book_id], [quantity]) VALUES (1, 1, 2, 1)
SET IDENTITY_INSERT [dbo].[Reservation_Item] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reservation_Item] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reservation_Item] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 25) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 26 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Review] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Review] ON 

INSERT [dbo].[Review] ([review_id], [reader_id], [book_id], [rating], [comment], [created_at], [updated_at]) VALUES (1, 1, 2, 5, N''Rất hay'', CAST(N''2026-01-23T06:30:57.2618732'' AS DateTime2), NULL)
INSERT [dbo].[Review] ([review_id], [reader_id], [book_id], [rating], [comment], [created_at], [updated_at]) VALUES (2, 2, 2, 4, N''Truyện hấp dẫn'', CAST(N''2026-01-23T06:30:57.2618732'' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[Review] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Review] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Review] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 26) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db2 batch 27 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Role] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (1, N''ADMIN'', N''Administrator'')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (2, N''LIBRARIAN'', N''Librarian'')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (3, N''SELLER'', N''Seller'')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (4, N''USER'', N''Normal user'')
SET IDENTITY_INSERT [dbo].[Role] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Role] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Role] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db2 batch 27) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---------- Extracted from db3.sql ----------
    -- ---- db3 batch 1 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Author] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Author] ON 

INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (1, N''Nguyễn Nhật Ánh'', N''Nguyễn Nhật Ánh (sinh ngày 7 tháng 5 năm 1955)[1] là một nam nhà văn người Việt Nam. Được xem là một trong những nhà văn hiện đại xuất sắc nhất Việt Nam hiện nay, ông được biết đến qua nhiều tác phẩm văn học về đề tài tuổi trẻ. Nhiều tác phẩm của ông được nhiều thế hệ độc giả yêu mến và giới chuyên môn đánh giá cao, được chuyển thể thành phim và kịch nói.'')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (2, N''J.K. Rowling '', N''Joanne Rowling CH, OBE, FRCPE, FRSL (/ˈroʊlɪŋ/ ROH-ling;[1] sinh ngày 31 tháng 7 năm 1965[2]), thường được biết đến với bút danh J. K. Rowling,[3] là một nhà văn, nhà từ thiện, nhà sản xuất phim và truyền hình, nhà biên kịch người Anh. Bà nổi tiếng là tác giả của bộ truyện giả tưởng Harry Potter từng đoạt nhiều giải thưởng và bán được hơn 500 triệu bản,[4][5] trở thành bộ sách bán chạy nhất trong lịch sử.[6] Bộ sách đã được chuyển thể thành một loạt phim ăn khách mà chính bà đã phê duyệt kịch bản[7] và cũng là nhà sản xuất của hai phần cuối.[8] Bà cũng viết tiểu thuyết trinh thám hình sự dưới bút danh Robert Galbraith.'')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (3, N''Dale Carnegie'', N''Dale Breckenridge Carnegie (trước kia là Carnagey cho tới năm 1922 và có thể một thời gian muộn hơn) (24 tháng 11 năm 1888 – 1 tháng 11 năm 1955) là một nhà văn và nhà thuyết trình Mỹ và là người phát triển các lớp tự giáo dục, nghệ thuật bán hàng, huấn luyện đoàn thể, nói trước công chúng và các kỹ năng giao tiếp giữa mọi người. Ra đời trong cảnh nghèo đói tại một trang trại ở Missouri, ông là tác giả cuốn Đắc Nhân Tâm, được xuất bản lần đầu năm 1936, một cuốn sách hàng bán chạy nhất và được biết đến nhiều nhất cho đến tận ngày nay, nội dung nói về cách ứng xử, cư xử trong cuộc sống. Ông cũng viết một cuốn tiểu sử Abraham Lincoln, với tựa đề Lincoln con người chưa biết, và nhiều cuốn sách khác.'')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (4, N''Leo Tolstoy'', N''Bá tước Lev Nikolayevich Tolstoy (tiếng Nga: Лев Николаевич Толстой; phiên âm: Lép Ni-cô-lai-ê-vích Tôn-xtôi, 28 tháng 8 năm 1828 – 20 tháng 11 năm 1910),[1] là một tiểu thuyết gia người Nga, nhà triết học, người theo chủ nghĩa hoà bình, nhà cải cách giáo dục, người ăn chay, người theo chủ nghĩa vô chính phủ, tín hữu Cơ Đốc giáo, nhà tư tưởng đạo đức và là một thành viên có ảnh hưởng của gia đình Tolstoy.'')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (5, N''Antoine de Saint-Exupéry'', N''Antoine Marie Jean-Baptiste Roger de Saint-Exupéry, thường được biết tới với tên Antoine de Saint-Exupéry hay gọi tắt là Saint-Ex (sinh ngày 29 tháng 6 năm 1900 - mất tích ngày 31 tháng 7 năm 1944) là một nhà văn và phi công Pháp nổi tiếng. Saint-Exupéry được biết tới nhiều nhất với tác phẩm văn học Hoàng tử bé (Le Petit Prince).'')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (7, N''Phùng Quán'', N''Phùng Quán (1932 – 1995), sinh ra tại Thừa Thiên – Huế, Ông là một nhà văn, nhà thơ Việt Nam. Ông bắt đầu viết trong khoảng thời gian của cuộc chiến tranh Đông Dương.'')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (8, N''Vũ Trọng Phụng'', N''Vũ Trọng Phụng là một nhà văn, nhà báo, một cây bút phóng sự với nhiều bài tiêu biểu. '')
INSERT [dbo].[Author] ([author_id], [author_name], [bio]) VALUES (9, N''Vũ Hữu Tiệp'', N'''')
SET IDENTITY_INSERT [dbo].[Author] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Author] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Author] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 1) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db3 batch 2 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Book] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (1, N''Hoàng tử bé'', N'''', N''Hoàng Tử Bé là một cuốn sách kỳ diệu và đáng yêu, bởi chỉ một câu chuyện kể, với mỗi lứa tuổi khác nhau, tác phẩm mang đến những bài học khác nhau. Dù mang dáng dấp của cuốn sách cho thiếu nhi nhưng khi đọc “Hoàng Tử Bé”, có người rút ra được bài học về nghệ thuật sống, có người ngẫm ra các triết lý kinh doanh, lại có người suy nghĩ về sự vô thường của vạn vật, về bản chất của con người, những mối sa ngã và các tính xấu. '', N''/img/book/hoang_tu_be.jpg'', N'''', CAST(150000.00 AS Decimal(10, 2)), N''VND'', NULL, NULL, N''Active'', CAST(N''2026-01-29T04:40:43.1416174'' AS DateTime2), CAST(N''2026-01-31T00:22:21.6933333'' AS DateTime2), 1, 1, NULL, 10)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (3, N''Bảy Bước Tới Mùa Hè'', N''Bảy bước tới mùa hè là tác phẩm mới nhất của Nguyễn Nhật Ánh, được nhà văn đề tặng “Những năm ấu thơ”, như một món quà dành tặng các bạn đọc thân thiết của mình nhân dịp đầu năm mới.'', N''Câu chuyện về một mùa hè ngọt ngào, những trò chơi nghịch ngợm và bâng khuâng tình cảm tuổi mới lớn. Chỉ vậy thôi nhưng chứng tỏ tác giả đúng là nhà kể chuyện hóm hỉnh, khiến độc giả cuốn hút từ trang đầu đến trang cuối cùng. Chúng ta sẽ bắt gặp giọng văn giản dị, trong trẻo của nhà văn Nguyễn Nhật Ánh và một kết thúc có hậu đầy thuyết phục ở cuối truyện. Câu chuyện về tuổi học trò đầy ắp những kỷ niệm thơ bé ngọt ngào với tình thầy trò, bè bạn, tình xóm giềng, họ hàng qua cách nhìn đời nhẹ nhàng, rộng lượng.'', N''/img/book/bay_buoc_toi_mua_he.jpg'', N'''', CAST(100000.00 AS Decimal(10, 2)), N''VND'', 0, 0, N''Active'', CAST(N''2026-01-31T00:25:49.1533333'' AS DateTime2), NULL, 1, 2, 10, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (4, N''Học Cách Im Lặng'', N''Hãy học cách im lặng
Trước câu chuyện thị phi
Cuộc đời này ngắn lắm
Đâu đáng để sân si
'', N''Hãy học cách im lặng
Trước câu chuyện thị phi
Cuộc đời này ngắn lắm
Đâu đáng để sân si


Hãy học cách im lặng
Đừng đắn đo thiệt hơn
Giữ tâm mình tự tại
Muộn phiền sẽ chẳng còn


Hãy học cách im lặng
Trước bao điều dèm pha
Bận lòng chi những kẻ
Dựng câu chuyện làm quà


Hãy học cách im lặng
Trước miệng lưỡi thế gian
Dù dòng đời vạn biến
Chỉ cần lòng bình an

Hãy học cách im lặng
Học cách để bỏ buông
Để sau bao sóng gió
Chỉ còn lại yêu thương.'', N''/img/book/hoc_cach_im_lang.jpg'', N'''', CAST(80000.00 AS Decimal(10, 2)), N''VND'', 0, 0, N''Active'', CAST(N''2026-01-31T00:29:12.2366667'' AS DateTime2), NULL, 1, 3, 10, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (5, N''Đấm Phát Chết Luôn'', N''Manga thể loại siêu anh hùng với đặc trưng phồng tôm đấm phát chết luôn… Lol!!! Nhân vật chính trong Onepunch-man là Saitama, một con người mà nhìn đâu cũng thấy “tầm thường”, từ khuôn mặt vô hồn, cái đầu trọc lóc, cho tới thể hình long tong.'', N''Tuy nhiên, con người nhìn thì tầm thường này lại chuyên giải quyết những vấn đề hết sức bất thường. Anh thực chất chính là một siêu anh hùng luôn tìm kiếm cho mình một đối thủ mạnh. Vấn đề là, cứ mỗi lần bắt gặp một đối thủ tiềm năng, thì đối thủ nào cũng như đối thủ nào, chỉ ăn một đấm của anh là… chết luôn. Liệu rằng Onepunch-Man Saitaman có thể tìm được cho mình một kẻ ác dữ dằn đủ sức đấu với anh? Hãy theo bước Saitama trên con đường một đấm tìm đối cực kỳ hài hước của anh!!'', N''/img/book/dam_phat_chet_luon.jpg'', N'''', CAST(50000.00 AS Decimal(10, 2)), N''VND'', 0, 0, N''Active'', CAST(N''2026-01-31T00:30:45.5766667'' AS DateTime2), NULL, 1, 2, 10, NULL)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (6, N''Tuổi Thơ Dữ Dội'', N''Năm 1988, cuốn tiểu thuyết Tuổi thơ dữ dội của ông được xuất bản và nhận giải thưởng văn học Thiếu nhi của Hội nhà văn Việt Nam vào hai năm sau đó.'', N''Ngoài thể loại văn xuôi, ông còn viết những bài thơ thể hiện nỗi buồn của cuộc đời, một tâm hồn yêu nước, thương nòi, ngay thẳng và chứng kiến nhiều bất công dối trá:

“Tôi muốn đúc thơ thành đạn
Bắn vào tim những kẻ làm càn
Những người tiêu máu của dân
Như tiêu giấy bạc giả!
Tôi đã đến dự những phiên toà
Họp suốt ngày luận bàn xử tội
Những con chuột mặc quần áo bộ đội
Đục cơm khoét áo chúng ta
Ăn cắp máu dân đổi chác đồng hồ
Kim phút kim giờ lép gầy như bụng đói”'', N''/img/book/tuoi_tho_du_doi.jpg'', N'''', CAST(100000.00 AS Decimal(10, 2)), N''VND'', 0, 0, N''Active'', CAST(N''2026-01-31T00:36:12.3966667'' AS DateTime2), CAST(N''2026-01-31T00:39:42.0466667'' AS DateTime2), 7, 12, 10, 10)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (7, N''Dứt Tình'', N''“Dứt tình” là cuốn tiểu thuyết mang tư tưởng định mệnh siêu hình.'', N''Vũ Trọng Phụng là một nhà văn, nhà báo, một cây bút phóng sự với nhiều bài tiêu biểu. Năm 1930, ông có bài đăng trên Ngọ báo, nhưng lúc này tên tuổi ông chưa thực sự được chú ý trong giới văn học Việt Nam. Mãi đến 1931, vở kịnh Không một tiếng vang ra đời, thì mới bắt đầu gây được sự chú ý của bạn đọc. Năm 1934, Vũ Trọng Phụng có tiểu thuyết đầu tay “Dứt tình” (còn có tên khác là Bởi không duyên kiếp) đăng trên tờ Hải Phòng tuần báo. Với tiểu thuyết này, Vũ Trọng Phụng được khen là “ngòi bút tả chân thực đã khéo léo”.“Dứt tình” là cuốn tiểu thuyết mang tư tưởng định mệnh siêu hình.'', N''/img/book/dut_tinh.jpg'', N'''', CAST(60000.00 AS Decimal(10, 2)), N''VND'', 0, 0, N''Active'', CAST(N''2026-01-31T00:38:56.8000000'' AS DateTime2), CAST(N''2026-01-31T00:39:35.1633333'' AS DateTime2), 8, 12, 10, 10)
INSERT [dbo].[Book] ([book_id], [title], [summary], [description], [cover_url], [content_path], [price], [currency], [total_pages], [preview_pages], [status], [created_at], [updated_at], [author_id], [category_id], [created_by], [updated_by]) VALUES (8, N''Machine Learning Cơ Bản'', N''Những năm gần đây, AI – Artificial Intelligence (Trí Tuệ Nhân Tạo), và cụ thể hơn là Machine Learning (Học Máy hoặc Máy Học) nổi lên như một bằng chứng của cuộc cách mạng công nghiệp lần thứ tư (1 – động cơ hơi nước, 2 – năng lượng điện, 3 – công nghệ thông tin). '', N''Những năm gần đây, AI – Artificial Intelligence (Trí Tuệ Nhân Tạo), và cụ thể hơn là Machine Learning (Học Máy hoặc Máy Học) nổi lên như một bằng chứng của cuộc cách mạng công nghiệp lần thứ tư (1 – động cơ hơi nước, 2 – năng lượng điện, 3 – công nghệ thông tin). Trí Tuệ Nhân Tạo đang len lỏi vào mọi lĩnh vực trong đời sống mà có thể chúng ta không nhận ra. Xe tự hành của Google và Tesla, hệ thống tự tag khuôn mặt trong ảnh của Facebook, trợ lý ảo Siri của Apple, hệ thống gợi ý sản phẩm của Amazon, hệ thống gợi ý phim của Netflix, máy chơi cờ vây AlphaGo của Google DeepMind, …, chỉ là một vài trong vô vàn những ứng dụng của AI/Machine Learning.

Machine Learning là một tập con của AI. Theo định nghĩa của Wikipedia, Machine learning is the subfield of computer science that “gives computers the ability to learn without being explicitly programmed”. Nói đơn giản, Machine Learning là một lĩnh vực nhỏ của Khoa Học Máy Tính, nó có khả năng tự học hỏi dựa trên dữ liệu đưa vào mà không cần phải được lập trình cụ thể. Bạn Nguyễn Xuân Khánh tại đại học Maryland đang viết một cuốn sách về Machine Learning bằng tiếng Việt khá thú vị, các bạn có thể tham khảo bài Machine Learning là gì?.'', N''/img/book/machine_learning_co_ban.jpg'', N'''', CAST(200000.00 AS Decimal(10, 2)), N''VND'', 0, 0, N''Active'', CAST(N''2026-01-31T00:43:06.7000000'' AS DateTime2), CAST(N''2026-01-31T00:43:30.3600000'' AS DateTime2), 9, 13, 10, 10)
SET IDENTITY_INSERT [dbo].[Book] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Book] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Book] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 2) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db3 batch 3 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[BookCopy] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[BookCopy] ON 

INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (1, 1, N''CP01'', N''BORROWED'', CAST(N''2026-01-30T17:48:58.6460000'' AS DateTime2))
INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (2, 1, N''CP02'', N''INACTIVE'', CAST(N''2026-01-30T17:53:19.9980000'' AS DateTime2))
INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (3, 6, N''CP03'', N''AVAILABLE'', CAST(N''2026-02-02T11:33:31.7850000'' AS DateTime2))
INSERT [dbo].[BookCopy] ([copy_id], [book_id], [copy_code], [status], [created_at]) VALUES (4, 5, N''CP04'', N''AVAILABLE'', CAST(N''2026-02-02T11:40:07.5230000'' AS DateTime2))
SET IDENTITY_INSERT [dbo].[BookCopy] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[BookCopy] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[BookCopy] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 3) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db3 batch 4 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Category] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (1, N''Tiểu thuyết'', N''Tác phẩm dài, cốt truyện sâu, phản ánh đời sống, tâm lý con người.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (2, N''Truyện ngắn'', N''Câu chuyện ngắn gọn, súc tích, thường tập trung vào một khoảnh khắc hay ý nghĩa.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (3, N''Thơ'', N''Sử dụng ngôn từ giàu hình ảnh, cảm xúc, nhịp điệu.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (4, N''Sách thiếu nhi'', N''Truyện cổ tích, truyện tranh, sách tranh minh họa.

Nội dung nhẹ nhàng, giáo dục đạo đức, kích thích trí tưởng tượng.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (5, N''Khoa học tự nhiên'', N''Toán, Lý, Hóa, Sinh, Vũ trụ…'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (6, N''Khoa học xã hội'', N''Xã hội học, tâm lý học, nhân học…'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (7, N''Lịch sử'', N''Ghi chép, phân tích các sự kiện, nhân vật, giai đoạn lịch sử.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (8, N''Sách tham khảo – Tra cứu'', N''Từ điển, bách khoa toàn thư, sách chuyên ngành.

Dùng để tra cứu nhanh và học tập chuyên sâu.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (9, N''Du ký – Văn hóa – Nghệ thuật'', N''Ghi chép trải nghiệm du lịch, khám phá văn hóa các vùng miền.

Sách về hội họa, âm nhạc, điện ảnh.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (10, N''Ngoại ngữ'', N''Sách học tiếng Anh, Pháp, Nhật, Hàn…

Bao gồm ngữ pháp, từ vựng, luyện kỹ năng.'')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (12, N''Văn Học Việt Nam'', N'''')
INSERT [dbo].[Category] ([category_id], [category_name], [description]) VALUES (13, N''Công Nghệ Thông Tin'', N'''')
SET IDENTITY_INSERT [dbo].[Category] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Category] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Category] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 4) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db3 batch 5 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Employee] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (7, N''Ngoc Nhat'', N''nhatngoc@gmail.com'', N''$2a$10$Bn/qVrdJcIH6Uy0ecbQBjOxR.93fGCbiglc2Q262Q5QE2.tHulH/u'', N''active'', CAST(N''2026-01-30T09:23:51.5920388'' AS DateTime2), 2)
INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (10, N''Nhat Ngoc'', N''nhatngocvip@gmail.com'', N''$2a$10$BAHvCSkLlT8hXC3.da/lQeY4WbD.FCBViehDxbhxm9e7oFRyCPQF2'', N''active'', CAST(N''2026-01-30T09:30:11.1419766'' AS DateTime2), 1)
SET IDENTITY_INSERT [dbo].[Employee] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Employee] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Employee] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 5) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db3 batch 6 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Reader] ON 

INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (8, N''Nhat Ngoc'', N''nhatngocvip@gmail.com'', N''$2a$10$BAHvCSkLlT8hXC3.da/lQeY4WbD.FCBViehDxbhxm9e7oFRyCPQF2'', N''0973108807'', N'''', N''active'', CAST(N''2026-01-29T04:31:27.9561846'' AS DateTime2), 2)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (9, N''Ngoc Nhat'', N''nhatngoc@gmail.com'', N''$2a$10$Bn/qVrdJcIH6Uy0ecbQBjOxR.93fGCbiglc2Q262Q5QE2.tHulH/u'', N''0333740740'', N'''', N''active'', CAST(N''2026-01-29T04:36:00.1272705'' AS DateTime2), 2)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (11, N''Phương Thảo'', N''thao@gmail.com'', N''$2a$10$.KQFNaQFeSvu1JY2kCrp8OeCTPp6C2RctZBDA9tDCUQTRVMYIIt42'', N''0987654321'', NULL, N''active'', CAST(N''2026-01-30T08:13:59.5484946'' AS DateTime2), 3)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (13, N''Tường Hân'', N''han@gmail.com'', N''$2a$10$sKnWylNRayIPY4Vps.BwUOxrw8.bRgA/yTRImEQZiRneocPx03iOG'', N''0987654320'', NULL, N''active'', CAST(N''2026-01-30T16:19:42.9323024'' AS DateTime2), 3)
SET IDENTITY_INSERT [dbo].[Reader] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Reader] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 6) due to error: ' + ERROR_MESSAGE();
END CATCH
GO

-- ---- db3 batch 7 ----
BEGIN TRY
-- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
BEGIN TRY SET IDENTITY_INSERT [dbo].[Role] OFF; END TRY BEGIN CATCH END CATCH;    EXEC sys.sp_executesql N'SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (1, N''ADMIN'', N''Administrator'')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (2, N''LIBRARIAN'', N''Librarian'')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (3, N''READER'', N''Normal user'')
SET IDENTITY_INSERT [dbo].[Role] OFF';

-- Cleanup: ensure IDENTITY_INSERT is OFF even if the batch forgot to turn it off
BEGIN TRY SET IDENTITY_INSERT [dbo].[Role] OFF; END TRY BEGIN CATCH END CATCH;
END TRY
BEGIN CATCH
    -- Ensure IDENTITY_INSERT is OFF (SQL Server allows only one table at a time)
    BEGIN TRY SET IDENTITY_INSERT [dbo].[Role] OFF; END TRY BEGIN CATCH END CATCH;    PRINT 'Skipped batch (db3 batch 7) due to error: ' + ERROR_MESSAGE();
END CATCH

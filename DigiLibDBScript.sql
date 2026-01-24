
-- =====================================
-- DROP DATABASE IF EXISTS
-- =====================================
IF EXISTS (
    SELECT 1 
    FROM sys.databases 
    WHERE name = N'DigitalLibraryDB'
)
BEGIN
    ALTER DATABASE DigitalLibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DigitalLibraryDB;
END
GO
-- CREATE DATABSAE --

CREATE DATABASE DigitalLibraryDB;
GO
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


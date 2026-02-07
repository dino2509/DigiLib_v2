USE [DigitalLibraryDB];
GO

DECLARE @adminHash NVARCHAR(255) = N'$2a$10$zzTsiv3hkVe9rcnPTK6yWevuBRM2Gc7zl5vNwEryy.GRGbgtFzImG';
DECLARE @libHash   NVARCHAR(255) = N'$2a$10$xzdVMUgAGxT///evQKLAx.2PMswVUVbjjn4Kc2FRzgaYTyeL1DbtO';

-- ADMIN
IF NOT EXISTS (SELECT 1 FROM dbo.Employee WHERE email = 'admin_test@digilib.local')
BEGIN
    INSERT INTO dbo.Employee (full_name, email, password_hash, status, created_at, role_id)
    VALUES (N'Admin Test', 'admin_test@digilib.local', @adminHash, N'active', SYSUTCDATETIME(), 1);
END
ELSE
BEGIN
    UPDATE dbo.Employee
    SET password_hash = @adminHash, status = N'active', role_id = 1, full_name = N'Admin Test'
    WHERE email = 'admin_test@digilib.local';
END

-- LIBRARIAN
IF NOT EXISTS (SELECT 1 FROM dbo.Employee WHERE email = 'librarian_test@digilib.local')
BEGIN
    INSERT INTO dbo.Employee (full_name, email, password_hash, status, created_at, role_id)
    VALUES (N'Librarian Test', 'librarian_test@digilib.local', @libHash, N'active', SYSUTCDATETIME(), 2);
END
ELSE
BEGIN
    UPDATE dbo.Employee
    SET password_hash = @libHash, status = N'active', role_id = 2, full_name = N'Librarian Test'
    WHERE email = 'librarian_test@digilib.local';
END

SELECT employee_id, full_name, email, role_id, status
FROM dbo.Employee
WHERE email IN ('admin_test@digilib.local', 'librarian_test@digilib.local');
GO

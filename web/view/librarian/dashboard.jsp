<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Librarian Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">Bảng Điều Khiển Thủ Thư</h2>

    <div class="row">
        <div class="col-md-4">
            <div class="card text-white bg-primary mb-3 shadow-sm">
                <div class="card-header">Quản Lý Mượn Trả</div>
                <div class="card-body">
                    <h5 class="card-title">Sách Đang Mượn</h5>
                    <p class="card-text display-4 fw-bold">
                        ${totalActive}
                    </p>
                    <p class="card-text"><small>Bao gồm cả sách quá hạn</small></p>
                </div>
                <div class="card-footer bg-transparent border-top-0">
                    <a href="borrows" class="btn btn-light text-primary w-100 fw-bold">
                        Xem chi tiết &rarr;
                    </a>
                </div>
            </div>
        </div>

        
    </div>
</div>

</body>
</html>

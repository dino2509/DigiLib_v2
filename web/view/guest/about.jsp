<%@ page contentType="text/html; charset=UTF-8" %>

<style>

    .about-container{
        max-width:1100px;
        margin:auto;
        padding:40px 20px;
    }

    /* HERO */

    .about-hero{
        text-align:center;
        margin-bottom:40px;
    }

    .about-hero h1{
        font-size:36px;
        color:#f97316;
        margin-bottom:10px;
    }

    .about-hero p{
        font-size:18px;
        color:#555;
    }

    /* SECTION */

    .about-section{
        margin-bottom:40px;
    }

    .about-section h2{
        margin-bottom:15px;
        color:#1f2937;
    }

    .about-section p{
        line-height:1.7;
        color:#4b5563;
    }

    /* SERVICE */

    .service-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
        gap:20px;
        margin-top:20px;
    }

    .service-card{
        background:white;
        padding:20px;
        border-radius:10px;
        border:1px solid #e5e7eb;
        text-align:center;
    }

    .service-card h3{
        margin-top:10px;
        color:#f97316;
    }

    /* STATS */

    .stats{
        display:grid;
        grid-template-columns:repeat(3,1fr);
        gap:20px;
        margin-top:30px;
    }

    .stat-box{
        background:#fff7ed;
        padding:25px;
        border-radius:10px;
        text-align:center;
    }

    .stat-box h2{
        color:#f97316;
        margin-bottom:5px;
    }

    .contact{
        background:#f9fafb;
        padding:25px;
        border-radius:10px;
    }

</style>



<div class="about-container">

    <!-- HERO -->

    <div class="about-hero">

        <h1>📚 Digital Library</h1>

        <p>
            Thư viện số cung cấp nguồn tài liệu học tập và nghiên cứu
            cho sinh viên, giảng viên và cộng đồng.
        </p>

    </div>


    <!-- GIỚI THIỆU -->

    <div class="about-section">

        <h2>Giới thiệu thư viện</h2>

        <p>
            Digital Library là hệ thống thư viện trực tuyến giúp người dùng
            tìm kiếm, đọc và truy cập tài liệu học thuật một cách nhanh chóng.
            Hệ thống cung cấp hàng nghìn đầu sách và tài liệu điện tử
            thuộc nhiều lĩnh vực khác nhau như công nghệ thông tin,
            kinh tế, khoa học, giáo dục và nhiều ngành học khác.
        </p>

        <p>
            Với giao diện thân thiện và công cụ tìm kiếm mạnh mẽ,
            người dùng có thể dễ dàng khám phá các tài liệu cần thiết
            cho việc học tập và nghiên cứu.
        </p>

    </div>


    <!-- MỤC TIÊU -->

    <div class="about-section">

        <h2>Mục tiêu</h2>

        <p>
            • Xây dựng nguồn tài nguyên tri thức số phong phú. <br>
            • Hỗ trợ sinh viên và giảng viên trong học tập và nghiên cứu. <br>
            • Cung cấp hệ thống truy cập tài liệu nhanh chóng và tiện lợi. <br>
            • Thúc đẩy văn hóa đọc trong cộng đồng.
        </p>

    </div>


    <!-- DỊCH VỤ -->

    <div class="about-section">

        <h2>Dịch vụ thư viện</h2>

        <div class="service-grid">

            <div class="service-card">
                <h3>🔎 Tìm kiếm tài liệu</h3>
                <p>Tìm kiếm nhanh và nâng cao theo nhiều tiêu chí.</p>
            </div>

            <div class="service-card">
                <h3>📖 Đọc sách online</h3>
                <p>Truy cập nội dung sách trực tiếp trên website.</p>
            </div>

            <div class="service-card">
                <h3>⬇️ Tải tài liệu</h3>
                <p>Tải về tài liệu phục vụ học tập và nghiên cứu.</p>
            </div>

            <div class="service-card">
                <h3>⭐ Quản lý tài liệu</h3>
                <p>Hệ thống quản lý sách và tài liệu hiệu quả.</p>
            </div>

        </div>

    </div>


    <!-- THỐNG KÊ -->

    <div class="about-section">

        <h2>Thống kê thư viện</h2>

        <div class="stats">

            <div class="stat-box">
                <h2>10,000+</h2>
                <p>Tài liệu</p>
            </div>

            <div class="stat-box">
                <h2>5,000+</h2>
                <p>Người dùng</p>
            </div>

            <div class="stat-box">
                <h2>50,000+</h2>
                <p>Lượt truy cập</p>
            </div>

        </div>

    </div>


    <!-- LIÊN HỆ -->

    <div class="about-section contact">

        <h2>Liên hệ</h2>

        <p>
            📍 Địa chỉ: Digital Library Center <br>
            📧 Email: library@example.com <br>
            📞 Phone: +84 123 456 789
        </p>

    </div>


</div>
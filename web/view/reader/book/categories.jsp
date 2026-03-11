<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .categories-container{
        max-width:1200px;
        margin:auto;
        padding:40px 20px;
    }

    /* TITLE */

    .page-title{
        font-size:32px;
        font-weight:600;
        margin-bottom:30px;
        display:flex;
        align-items:center;
        gap:10px;
    }

    /* GRID */

    .category-grid{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
        gap:25px;
    }

    /* CARD */

    .category-card{
        background:white;
        border-radius:12px;
        padding:22px;
        border:1px solid #e5e7eb;
        transition:all 0.25s ease;
        position:relative;
        overflow:hidden;
    }

    .category-card:hover{
        transform:translateY(-6px);
        box-shadow:0 12px 25px rgba(0,0,0,0.08);
    }

    /* ICON */

    .category-icon{
        font-size:28px;
        margin-bottom:10px;
    }

    /* NAME */

    .category-name{
        font-size:18px;
        font-weight:600;
        color:#ea580c;
        margin-bottom:8px;
    }

    /* DESC */

    .category-desc{
        font-size:14px;
        color:#6b7280;
        line-height:1.5;
        margin-bottom:15px;
        height:40px;
        overflow:hidden;
    }

    /* BUTTON */

    .btn-view{
        display:inline-block;
        padding:7px 14px;
        background:#f97316;
        color:white;
        border-radius:6px;
        font-size:14px;
        text-decoration:none;
        transition:0.2s;
    }

    .btn-view:hover{
        background:#ea580c;
    }

</style>


<div class="categories-container">

    <div class="page-title">
        📚 Danh mục sách
    </div>


    <div class="category-grid">

        <c:forEach items="${categories}" var="c">

            <div class="category-card">

                <div class="category-icon">
                    📖
                </div>

                <div class="category-name">
                    ${c.category_name}
                </div>

                <div class="category-desc">
                    <c:out value="${c.description}" default="Không có mô tả"/>
                </div>


                    <a href="${pageContext.request.contextPath}/reader/search?type=category&keyword=${c.category_name}"
                   class="btn-view">
                    Xem sách
                </a>

            </div>

        </c:forEach>

    </div>

</div>
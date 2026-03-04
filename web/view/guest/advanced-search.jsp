<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .adv-container{
        max-width:1100px;
        margin:auto;
        margin-top:40px;
    }

    .adv-title{
        text-align:center;
        font-size:32px;
        font-weight:600;
        margin-bottom:20px;
    }

    /* TAB */

    .search-tabs{
        display:flex;
        gap:10px;
        margin-bottom:10px;
    }

    .tab{
        padding:10px 20px;
        background:#f3f4f6;
        border-radius:4px 4px 0 0;
        cursor:pointer;
    }

    .tab.active{
        background:#f59e0b;
        color:white;
    }

    /* BOX */

    .search-box{
        border:2px solid #f59e0b;
        padding:25px;
        background:white;
    }

    /* FILTER ROW */

    .filter-row{
        display:grid;
        grid-template-columns:1fr 1fr 1fr 1fr;
        gap:20px;
        margin-bottom:20px;
    }

    .filter-row select{
        padding:10px;
    }

    /* KEYWORD ROW */

    .keyword-row{
        display:grid;
        grid-template-columns:150px 1fr 120px;
        gap:15px;
        margin-bottom:15px;
    }

    .keyword-row select,
    .keyword-row input{
        padding:10px;
    }

    /* BUTTON */

    .search-btns{
        text-align:center;
        margin-top:20px;
    }

    .btn-search{
        background:#3b82f6;
        color:white;
        padding:10px 25px;
        border:none;
        border-radius:5px;
        cursor:pointer;
    }

    .btn-reset{
        background:#f97316;
        color:white;
        padding:10px 25px;
        border:none;
        border-radius:5px;
        cursor:pointer;
        margin-left:10px;
    }

</style>


<div class="adv-container">

    <div class="adv-title">Tìm kiếm nâng cao</div>

    <!-- TAB -->

    <div class="search-tabs">

        <div class="tab">TÌM NHANH</div>
        <div class="tab active">NÂNG CAO</div>

    </div>

    <!-- SEARCH BOX -->

    <div class="search-box">

        <form action="${pageContext.request.contextPath}/advanced-search" method="get">

            <!-- FILTER -->

            <div class="filter-row">

                <select name="library">
                    <option value="">----- Tất cả thư viện -----</option>
                </select>

                <select name="collection">
                    <option value="">----- Tất cả kho -----</option>
                </select>

                <select name="type">
                    <option value="">----- Toàn bộ tài liệu -----</option>
                </select>

                <select name="sort">
                    <option value="">---Sắp xếp theo---</option>
                    <option value="new">Mới nhất</option>
                    <option value="title">Tên A-Z</option>
                </select>

            </div>

            <hr>

            <!-- KEYWORD 1 -->

            <div class="keyword-row">

                <select name="field1">
                    <option value="">---Tất cả---</option>
                    <option value="title">Title</option>
                    <option value="author">Author</option>
                    <option value="category">Category</option>
                </select>

                <input type="text" name="keyword1" placeholder="Từ khóa tìm kiếm">

                <select name="logic1">
                    <option value="AND">Và</option>
                    <option value="OR">Hoặc</option>
                </select>

            </div>

            <!-- KEYWORD 2 -->

            <div class="keyword-row">

                <select name="field2">
                    <option value="">---Tất cả---</option>
                    <option value="title">Title</option>
                    <option value="author">Author</option>
                    <option value="category">Category</option>
                </select>

                <input type="text" name="keyword2" placeholder="Từ khóa tìm kiếm">

                <select name="logic2">
                    <option value="AND">Và</option>
                    <option value="OR">Hoặc</option>
                </select>

            </div>

            <!-- KEYWORD 3 -->

            <div class="keyword-row">

                <select name="field3">
                    <option value="">---Tất cả---</option>
                    <option value="title">Title</option>
                    <option value="author">Author</option>
                    <option value="category">Category</option>
                </select>

                <input type="text" name="keyword3" placeholder="Từ khóa tìm kiếm">

                <select name="logic3">
                    <option value="AND">Và</option>
                    <option value="OR">Hoặc</option>
                </select>

            </div>

            <!-- KEYWORD 4 -->

            <div class="keyword-row">

                <select name="field4">
                    <option value="">---Tất cả---</option>
                    <option value="title">Title</option>
                    <option value="author">Author</option>
                    <option value="category">Category</option>
                </select>

                <input type="text" name="keyword4" placeholder="Từ khóa tìm kiếm">

                <select name="logic4">
                    <option value="AND">Và</option>
                    <option value="OR">Hoặc</option>
                </select>

            </div>

            <!-- BUTTON -->

            <div class="search-btns">

                <button class="btn-search" type="submit">
                    Tìm kiếm
                </button>

                <button class="btn-reset" type="reset">
                    Tìm lại
                </button>

            </div>

        </form>

    </div>

</div>
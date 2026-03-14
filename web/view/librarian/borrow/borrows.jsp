<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="borrow-wrapper">

    <h2 class="page-title">Borrow Records</h2>

    <div class="table-box">

        <table class="borrow-table">

            <thead>
                <tr>
                    <th>ID</th>
                    <th>Reader</th>
                    <th>Borrow Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

                <c:choose>

                    <c:when test="${not empty borrows}">

                        <c:forEach var="b" items="${borrows}">

                            <tr>

                                <td>#${b.borrowId}</td>

                                <td>
                                    <i class="fa-solid fa-user"></i>
                                    ${b.readerName}
                                </td>

                                <td>
                                    <fmt:formatDate value="${b.borrowDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>

                                <td>

                                    <c:choose>

                                        <c:when test="${b.status == 'BORROWING'}">
                                            <span class="status borrowing">
                                                BORROWING
                                            </span>
                                        </c:when>

                                        <c:when test="${b.status == 'RETURNED'}">
                                            <span class="status returned">
                                                RETURNED
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="status">
                                                ${b.status}
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>

                                <td class="actions">

                                    <a class="btn view"
                                       href="${pageContext.request.contextPath}/librarian/borrow-detail?id=${b.borrowId}">
                                        View
                                    </a>

                                    <c:if test="${b.status == 'BORROWING'}">

                                        <a class="btn return"
                                           href="${pageContext.request.contextPath}/librarian/return?borrowId=${b.borrowId}">
                                            Return
                                        </a>

                                        <a class="btn extend"
                                           href="${pageContext.request.contextPath}/librarian/extend-borrow?borrowId=${b.borrowId}">
                                            Extend
                                        </a>

                                    </c:if>

                                </td>

                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>
                            <td colspan="5" class="empty">
                                No borrow records found
                            </td>
                        </tr>

                    </c:otherwise>

                </c:choose>

            </tbody>

        </table>

    </div>


    <!-- Pagination -->

    <div class="pagination">

        <c:forEach begin="1" end="${totalPages}" var="i">

            <a href="${pageContext.request.contextPath}/librarian/borrows?page=${i}"
               class="${i==currentPage?'active':''}">

                ${i}

            </a>

        </c:forEach>

    </div>

</div>



<style>

    .borrow-wrapper{
        padding:20px;
    }

    .page-title{
        font-size:22px;
        margin-bottom:20px;
        color:#333;
    }

    .table-box{
        background:white;
        border-radius:8px;
        box-shadow:0 2px 10px rgba(0,0,0,0.05);
        overflow:hidden;
    }

    .borrow-table{
        width:100%;
        border-collapse:collapse;
    }

    .borrow-table thead{
        background:#ff7a00;
        color:white;
    }

    .borrow-table th{
        padding:14px;
        text-align:left;
        font-size:14px;
    }

    .borrow-table td{
        padding:14px;
        border-bottom:1px solid #eee;
        font-size:14px;
    }

    .borrow-table tr:hover{
        background:#fafafa;
    }


    /* STATUS */

    .status{
        padding:5px 10px;
        border-radius:4px;
        font-size:12px;
        font-weight:600;
    }

    .borrowing{
        background:#fff3cd;
        color:#856404;
    }

    .returned{
        background:#d4edda;
        color:#155724;
    }


    /* ACTION BUTTONS */

    .actions{
        display:flex;
        gap:6px;
    }

    .btn{
        padding:5px 10px;
        border-radius:4px;
        text-decoration:none;
        font-size:12px;
        color:white;
    }

    .btn.view{
        background:#17a2b8;
    }

    .btn.return{
        background:#28a745;
    }

    .btn.extend{
        background:#ffc107;
        color:#333;
    }


    /* EMPTY */

    .empty{
        text-align:center;
        padding:20px;
        color:#888;
    }


    /* PAGINATION */

    .pagination{
        margin-top:20px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .pagination a{
        padding:6px 12px;
        text-decoration:none;
        background:#eee;
        border-radius:4px;
    }

    .pagination a.active{
        background:#ff7a00;
        color:white;
    }

</style>
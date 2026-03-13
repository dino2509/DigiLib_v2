<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<h2>Borrow Records</h2>

<table class="borrow-table">

    <thead>
        <tr>
            <th>ID</th>
            <th>Reader</th>
            <th>Borrow Date</th>
            <th>Status</th>
        </tr>
    </thead>

    <tbody>

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
                            <span class="status borrowing">BORROWING</span>
                        </c:when>

                        <c:when test="${b.status == 'RETURNED'}">
                            <span class="status returned">RETURNED</span>
                        </c:when>

                        <c:otherwise>
                            ${b.status}
                        </c:otherwise>

                    </c:choose>

                </td>

            </tr>

        </c:forEach>

    </tbody>

</table>
<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="i">

        <a href="${pageContext.request.contextPath}/librarian/borrows?page=${i}"
           class="${i==currentPage?'active':''}">

            ${i}

        </a>

    </c:forEach>

</div>

<style>
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
    .borrow-table{
        width:100%;
        border-collapse:collapse;
        background:white;
    }

    .borrow-table th{
        background:#ff7a00;
        color:white;
        padding:10px;
    }

    .borrow-table td{
        padding:10px;
        border-bottom:1px solid #eee;
    }

    .status{
        padding:4px 10px;
        border-radius:4px;
        font-size:12px;
    }

    .borrowing{
        background:#fff3cd;
        color:#856404;
    }

    .returned{
        background:#d4edda;
        color:#155724;
    }

</style>
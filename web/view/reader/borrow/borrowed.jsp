
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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

    .book-title{
        font-weight:500;
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

    .empty{
        text-align:center;
        padding:20px;
        color:#888;
    }

</style>

<div class="borrow-wrapper">


    <h2 class="page-title">My Borrowed Books</h2>

    <div class="table-box">

        <table class="borrow-table">

            <thead>
                <tr>
                    <th>Book</th>
                    <th>Borrow Date</th>
                    <th>Due Date</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

                <c:choose>

                    <c:when test="${not empty borrowedBooks}">

                        <c:forEach var="b" items="${borrowedBooks}">

                            <tr>

                                <td class="book-title">
                                    ${b.bookTitle}
                                </td>

                                <td>
                                    <fmt:formatDate value="${b.borrowDate}" pattern="yyyy-MM-dd"/>
                                </td>

                                <td>
                                    <fmt:formatDate value="${b.dueDate}" pattern="yyyy-MM-dd"/>
                                </td>

                                <td>

                                    <c:choose>

                                        <c:when test="${b.status == 'BORROWING'}">
                                            <span class="status borrowing">
                                                Borrowing
                                            </span>
                                        </c:when>

                                        <c:when test="${b.status == 'RETURNED'}">
                                            <span class="status returned">
                                                Returned
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="status">
                                                ${b.status}
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>

                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>
                            <td colspan="4" class="empty">
                                You have no borrowed books
                            </td>
                        </tr>

                    </c:otherwise>

                </c:choose>

            </tbody>

        </table>

    </div>


</div>


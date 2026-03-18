<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    .container{
        max-width:1100px;
        margin:auto;
    }

    .card{
        background:#fff;
        padding:24px;
        border-radius:16px;
        box-shadow:0 4px 12px rgba(0,0,0,0.05);
    }

    /* title */
    .title{
        font-size:22px;
        font-weight:600;
        margin-bottom:16px;
    }

    /* table */
    table{
        width:100%;
        border-collapse:collapse;
    }

    thead{
        background:#fff7ed;
    }

    th, td{
        padding:12px;
        text-align:center;
    }

    tbody tr:hover{
        background:#fff5ed;
    }

    /* status */
    .status{
        padding:4px 10px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
    }

    .waiting{
        background:#fff3cd;
        color:#856404;
    }
    .ready{
        background:#d4edda;
        color:#155724;
    }
    .cancel{
        background:#f8d7da;
        color:#721c24;
    }

    /* pagination */
    .pagination{
        margin-top:20px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .page-btn{
        padding:6px 12px;
        border:1px solid #ddd;
        border-radius:6px;
        text-decoration:none;
    }

    .page-btn.active{
        background:#ff7a00;
        color:white;
        border:none;
    }
</style>

<div class="container">
    <div class="card">

        <div class="title">📚 My Reservations</div>

        <table>

            <thead>
                <tr>
                    <th>STT</th>
                    <th>Book</th>
                    <th>Quantity</th>
                    <th>Reserved At</th>
                    <th>Expires At</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

                <c:forEach var="r" items="${reservations}" varStatus="loop">

                    <tr>

                        <td>${(page-1)*10 + loop.index + 1}</td>

                        <td>${r.bookTitle}</td>

                        <td>${r.quantity}</td>

                        <td>
                            <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            <fmt:formatDate value="${r.expiresAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${r.status=='WAITING'}">
                                    <span class="status waiting">WAITING</span>
                                </c:when>
                                <c:when test="${r.status=='FULFILLED'}">
                                    <span class="status ready">FULFILLED</span>
                                </c:when>
                                <c:when test="${r.status=='CANCELLED'}">
                                    <span class="status cancel">CANCELLED</span>
                                </c:when>
                                <c:otherwise>${r.status}</c:otherwise>
                            </c:choose>
                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty reservations}">
                    <tr><td colspan="6">No reservations found</td></tr>
                </c:if>

            </tbody>
        </table>

        <!-- PAGINATION -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">

                <c:forEach begin="1" end="${totalPages}" var="p">

                    <a class="page-btn ${p==page?'active':''}"
                       href="?page=${p}">
                        ${p}
                    </a>

                </c:forEach>

            </div>
        </c:if>

    </div>
</div>
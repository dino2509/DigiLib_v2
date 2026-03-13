<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<h2 style="margin-bottom:20px;">Borrow Requests</h2>

<table>

    <thead>

        <tr>
            <th>ID</th>
            <th>Reader</th>
            <th>Requested Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

    </thead>

    <tbody>

        <c:choose>

            <c:when test="${not empty requests}">

                <c:forEach var="r" items="${requests}">

                    <tr>

                        <td>#${r.requestId}</td>

                        <td>
                            <i class="fa-solid fa-user"></i>
                            ${r.readerName}
                        </td>

                        <td>
                            <fmt:formatDate value="${r.requestedAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${r.status == 'PENDING'}">
                                    <span style="color:#ff9800;font-weight:bold;">PENDING</span>
                                </c:when>

                                <c:when test="${r.status == 'APPROVED'}">
                                    <span style="color:green;font-weight:bold;">APPROVED</span>
                                </c:when>

                                <c:when test="${r.status == 'REJECTED'}">
                                    <span style="color:red;font-weight:bold;">REJECTED</span>
                                </c:when>

                                <c:otherwise>
                                    ${r.status}
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <a class="action-btn"
                               href="${pageContext.request.contextPath}/librarian/request-detail?id=${r.requestId}">
                                <i class="fa-solid fa-eye"></i> View
                            </a>

                        </td>

                    </tr>

                </c:forEach>

            </c:when>

            <c:otherwise>

                <tr>
                    <td colspan="5" style="text-align:center;padding:20px;">
                        No borrow requests found
                    </td>
                </tr>

            </c:otherwise>

        </c:choose>

    </tbody>

</table>
<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="p">

        <a href="${pageContext.request.contextPath}/librarian/requests?page=${p}"
           class="${p == currentPage ? 'active-page' : ''}">

            ${p}

        </a>

    </c:forEach>

</div>
<style>

    table{
        width:100%;
        border-collapse:collapse;
        background:white;
        border-radius:6px;
        overflow:hidden;
        box-shadow:0 2px 6px rgba(0,0,0,0.05);
    }

    th{
        background:#ff7a00;
        color:white;
        text-align:left;
        padding:12px;
        font-size:14px;
    }

    td{
        padding:12px;
        border-bottom:1px solid #eee;
        font-size:14px;
    }

    tr:hover{
        background:#f9f9f9;
    }

    .action-btn{
        text-decoration:none;
        background:#ff7a00;
        color:white;
        padding:6px 12px;
        border-radius:4px;
        font-size:13px;
        transition:0.2s;
    }

    .action-btn:hover{
        background:#e56700;
    }

    .pagination{
        margin-top:20px;
        text-align:center;
    }

    .pagination a{
        display:inline-block;
        padding:8px 12px;
        margin:3px;
        border-radius:4px;
        text-decoration:none;
        background:#eee;
        color:#333;
        font-size:14px;
    }

    .pagination a:hover{
        background:#ff7a00;
        color:white;
    }

    .active-page{
        background:#ff7a00 !important;
        color:white !important;
    }

</style>
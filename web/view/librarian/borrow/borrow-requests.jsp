<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="page-header">

    <h2>Borrow Requests</h2>

    <form method="get"
          action="${pageContext.request.contextPath}/librarian/requests"
          class="filter-box">

        <input type="text"
               name="reader"
               value="${reader}"
               placeholder="Search reader name">

        <select name="status">

            <option value="">All Status</option>

            <option value="PENDING"
                    <c:if test="${status=='PENDING'}">selected</c:if>>
                        Pending
                    </option>

                    <option value="APPROVED"
                    <c:if test="${status=='APPROVED'}">selected</c:if>>
                        Approved
                    </option>

                    <option value="REJECTED"
                    <c:if test="${status=='REJECTED'}">selected</c:if>>
                        Rejected
                    </option>

            </select>

            <button type="submit">
                <i class="fa-solid fa-search"></i>
                Search
            </button>

        </form>

    </div>


    <div class="card">

        <table>

            <thead>

                <tr>
                    <th>ID</th>
                    <th>Reader</th>
                    <th>Requested</th>
                    <th>Status</th>
                    <th style="width:220px;">Actions</th>
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

                                    <c:when test="${r.status=='PENDING'}">
                                        <span class="badge pending">Pending</span>
                                    </c:when>

                                    <c:when test="${r.status=='APPROVED'}">
                                        <span class="badge approved">Approved</span>
                                    </c:when>

                                    <c:when test="${r.status=='REJECTED'}">
                                        <span class="badge rejected">Rejected</span>
                                    </c:when>

                                </c:choose>

                            </td>

                            <td class="actions">

                                <a class="btn view"
                                   href="${pageContext.request.contextPath}/librarian/request-detail?id=${r.requestId}">

                                    <i class="fa-solid fa-eye"></i>
                                    View

                                </a>


                               

                            </td>

                        </tr>

                    </c:forEach>

                </c:when>

                <c:otherwise>

                    <tr>

                        <td colspan="5" class="empty">

                            <i class="fa-solid fa-folder-open"></i>
                            No borrow requests found

                        </td>

                    </tr>

                </c:otherwise>

            </c:choose>

        </tbody>

    </table>

</div>



<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="p">

        <a href="${pageContext.request.contextPath}/librarian/requests?page=${p}&reader=${reader}&status=${status}"
           class="${p==currentPage ? 'active-page':''}">

            ${p}

        </a>

    </c:forEach>

</div>



<style>

    .page-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .filter-box{
        display:flex;
        gap:10px;
    }

    .filter-box input,
    .filter-box select{
        padding:8px 10px;
        border:1px solid #ddd;
        border-radius:4px;
        font-size:14px;
    }

    .filter-box button{
        background:#ff7a00;
        color:white;
        border:none;
        padding:8px 14px;
        border-radius:4px;
        cursor:pointer;
    }

    .card{
        background:white;
        border-radius:8px;
        box-shadow:0 2px 8px rgba(0,0,0,0.06);
        overflow:hidden;
    }

    table{
        width:100%;
        border-collapse:collapse;
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
        background:#fafafa;
    }

    .actions{
        display:flex;
        gap:6px;
    }

    .btn{
        text-decoration:none;
        padding:6px 10px;
        border-radius:4px;
        font-size:13px;
        color:white;
        display:inline-flex;
        align-items:center;
        gap:5px;
    }

    .view{
        background:#3498db;
    }

    .approve{
        background:#2ecc71;
    }

    .reject{
        background:#e74c3c;
    }

    .badge{
        padding:4px 10px;
        border-radius:20px;
        font-size:12px;
        font-weight:bold;
    }

    .pending{
        background:#fff3cd;
        color:#ff9800;
    }

    .approved{
        background:#d4edda;
        color:#2ecc71;
    }

    .rejected{
        background:#f8d7da;
        color:#e74c3c;
    }

    .empty{
        text-align:center;
        padding:30px;
        color:#999;
        font-size:14px;
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
        background:#eee;
        text-decoration:none;
        color:#333;
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
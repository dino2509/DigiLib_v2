    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

    <style>

        .extend-wrapper{
            padding:20px;
        }

        .page-title{
            font-size:22px;
            margin-bottom:20px;
            color:#333;
        }

        /* card */

        .extend-card{
            background:white;
            border-radius:8px;
            box-shadow:0 2px 10px rgba(0,0,0,0.05);
            overflow:hidden;
        }

        /* table */

        .extend-table{
            width:100%;
            border-collapse:collapse;
        }

        .extend-table thead{
            background:#ff7a00;
            color:white;
        }

        .extend-table th{
            padding:14px;
            text-align:left;
            font-size:14px;
        }

        .extend-table td{
            padding:14px;
            border-bottom:1px solid #eee;
            font-size:14px;
        }

        .extend-table tr:hover{
            background:#fafafa;
        }

        /* badges */

        .badge{
            padding:4px 10px;
            border-radius:4px;
            font-size:12px;
            font-weight:600;
        }

        .badge-pending{
            background:#fff3cd;
            color:#856404;
        }

        /* buttons */

        .btn{
            border:none;
            padding:6px 12px;
            border-radius:4px;
            font-size:13px;
            cursor:pointer;
        }

        .btn-approve{
            background:#28a745;
            color:white;
        }

        .btn-approve:hover{
            background:#1e7e34;
        }

        .btn-reject{
            background:#dc3545;
            color:white;
        }

        .btn-reject:hover{
            background:#bd2130;
        }

        /* empty */

        .empty{
            text-align:center;
            padding:25px;
            color:#888;
        }

    </style>


    <div class="extend-wrapper">

        <h2 class="page-title">Borrow Extend Requests</h2>

        <div class="extend-card">

            <table class="extend-table">

                <thead>
                    <tr>
                        <th>Book</th>
                        <th>Copy Code</th>
                        <th>Old Due Date</th>
                        <th>Requested Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>

                <c:choose>

                    <c:when test="${not empty extends}">

                        <c:forEach var="e" items="${extends}">

                            <tr>

                                <td>
                                    <strong>${e.bookTitle}</strong>
                                </td>

                                <td>${e.copyCode}</td>

                                <td>
                            <fmt:formatDate value="${e.oldDueDate}" pattern="yyyy-MM-dd"/>
                            </td>

                            <td>
                            <fmt:formatDate value="${e.requestedDueDate}" pattern="yyyy-MM-dd"/>
                            </td>

                            <td>
                                <span class="badge badge-pending">
                                    Pending
                                </span>
                            </td>

                            <td>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/librarian/process-extend"
                                      style="display:flex; gap:8px;">

                                    <input type="hidden" name="extendId" value="${e.extendId}">

                                    <button class="btn btn-approve"
                                            name="action"
                                            value="approve"
                                            onclick="return confirm('Approve this extend request?')">

                                        Approve

                                    </button>

                                    <button class="btn btn-reject"
                                            name="action"
                                            value="reject"
                                            onclick="return confirm('Reject this extend request?')">

                                        Reject

                                    </button>

                                </form>

                            </td>

                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>
                            <td colspan="6" class="empty">
                                No extend requests found
                            </td>
                        </tr>

                    </c:otherwise>

                </c:choose>

                </tbody>

            </table>

        </div>

    </div>
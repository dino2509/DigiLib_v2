<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Read Ebook</title>

        <style>

            body{
                margin:0;
                font-family: Arial, sans-serif;
                background:#f5f6fa;
            }

            .topbar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                background:#2c3e50;
                color:white;
                padding:15px 30px;
            }

            .title{
                font-size:20px;
                font-weight:bold;
            }

            .back-btn{
                background:#3498db;
                color:white;
                padding:8px 14px;
                border-radius:5px;
                text-decoration:none;
            }

            .back-btn:hover{
                background:#2980b9;
            }

            .reader-container{
                width:100%;
                height:92vh;
            }

            iframe{
                width:100%;
                height:100%;
                border:none;
            }

        </style>
    </head>

    <body>

        <div class="topbar">

            <div class="title">
                📖 ${book.title}
            </div>
<!--
            <a class="back-btn" href="#" onclick="history.back(); return false;">
                ← Back
            </a>-->

        </div>

        <div class="reader-container">

            <iframe
                src="${pageContext.request.contextPath}/pdf/${book.contentPath}">
            </iframe>

        </div>

    </body>
</html>
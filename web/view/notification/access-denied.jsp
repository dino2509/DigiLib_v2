<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">
        <title>Access Denied</title>

        <style>

            body{
                font-family: Arial, sans-serif;
                background:#f5f5f5;
                display:flex;
                align-items:center;
                justify-content:center;
                height:100vh;
            }

            .container{
                background:white;
                padding:40px;
                border-radius:10px;
                box-shadow:0 5px 15px rgba(0,0,0,0.1);
                text-align:center;
            }

            h1{
                color:#e74c3c;
                font-size:36px;
            }

            p{
                margin:15px 0;
                color:#555;
            }

            .btn{
                display:inline-block;
                padding:10px 20px;
                background:#3498db;
                color:white;
                text-decoration:none;
                border-radius:5px;
            }

            .btn:hover{
                background:#2980b9;
            }

        </style>

    </head>
    <body>

        <div class="container">

            <h1>403</h1>

            <h2>Access Denied</h2>

            <p>
                You do not have permission to access this page.
            </p>

            <p>
                If you believe this is an error, please contact the administrator.
            </p>

            <a class="btn" href="${pageContext.request.contextPath}/home">
                Back to Home
            </a>

        </div>

    </body>
</html>
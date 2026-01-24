<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login | Digital Library</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }
        .login-container {
            width: 360px;
            margin: 80px auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
        }
        input[type=text],
        input[type=password] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #1976d2;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background: #125aa3;
        }
        .social-btn {
            background: #db4437;
            margin-top: 10px;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
        .register {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Login</h2>

    <!-- LOGIN LOCAL -->
    <form action="login" method="post">
        <input type="hidden" name="type" value="local"/>

        <label>Email</label>
        <input type="text" name="email" required />

        <label>Password</label>
        <input type="password" name="password" required />

        <button type="submit">Login</button>
    </form>

    <hr/>

<!--     LOGIN GOOGLE 
    <form action="login" method="post">
        <input type="hidden" name="type" value="google"/>
        <input type="hidden" name="providerUserId" value="google_123456"/>
        <input type="hidden" name="email" value="user@gmail.com"/>
        <input type="hidden" name="fullName" value="Google User"/>

       <button type="submit" class="social-btn">
            Login with Google
        </button>
    </form>-->

    <!-- ERROR MESSAGE -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <%
        }
    %>

    <div class="register">
        <a href="register">Create new account</a>
    </div>
</div>

</body>
</html>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Register | Digital Library</title>
    <meta charset="UTF-8">

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #fdf2e9;
        }

        .register-container {
            width: 380px;
            margin: 80px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
            border-top: 6px solid #ff7a18;
        }

        h2 {
            text-align: center;
            color: #ff7a18;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            color: #555;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 6px 0 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            outline: none;
        }

        input:focus {
            border-color: #ff7a18;
            box-shadow: 0 0 4px rgba(255,122,24,0.4);
        }

        button {
            width: 100%;
            padding: 11px;
            background: #ff7a18;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 15px;
        }

        button:hover {
            background: #e8650f;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 12px;
            font-size: 14px;
        }

        .login-link {
            text-align: center;
            margin-top: 18px;
            font-size: 14px;
        }

        .login-link a {
            color: #ff7a18;
            font-weight: bold;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="register-container">
    <h2>Create Account</h2>

    <form action="register" method="post">
        <label>Full Name</label>
        <input type="text" name="fullName" required />

        <label>Email</label>
        <input type="email" name="email" required />

        <label>Password</label>
        <input type="password" name="password" required />

        <label>Confirm Password</label>
        <input type="password" name="confirm" required />

        <button type="submit">Register</button>
    </form>

    <!-- ERROR MESSAGE -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <%
        }
    %>

    <div class="login-link">
        Already have an account?
        <a href="login">Login here</a>
    </div>
</div>

</body>
</html>

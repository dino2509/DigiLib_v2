<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Register | Digital Library</title>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f6f8;
            }
            .register-container {
                width: 380px;
                margin: 80px auto;
                background: white;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
            }
            label {
                font-weight: bold;
            }
            input {
                width: 100%;
                padding: 10px;
                margin: 6px 0 12px 0;
            }
            button {
                width: 100%;
                padding: 10px;
                background: #2e7d32;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            button:hover {
                background: #1b5e20;
            }
            .error {
                color: red;
                text-align: center;
                margin-top: 10px;
            }
            .login-link {
                text-align: center;
                margin-top: 15px;
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

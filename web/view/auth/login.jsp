<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login | Digital Library</title>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #fdf2e9; /* nền cam nhạt */
            }

            .login-container {
                width: 360px;
                margin: 80px auto;
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
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

            input[type=text],
            input[type=password] {
                width: 100%;
                padding: 10px;
                margin: 8px 0 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
                outline: none;
            }

            input:focus {
                border-color: #ff7a18;
                box-shadow: 0 0 4px rgba(255,122,24,0.4);
            }

            button {
                width: 100%;
                padding: 10px;
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

            .social-btn {
                background: #ff7043;
                margin-top: 10px;
            }

            .social-btn:hover {
                background: #f4511e;
            }

            hr {
                border: none;
                height: 1px;
                background: #f0c7a3;
                margin: 20px 0;
            }

            .error {
                color: red;
                text-align: center;
                margin-top: 10px;
                font-size: 14px;
            }

            .register {
                text-align: center;
                margin-top: 15px;
            }

            .register a {
                text-decoration: none;
                color: #ff7a18;
                font-weight: bold;
            }

            .register a:hover {
                text-decoration: underline;
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

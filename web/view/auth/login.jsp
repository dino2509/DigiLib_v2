<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login | Digital Library</title>
        <meta charset="UTF-8">
<<<<<<< HEAD
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #fdf2e9; /* nền cam nhạt */
=======

        <style>
            body {
                font-family: Arial, sans-serif;
                background: #fdf2e9;
>>>>>>> master
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
<<<<<<< HEAD
                outline: none;
            }

            input:focus {
                border-color: #ff7a18;
                box-shadow: 0 0 4px rgba(255,122,24,0.4);
=======
>>>>>>> master
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
<<<<<<< HEAD
                font-size: 15px;
=======
>>>>>>> master
            }

            button:hover {
                background: #e8650f;
            }

<<<<<<< HEAD
            .social-btn {
                background: #ff7043;
                margin-top: 10px;
            }

            .social-btn:hover {
                background: #f4511e;
=======
            .google-btn {
                display: block;
                text-align: center;
                background: #4285F4;
                color: white;
                padding: 10px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: bold;
                margin-top: 10px;
            }

            .google-btn:hover {
                background: #3367d6;
>>>>>>> master
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
<<<<<<< HEAD
                font-size: 14px;
=======
>>>>>>> master
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
<<<<<<< HEAD

            .register a:hover {
                text-decoration: underline;
            }
        </style>

    </head>
=======
        </style>
    </head>

>>>>>>> master
    <body>

        <div class="login-container">
            <h2>Login</h2>

            <!-- LOGIN LOCAL -->
            <form action="login" method="post">
                <input type="hidden" name="type" value="local"/>

                <label>Email</label>
<<<<<<< HEAD
                <input type="text" name="email" required />

                <label>Password</label>
                <input type="password" name="password" required />
=======
                <input type="text" name="email" required/>

                <label>Password</label>
                <input type="password" name="password" required/>
>>>>>>> master

                <button type="submit">Login</button>
            </form>

            <hr/>

<<<<<<< HEAD
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
=======
            <!-- LOGIN GOOGLE -->

            <!--            <a class="google-btn"
                           href="https://accounts.google.com/o/oauth2/v2/auth
                           ?client_id=687015797507-toh2purq11gr7040ftn84s54b0taed3b.apps.googleusercontent.com
                           &redirect_uri=http://localhost:9999/SWP_Project/login-google
                           &response_type=code
                           &scope=openid%20email%20profile">
                            Login with Google
                        </a>-->
            <a class="google-btn" href="https://accounts.google.com/o/oauth2/v2/auth?client_id=687015797507-toh2purq11gr7040ftn84s54b0taed3b.apps.googleusercontent.com&redirect_uri=http://localhost:9999/SWP_Project/login-google&response_type=code&scope=openid%20email%20profile">
                Login with Google
            </a>

>>>>>>> master

            <!-- ERROR MESSAGE -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="error"><%= error %></div>
            <%
                }
            %>

<<<<<<< HEAD
=======
            
             

>>>>>>> master
            <div class="register">
                <a href="register">Create new account</a>
            </div>
        </div>

    </body>
</html>

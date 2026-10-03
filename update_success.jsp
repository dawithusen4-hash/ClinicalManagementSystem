<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Successful | Clinic System</title>
    <meta http-equiv="refresh" content="4;url=manage_users.jsp">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .card {
            background: white;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 400px;
            width: 90%;
            border-top: 6px solid #27ae60;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .icon-box {
            width: 70px;
            height: 70px;
            background: #27ae60;
            color: white;
            font-size: 40px;
            line-height: 70px;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        h2 { color: #2c3e50; margin-bottom: 10px; }
        p { color: #7f8c8d; line-height: 1.5; margin-bottom: 25px; }

        .loader-bar {
            width: 100%;
            height: 4px;
            background: #f1f2f6;
            border-radius: 2px;
            overflow: hidden;
        }

        .loader-progress {
            width: 0%;
            height: 100%;
            background: #3498db;
            animation: progress 4s linear forwards;
        }

        @keyframes progress {
            to { width: 100%; }
        }

        .manual-link {
            display: block;
            margin-top: 20px;
            color: #3498db;
            text-decoration: none;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="card">
    <div class="icon-box">✓</div>
    <h2>Update Successful!</h2>
    <p>The user profile has been updated and saved to the clinic database.</p>
    
    <div class="loader-bar">
        <div class="loader-progress"></div>
    </div>
    <p style="font-size: 0.8rem; margin-top: 10px;">Returning to user list...</p>
    
    <a href="manage_users.jsp" class="manual-link">Click here if you aren't redirected</a>
</div>

</body>
</html>
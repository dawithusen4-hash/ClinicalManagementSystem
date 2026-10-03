<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="4;url=admin_dashboard.jsp">
    <title>Registration Successful | Mattu Clinic</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .success-card {
            background: white;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            text-align: center;
            max-width: 450px;
            width: 90%;
            border-top: 5px solid #27ae60; /* The green top bar from your image */
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* The Green Checkmark Circle */
        .checkmark-circle {
            width: 70px;
            height: 70px;
            background-color: #27ae60;
            color: white;
            font-size: 40px;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.8rem;
        }

        p {
            color: #7f8c8d;
            font-size: 1rem;
            line-height: 1.5;
            margin-bottom: 25px;
        }

        /* --- Animated Progress Bar --- */
        .progress-container {
            background-color: #e9ecef;
            border-radius: 10px;
            height: 6px;
            width: 100%;
            margin-bottom: 15px;
            overflow: hidden;
        }

        .progress-bar {
            background-color: #3498db;
            height: 100%;
            width: 0%;
            animation: fillProgress 4s linear forwards;
        }

        @keyframes fillProgress {
            from { width: 0%; }
            to { width: 100%; }
        }

        .status-text {
            color: #95a5a6;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: block;
        }

        .manual-link {
            color: #3498db;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .manual-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="success-card">
    <div class="checkmark-circle">✓</div>
    
    <h2>Registration Successful!</h2>
    
    <p>The new staff account has been successfully created and saved to the clinic database.</p>
    
    <div class="progress-container">
        <div class="progress-bar"></div>
    </div>
    
    <span class="status-text">Returning to dashboard...</span>
    
    <a href="admin_dashboard.jsp" class="manual-link">Click here if you aren't redirected</a>
</div>

</body>
</html>
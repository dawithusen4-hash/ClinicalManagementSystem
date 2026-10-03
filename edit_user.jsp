<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User | Admin Panel</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); 
            display: flex; 
            justify-content: center; 
            padding: 50px; 
            margin: 0;
            min-height: 100vh;
        }
        .edit-card { 
            background: white; 
            padding: 35px; 
            border-radius: 12px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
            width: 100%;
            max-width: 400px; 
            height: fit-content;
        }
        .header { 
            border-bottom: 2px solid #3498db; 
            margin-bottom: 20px; 
            padding-bottom: 10px; 
            color: #2c3e50; 
            text-align: center;
        }
        label { 
            display: block; 
            margin: 15px 0 5px; 
            font-weight: 600; 
            color: #34495e; 
        }
        input, select { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            box-sizing: border-box; 
            font-size: 1rem;
        }
        
        /* Strength Meter Message Style */
        #pass-msg { 
            font-size: 0.85rem; 
            margin-top: 6px; 
            font-weight: bold; 
            display: block; 
            min-height: 1.2rem; 
        }
        
        /* Toggle Styling */
        .toggle-box {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
        }
        .toggle-box input { width: auto; cursor: pointer; }
        .toggle-box label { margin: 0; font-size: 0.85rem; font-weight: normal; color: #7f8c8d; cursor: pointer; }

        .btn-save { 
            width: 100%; 
            background: #27ae60; 
            color: white; 
            border: none; 
            padding: 14px; 
            margin-top: 25px; 
            border-radius: 6px; 
            cursor: pointer; 
            font-weight: bold; 
            font-size: 1rem;
            transition: background 0.3s;
        }
        .btn-save:hover { background: #219150; }
        
        .btn-cancel { 
            display: block; 
            text-align: center; 
            margin-top: 15px; 
            color: #7f8c8d; 
            text-decoration: none; 
            font-size: 0.9rem; 
        }
        .btn-cancel:hover { color: #2c3e50; text-decoration: underline; }
    </style>
</head>
<body>

<%
    String id = request.getParameter("id");
    String username = "", role = "", password = "";

    try {
        // Use updated driver for modern MySQL
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
        
        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE user_id = ?");
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            username = rs.getString("username");
            role = rs.getString("role");
            password = rs.getString("password");
        }
%>

<div class="edit-card">
    <div class="header">
        <h2>Edit User Profile</h2>
    </div>
    
    <form action="UpdateUserServlet" method="POST" id="editForm" onsubmit="return validateEdit()">
        <input type="hidden" name="user_id" value="<%= id %>">

        <label for="username">Username</label>
        <input type="text" id="username" name="username" value="<%= username %>" required>

        <label for="passInput">Password</label>
        <input type="password" name="password" id="passInput" value="<%= password %>" required>
        
        <div class="toggle-box">
            <input type="checkbox" id="showPass">
            <label for="showPass">Show Password</label>
        </div>
        
        <span id="pass-msg"></span>

        <label for="role">User Role</label>
        <select name="role" id="role">
            <option value="admin" <%= role.equals("admin") ? "selected" : "" %>>Administrator</option>
            <option value="doctor" <%= role.equals("doctor") ? "selected" : "" %>>Doctor</option>
            <option value="receptionist" <%= role.equals("receptionist") ? "selected" : "" %>>Receptionist</option>
            <option value="lab_technician" <%= role.equals("lab") ? "selected" : "" %>>Lab Technician</option>
            <option value="pharmacist" <%= role.equals("pharmacist") ? "selected" : "" %>>Pharmacist</option>
        </select>

        <button type="submit" class="btn-save">Save Changes</button>
        <a href="manage_users.jsp" class="btn-cancel">Cancel and Return</a>
    </form>
</div>

<script>
    const passInput = document.getElementById('passInput');
    const passMsg = document.getElementById('pass-msg');
    const showPass = document.getElementById('showPass');

    // 1. Show/Hide Password Logic
    showPass.addEventListener('change', function() {
        passInput.type = this.checked ? 'text' : 'password';
    });

    // 2. Real-time Security Validation
    passInput.addEventListener('input', () => {
        const val = passInput.value;
        const hasLetter = /[A-Za-z]/.test(val);
        const hasNumber = /\d/.test(val);

        if (val.length < 8) {
            passMsg.innerText = "❌ Too short (Min 8 characters)";
            passMsg.style.color = "#e74c3c"; // Red
        } else if (!hasLetter || !hasNumber) {
            passMsg.innerText = "⚠️ Weak (Add letters and numbers)";
            passMsg.style.color = "#f39c12"; // Orange
        } else {
            passMsg.innerText = "✅ Secure Password Pattern";
            passMsg.style.color = "#27ae60"; // Green
        }
    });

    // 3. Final submission check (Form Firewall)
    function validateEdit() {
        const val = passInput.value;
        const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
        
        if (!regex.test(val)) {
            alert("Update Blocked: For security, the password must be at least 8 characters long and contain both letters and numbers.");
            return false;
        }
        return true;
    }
</script>

<%
        con.close();
    } catch (Exception e) {
        out.println("<div class='edit-card'><h3 style='color:red;'>Connection Error</h3>" + e.getMessage() + "</div>");
    }
%>

</body>
</html>
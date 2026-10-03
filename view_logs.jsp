<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Audit Logs | Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; background-color: #f4f7f6; }
        
        .sidebar { width: 250px; height: 100vh; background: #2c3e50; color: white; padding: 20px; position: fixed; }
        .sidebar h2 { font-size: 1.2rem; border-bottom: 1px solid #34495e; padding-bottom: 15px; color: #3498db; }
        .sidebar a { display: block; color: #bdc3c7; padding: 12px 0; text-decoration: none; transition: 0.3s; }
        .sidebar a:hover { color: white; padding-left: 10px; }

        .main-content { margin-left: 270px; padding: 30px; width: calc(100% - 300px); }
        
        .header-container { 
            display: flex; justify-content: space-between; align-items: center; 
            background: white; padding: 20px 30px; border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 30px;
        }

        .header-text h1 { margin: 0; color: #2c3e50; font-size: 1.8rem; }
        .header-text p { margin: 5px 0 0; color: #7f8c8d; }

        .button-group { display: flex; gap: 10px; }

        .btn-back, .btn-clear {
            padding: 10px 20px; border-radius: 8px; font-weight: 600; 
            display: flex; align-items: center; gap: 8px; text-decoration: none; border: none; cursor: pointer;
        }
        .btn-back { background-color: #3498db; color: white; }
        .btn-clear { background-color: #e74c3c; color: white; }

        .table-container { background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #f8f9fa; color: #2c3e50; padding: 18px; text-align: left; font-weight: 600; border-bottom: 2px solid #edf2f7; }
        td { padding: 15px 18px; border-bottom: 1px solid #f1f4f8; color: #4a5568; font-size: 0.85rem; }
        
        /* Status Indicators */
        .status-dot { height: 10px; width: 10px; border-radius: 50%; display: inline-block; margin-right: 5px; }
        .online { background-color: #10b981; box-shadow: 0 0 8px #10b981; }
        .offline { background-color: #94a3b8; }
        
        .user-pill { background: #e0e7ff; color: #4338ca; padding: 4px 10px; border-radius: 6px; font-weight: 600; }
        .empty-row { text-align: center; padding: 40px !important; color: #a0aec0; font-style: italic; }
    </style>
</head>
<body>

    <%
        // Handle Clear History Action
        if(request.getParameter("clear") != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                con2.createStatement().executeUpdate("TRUNCATE TABLE system_logs");
                con2.close();
                response.sendRedirect("view_logs.jsp");
            } catch(Exception e) { out.println(e); }
        }
    %>

    <div class="sidebar">
        <h2>Mattu Clinic Admin</h2>
        <a href="admin_dashboard.jsp">Dashboard Home</a>
        <a href="manage_users.jsp">User Management</a>
        <a href="view_logs.jsp" style="color: white; font-weight: bold;">System Logs</a>
        <a href="index.html" style="margin-top: 50px; color: #e74c3c;">Log Out</a>
    </div>

    <div class="main-content">
        <div class="header-container">
            <div class="header-text">
                <h1>Staff Activity & Logs</h1>
                <p>Track user registration, live status, and audit trails.</p>
            </div>
            <div class="button-group">
                <form method="POST" onsubmit="return confirm('Clear all audit records?');">
                    <button type="submit" name="clear" class="btn-clear">? Clear Logs</button>
                </form>
                <a href="admin_dashboard.jsp" class="btn-back">&larr; Dashboard</a>
            </div>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Staff User</th>
                        <th>Live Status</th>
                        <th>Action Performed</th>
                        <th>Last Seen / Time</th>
                        <th>Registration Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                            
                            // Join system_logs with users table to get live status and reg_date
                            String query = "SELECT l.*, u.is_online, u.registration_date " +
                                           "FROM system_logs l " +
                                           "LEFT JOIN users u ON l.username = u.username " +
                                           "ORDER BY l.action_time DESC";
                            
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(query);
                            
                            boolean hasData = false;
                            while(rs.next()) {
                                hasData = true;
                                boolean isOnline = rs.getBoolean("is_online");
                    %>
                    <tr>
                        <td><span class="user-pill"><%= rs.getString("username") %></span></td>
                        <td>
                            <span class="status-dot <%= isOnline ? "online" : "offline" %>"></span>
                            <%= isOnline ? "Online" : "Offline" %>
                        </td>
                        <td><%= rs.getString("action_performed") %></td>
                        <td><%= rs.getTimestamp("action_time") %></td>
                        <td><%= rs.getTimestamp("registration_date") != null ? rs.getTimestamp("registration_date") : "Pre-existing" %></td>
                    </tr>
                    <%
                            }
                            if(!hasData) {
                    %>
                        <tr>
                            <td colspan="5" class="empty-row">No activity records found in the database.</td>
                        </tr>
                    <%
                            }
                            con.close();
                        } catch(Exception e) { 
                            out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>"); 
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
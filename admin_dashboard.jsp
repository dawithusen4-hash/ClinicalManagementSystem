
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. Session Guard & Security Check (Non-Functional Role: Authentication Enforcement)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String currentRole = (String) session.getAttribute("role");
    if (session.getAttribute("username") == null || !"admin".equalsIgnoreCase(currentRole)) { 
        response.sendRedirect("login.html?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Mattu Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; display: flex; background-color: #f8fafc; color: #334155; }
        
        /* Navigation Sidebar */
        .sidebar { width: 260px; height: 100vh; background: #0f172a; color: white; padding: 30px 20px; position: fixed; z-index: 1000; box-sizing: border-box; }
        .sidebar h2 { color: #38bdf8; margin: 0 0 35px 0; font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .sidebar a { display: block; color: #94a3b8; padding: 12px 15px; text-decoration: none; border-radius: 8px; margin-bottom: 8px; font-weight: 500; transition: all 0.2s ease; }
        .sidebar a:hover { color: white; background: #1e293b; padding-left: 20px; }
        .sidebar a.active { background: #38bdf8; color: #0f172a; font-weight: 600; }
        .sidebar a.signout { color: #f87171; margin-top: 40px; border: 1px solid rgba(248, 113, 113, 0.2); }
        .sidebar a.signout:hover { background: rgba(248, 113, 113, 0.1); color: #fca5a5; }
        
        /* Layout Structure Wrapper */
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); box-sizing: border-box; }
        
        /* Greeting Segment Card */
        .welcome-section { 
            background: white; padding: 30px; border-radius: 16px; margin-bottom: 30px; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.01);
            border-left: 6px solid #38bdf8;
        }
        .welcome-section h1 { margin: 0 0 8px 0; color: #1e293b; font-size: 1.75rem; font-weight: 700; }
        .welcome-section p { color: #64748b; font-size: 1rem; margin: 0; line-height: 1.5; }

        /* Dynamic Status Grid */
        .overview-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 35px; }
        .overview-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border-top: 5px solid #38bdf8; position: relative; }
        .overview-card h3 { margin: 0; color: #94a3b8; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; }
        .overview-card .count { font-size: 2.2rem; font-weight: 700; color: #0f172a; margin-top: 12px; display: block; }

        /* Interactive Users Matrix Data Table */
        .table-container { background: white; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; overflow: hidden; }
        .table-header { padding: 20px 25px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .table-header h2 { margin: 0; font-size: 1.1rem; color: #1e293b; font-weight: 600; }
        
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background-color: #f8fafc; color: #64748b; padding: 16px 25px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #e2e8f0; }
        td { padding: 16px 25px; font-size: 0.95rem; border-bottom: 1px solid #e2e8f0; color: #334155; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: #f8fafc; }
        
        /* Clean Structural Badges UI */
        .role-badge { padding: 5px 12px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; display: inline-block; text-transform: capitalize; }
        .admin { background: #fee2e2; color: #991b1b; }
        .doctor { background: #e0f2fe; color: #075985; }
        .pharmacist { background: #fef3c7; color: #92400e; }
        .lab_technician { background: #f3e8ff; color: #6b21a8; }
        .receptionist { background: #dcfce7; color: #166534; }
        
        /* Live Status Indicators */
        .status-pill { display: inline-flex; align-items: center; gap: 6px; font-size: 0.85rem; font-weight: 500; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
        .online-dot { background-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.2); }
        .offline-dot { background-color: #94a3b8; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>🏥 Mattu Clinic</h2>
    <a href="admin_dashboard.jsp" class="active">Dashboard</a>
    <a href="manage_users.jsp">User Management</a>
    <a href="actorregistration.html">Register New Actor</a>
    <a href="view_logs.jsp">Security Audit Logs</a>
    <a href="login.html" class="signout">Sign Out</a> </div>

<div class="main-content">
    <% 
        int totalStaff = 0;
        int activeUsers = 0;
        int securityAlerts = 0;

        Connection con = null;
        Statement stmtTotal = null;
        Statement stmtActive = null;
        Statement stmtAlerts = null;
        ResultSet rsTotal = null;
        ResultSet rsActive = null;
        ResultSet rsAlerts = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            
            // 1. Fetch exact total system staff
            stmtTotal = con.createStatement();
            rsTotal = stmtTotal.executeQuery("SELECT COUNT(*) FROM users");
            if(rsTotal.next()) totalStaff = rsTotal.getInt(1);
            
            // 2. Fetch live active session metrics matching 'Online' status values
            stmtActive = con.createStatement();
            rsActive = stmtActive.executeQuery("SELECT COUNT(*) FROM users WHERE status = 'Online'");
            if(rsActive.next()) activeUsers = rsActive.getInt(1);
            
            // 3. Extract total security errors matching authentication issues from logs
            try {
                stmtAlerts = con.createStatement();
                rsAlerts = stmtAlerts.executeQuery("SELECT COUNT(*) FROM logs WHERE action LIKE '%Failed%' OR action LIKE '%Unauthorized%'");
                if(rsAlerts.next()) securityAlerts = rsAlerts.getInt(1);
            } catch(Exception e) { 
                securityAlerts = 0; 
            }
            
        } catch (Exception e) { 
            // Graceful non-functional role: Error isolation fallback wrapper
            System.err.println("Dashboard initialization data failure exception context: " + e.getMessage());
        } finally {
            // Non-functional Resource Cleanup Routine: Guarding against connection leak overloads
            if (rsTotal != null) { try { rsTotal.close(); } catch(Exception ignored){} }
            if (rsActive != null) { try { rsActive.close(); } catch(Exception ignored){} }
            if (rsAlerts != null) { try { rsAlerts.close(); } catch(Exception ignored){} }
            if (stmtTotal != null) { try { stmtTotal.close(); } catch(Exception ignored){} }
            if (stmtActive != null) { try { stmtActive.close(); } catch(Exception ignored){} }
            if (stmtAlerts != null) { try { stmtAlerts.close(); } catch(Exception ignored){} }
        }
    %>

    <div class="welcome-section">
        <h1>System Administrative Control Center</h1>
        <p>As a <strong>System Administrator</strong>, you have full authority to oversee clinic operations. Welcome back, <strong><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Admin" %></strong>!</p>
    </div>

    <div class="overview-grid">
        <div class="overview-card">
            <h3>Total Staff</h3>
            <span class="count"><%= totalStaff %></span>
        </div>
        <div class="overview-card" style="border-top-color: #10b981;">
            <h3>Online Now</h3>
            <span class="count" style="color: #10b981;"><%= activeUsers %></span>
        </div>
        <div class="overview-card" style="border-top-color: #ef4444;">
            <h3>Security Alerts</h3>
            <span class="count" style="color: #ef4444;"><%= securityAlerts %></span>
        </div>
    </div>

    <div class="table-container">
        <div class="table-header">
            <h2>Active Management Register</h2>
        </div>
        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Staff Name</th>
                    <th>Access Role</th>
                    <th>Live Connection Status</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Statement stmtTable = null;
                    ResultSet rsTable = null;
                    try {
                        if (con == null || con.isClosed()) {
                            Class.forName("com.mysql.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                        }
                        
                        stmtTable = con.createStatement();
                        rsTable = stmtTable.executeQuery("SELECT user_id, username, role, status FROM users ORDER BY user_id DESC");
                        boolean hasData = false;
                        while(rsTable.next()) {
                            hasData = true;
                            String role = rsTable.getString("role");
                            if (role == null) role = "staff";
                            
                            String status = rsTable.getString("status");
                            if (status == null) status = "Offline";
                            
                            String badgeClass = role.toLowerCase().trim().replace(" ", "_");
                            boolean isOnline = "Online".equalsIgnoreCase(status);
                 TirageRow: %>
                <tr>
                    <td>#<%= rsTable.getInt("user_id") %></td>
                    <td><strong><%= rsTable.getString("username") %></strong></td>
                    <td><span class="role-badge <%= badgeClass %>"><%= role.toUpperCase().replace("_", " ") %></span></td>
                    <td>
                        <span class="status-pill">
                            <span class="status-dot <%= isOnline ? "online-dot" : "offline-dot" %>"></span>
                            <%= isOnline ? "Online" : "Offline" %>
                        </span>
                    </td>
                </tr>
                <% 
                        } 
                        if(!hasData) {
                %>
                <tr>
                    <td colspan="4" style="text-align: center; color: #64748b; padding: 30px;">No registered infrastructure accounts tracked in registry.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) { 
                        out.println("<tr><td colspan='4' style='color:red;'>Runtime error parsing index parameters: " + e.getMessage() + "</td></tr>"); 
                    } finally {
                        // Safe cleanups inside the table generation frame block
                        if (rsTable != null) { try { rsTable.close(); } catch (SQLException ignored) {} }
                        if (stmtTable != null) { try { stmtTable.close(); } catch (SQLException ignored) {} }
                        if (con != null) { try { con.close(); } catch (SQLException se) { se.printStackTrace(); } }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

```
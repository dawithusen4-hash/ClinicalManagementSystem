<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Appointments | MedFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f8fafc; color: #334155; margin: 0; padding: 40px; }
        .table-container { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; }
        h2 { margin-top: 0; color: #0f172a; font-weight: 700; }
        
        /* Search Box layout */
        .search-container { margin: 25px 0; display: flex; gap: 12px; align-items: center; }
        .search-input { padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 8px; flex-grow: 1; font-family: inherit; font-size: 0.95rem; outline: none; }
        .search-input:focus { border-color: #3498db; }
        .btn-search { background: #0f172a; color: white; border: none; padding: 12px 24px; border-radius: 8px; cursor: pointer; font-weight: 600; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #0f172a; color: white; padding: 14px; text-align: left; font-size: 0.95rem; }
        td { padding: 14px; border-bottom: 1px solid #e2e8f0; font-size: 0.95rem; }
        
        .status-badge { background: #e0f2fe; color: #0369a1; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .btn-reserve { background: #3498db; color: white; border: none; padding: 8px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-reserve:hover { background: #2980b9; }
        
        .alert-banner { padding: 14px 20px; border-radius: 8px; margin-bottom: 20px; background: #dcfce7; color: #14532d; border: 1px solid #bbf7d0; font-weight: 500; }
    </style>
</head>
<body>

<div class="table-container">
    <h2>Search & Reserve Upcoming Appointments</h2>
    
    <% if (request.getParameter("message") != null) { %>
        <div class="alert-banner">
            ✅ <%= java.net.URLDecoder.decode(request.getParameter("message"), "UTF-8") %>
        </div>
    <% } %>

    <form method="GET" action="view_appointments.jsp" class="search-container">
        <input type="text" name="search" class="search-input" placeholder="Search scheduled appointments by patient name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit" class="btn-search">Search</button>
    </form>

    <table>
        <tr>
            <th>ID</th>
            <th>Patient Name</th>
            <th>Assigned Doctor</th>
            <th>Date</th>
            <th>Time</th>
            <th>Reason</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                
                String search = request.getParameter("search");
                String sql = "SELECT * FROM appointments WHERE status = 'Scheduled'";
                
                if (search != null && !search.trim().isEmpty()) {
                    sql += " AND patient_name LIKE ?";
                }
                sql += " ORDER BY app_date ASC, app_time ASC";

                PreparedStatement pst = con.prepareStatement(sql);
                if (search != null && !search.trim().isEmpty()) {
                    pst.setString(1, "%" + search + "%");
                }

                ResultSet rs = pst.executeQuery();
                boolean hasData = false;
                while(rs.next()) {
                    hasData = true;
                    int appId = rs.getInt("app_id");
        %>
        <tr>
            <td>#<%= appId %></td>
            <td><strong><%= rs.getString("patient_name") %></strong></td>
            <td><%= rs.getString("doctor_name") %></td>
            <td><%= rs.getString("app_date") %></td>
            <td><%= rs.getString("app_time") %></td>
            <td><%= rs.getString("reason") %></td>
            <td><span class="status-badge"><%= rs.getString("status") %></span></td>
            <td>
                <form action="process_reservation.jsp" method="POST" style="margin: 0;">
                    <input type="hidden" name="app_id" value="<%= appId %>">
                    <input type="hidden" name="patient_name" value="<%= rs.getString("patient_name") %>">
                    <button type="submit" class="btn-reserve">Reserve & Send to Doctor</button>
                </form>
            </td>
        </tr>
        <% 
                }
                if(!hasData) {
                    out.print("<tr><td colspan='8' style='text-align:center; color:#64748b; font-style:italic; padding:30px;'>No upcoming appointments found matching your search.</td></tr>");
                }
                con.close();
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </table>
    <br>
    <a href="reception_dashboard.jsp" style="color: #3498db; text-decoration: none;">&larr; Back to Dashboard</a>
</div>

</body>
</html>
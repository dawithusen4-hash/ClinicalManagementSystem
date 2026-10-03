<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medication Dispensed History</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; padding: 40px; }
        .card { background: white; width: 1000px; border-radius: 15px; padding: 40px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        h1 { color: #000; margin-bottom: 30px; font-weight: 800; }
        
        .search-bar { display: flex; gap: 10px; margin-bottom: 25px; }
        .search-input { flex-grow: 1; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; }
        .btn-search { background-color: #27ae60; color: white; border: none; padding: 0 25px; border-radius: 8px; cursor: pointer; font-weight: bold; }
        .btn-clear { background-color: #95a5a6; color: white; border: none; padding: 0 25px; border-radius: 8px; cursor: pointer; font-weight: bold; }
        
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #27ae60; color: white; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #555; }
        
        .empty-msg { text-align: center; color: #999; padding: 40px; font-size: 1.1rem; }
        .back-link { margin-top: 30px; display: block; color: #27ae60; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
<div class="card">
    <h1>Medication Dispensed History</h1>
    
    <form class="search-bar" method="GET">
        <input type="text" name="query" class="search-input" placeholder="Search by Patient Name or ID...">
        <button type="submit" class="btn-search">Search</button>
        <button type="button" class="btn-clear" onclick="window.location.href='dispensed_history.jsp'">Clear</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>Patient ID</th>
                <th>Patient Name</th>
                <th>Medication/Advice Provided</th>
                <th>Date Completed</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                String search = request.getParameter("query");
                String sql = "SELECT * FROM patients WHERE status = 'Completed'";
                
                if (search != null && !search.isEmpty()) {
                    sql += " AND (full_name LIKE ? OR patient_id LIKE ?)";
                }
                
                PreparedStatement pst = con.prepareStatement(sql);
                if (search != null && !search.isEmpty()) {
                    pst.setString(1, "%" + search + "%");
                    pst.setString(2, "%" + search + "%");
                }
                
                ResultSet rs = pst.executeQuery();
                boolean found = false;
                while(rs.next()) {
                    found = true;
        %>
            <tr>
                <td>#<%= rs.getString("patient_id") %></td>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("doctor_advice") %></td>
                <td><%= rs.getTimestamp("registration_date") %></td>
            </tr>
        <% 
                } 
                if(!found) {
        %>
            <tr>
                <td colspan="4" class="empty-msg">No dispensing records found.</td>
            </tr>
        <%
                }
                con.close(); 
            } catch(Exception e) { out.print(e.getMessage()); } 
        %>
        </tbody>
    </table>

    <a href="pharmacist_dashboard.jsp" class="back-link">? Back to Dashboard</a>
</div>
</body>
</html>
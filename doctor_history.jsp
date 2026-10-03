<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Consultation History | Doctor</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; padding: 40px; margin: 0; }
        .container { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 1200px; margin: auto; }
        
        /* Header & Nav */
        .header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid #eee; padding-bottom: 15px; }
        h2 { color: #2c3e50; margin: 0; }
        .back-link { text-decoration: none; color: #3498db; font-weight: bold; display: flex; align-items: center; gap: 5px; }

        /* Table */
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #34495e; color: white; padding: 15px; text-align: left; font-size: 0.9rem; }
        td { padding: 15px; border-bottom: 1px solid #eee; font-size: 0.95rem; }
        tr:hover { background-color: #f9f9f9; }

        /* Buttons */
        .btn-group { display: flex; gap: 10px; }
        .btn { border: none; padding: 8px 14px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 0.85rem; transition: 0.3s; text-decoration: none; }
        
        /* Recall Button (New) */
        .btn-edit { background: #f39c12; color: white; }
        .btn-edit:hover { background: #e67e22; transform: translateY(-1px); }
        
        /* Clear Button */
        .btn-clear { background: #ecf0f1; color: #95a5a6; }
        .btn-clear:hover { background: #e74c3c; color: white; }

        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; }
        .status-lab { background: #e1f5fe; color: #0288d1; }
        .status-pharmacy { background: #e8f5e9; color: #2e7d32; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-box">
        <h2>Doctor's Patient History</h2>
        <a href="doctor_dashboard.jsp" class="back-link">? Back to Dashboard</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>Patient ID</th>
                <th>Full Name</th>
                <th>Current Location</th>
                <th>Registration Date</th>
                <th style="text-align: right;">Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                
                // Show patients who are NOT currently with the Doctor and NOT Archived
                String sql = "SELECT * FROM patients WHERE status != 'Doctor' AND status != 'Archived' ORDER BY registration_date DESC";
                ResultSet rs = con.createStatement().executeQuery(sql);
                
                while(rs.next()) {
                    String status = rs.getString("status");
                    String pid = rs.getString("patient_id");
        %>
            <tr>
                <td>#<%= pid %></td>
                <td><strong><%= rs.getString("full_name") %></strong></td>
                <td>
                    <span class="status-badge <%= status.equals("Lab") ? "status-lab" : "status-pharmacy" %>">
                        <%= status %>
                    </span>
                </td>
                <td><%= rs.getTimestamp("registration_date") %></td>
                <td style="text-align: right;">
                    <div class="btn-group" style="justify-content: flex-end;">
                        
                        <% if(status.equalsIgnoreCase("Lab")) { %>
                            <form action="process_doctor_action.jsp" method="POST" style="margin:0;">
                                <input type="hidden" name="patient_id" value="<%= pid %>">
                                <input type="hidden" name="is_recall" value="true">
                                <button type="submit" name="next_status" value="Doctor" class="btn btn-edit">
                                    ?? Recall to Edit
                                </button>
                            </form>
                        <% } %>

                        <form action="process_doctor_action.jsp" method="POST" onsubmit="return confirm('Archive this record?');" style="margin:0;">
                            <input type="hidden" name="patient_id" value="<%= pid %>">
                            <button type="submit" name="next_status" value="Archived" class="btn btn-clear">
                                Clear
                            </button>
                        </form>
                    </div>
                </td>
            </tr>
        <% 
                } 
                con.close(); 
            } catch(Exception e) { out.print("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>"); } 
        %>
        </tbody>
    </table>
</div>

</body>
</html>
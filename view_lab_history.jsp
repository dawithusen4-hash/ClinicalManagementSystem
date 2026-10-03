<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab History | Mattu Clinic</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; padding: 40px; margin: 0; }
        .container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); max-width: 1200px; margin: auto; }
        
        /* Modern Back Button Style */
        .back-nav { margin-bottom: 25px; }
        .btn-back { 
            text-decoration: none; 
            color: #d35400; 
            font-weight: 700; 
            display: inline-flex; 
            align-items: center; 
            gap: 10px; 
            padding: 8px 15px; 
            border: 2px solid #fad7bc; 
            border-radius: 50px; 
            transition: 0.3s; 
            font-size: 0.9rem;
        }
        .btn-back:hover { background: #fad7bc; transform: translateX(-5px); }

        .header-flex { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        h1 { color: #2c3e50; margin: 0; font-size: 1.8rem; border-left: 5px solid #d35400; padding-left: 15px; }
        
        /* Global Clear All Button styling */
        .btn-clear-all {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: 0.2s;
            font-size: 0.9rem;
        }
        .btn-clear-all:hover { background: #c0392b; box-shadow: 0 4px 10px rgba(231, 76, 60, 0.2); }

        table { width: 100%; border-collapse: collapse; background: white; }
        th { background: #fdf2e9; color: #d35400; padding: 15px; text-align: left; border-bottom: 2px solid #fad7bc; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #34495e; font-size: 0.95rem; }
        tr:hover { background-color: #fffaf5; }

        /* Action Buttons */
        .action-group { display: flex; gap: 8px; justify-content: flex-end; }
        .btn-sm { border: none; padding: 7px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; transition: 0.2s; font-size: 0.85rem; display: flex; align-items: center; gap: 5px; }
        
        .btn-recall { background: #e67e22; color: white; }
        .btn-recall:hover { background: #d35400; box-shadow: 0 3px 6px rgba(211, 84, 0, 0.2); }
        
        .btn-delete { background: #fff1f0; color: #e74c3c; border: 1px solid #ffa39e; }
        .btn-delete:hover { background: #e74c3c; color: white; }

        .date-text { color: #7f8c8d; font-size: 0.85rem; display: block; }
        .status-badge { background: #e1f5fe; color: #0288d1; padding: 4px 10px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; border: 1px solid #b3e5fc; }
        
        .alert-banner { padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; background: #dcfce7; color: #14532d; border: 1px solid #bbf7d0; }
    </style>
</head>
<body>

<div class="container">
    <div class="back-nav">
        <a href="lab_dashboard.jsp" class="btn-back">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"></path></svg>
            Return to Dashboard
        </a>
    </div>
    
    <div class="header-flex">
        <h1>Laboratory History Log</h1>
        
        <form action="process_lab_action.jsp" method="POST" onsubmit="return confirm('Are you sure you want to clear and archive ALL history logs from this table view?');" style="margin:0;">
            <input type="hidden" name="action_type" value="clear_all_history">
            <button type="submit" class="btn-clear-all">? Clear All History</button>
        </form>
    </div>

    <% if (request.getParameter("message") != null) { %>
        <div class="alert-banner">
            ? <%= java.net.URLDecoder.decode(request.getParameter("message"), "UTF-8") %>
        </div>
    <% } %>

    <table>
        <thead>
            <tr>
                <th>Submission Date</th>
                <th>Patient Details</th>
                <th>Status</th>
                <th style="text-align: right;">Management</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                    
                    // Sorting by registration_date to show newest first
                    String sql = "SELECT * FROM patients WHERE status != 'Lab' AND status != 'Archived' AND lab_result IS NOT NULL ORDER BY registration_date DESC";
                    ResultSet rs = con.createStatement().executeQuery(sql);
                    
                    boolean found = false;
                    while(rs.next()) {
                        found = true;
                        String pid = rs.getString("patient_id");
            %>
            <tr>
                <td>
                    <span class="date-text"><%= rs.getTimestamp("registration_date") %></span>
                </td>
                <td>
                    <strong><%= rs.getString("full_name") %></strong><br>
                    <small style="color: #95a5a6;">ID: #<%= pid %></small>
                </td>
                <td><span class="status-badge"><%= rs.getString("status") %> Received</span></td>
                <td>
                    <div class="action-group">
                        <form action="process_lab_action.jsp" method="POST" style="margin:0;">
                            <input type="hidden" name="patient_id" value="<%= pid %>">
                            <input type="hidden" name="is_recall" value="true">
                            <button type="submit" name="next_status" value="Lab" class="btn-sm btn-recall">
                                ?? Edit
                            </button>
                        </form>

                        <form action="process_lab_action.jsp" method="POST" style="margin:0;" onsubmit="return confirm('Remove this specific record from view?');">
                            <input type="hidden" name="patient_id" value="<%= pid %>">
                            <input type="hidden" name="action_type" value="individual_clear">
                            <button type="submit" class="btn-sm btn-delete">
                                ?? Clear
                            </button>
                        </form>
                    </div>
                </td>
            </tr>
            <% 
                    } 
                    if(!found) {
                        out.print("<tr><td colspan='4' style='text-align:center; color:#95a5a6; padding:50px;'>No processed records found.</td></tr>");
                    }
                    con.close(); 
                } catch(Exception e) { out.print("<tr><td colspan='4' style='color:red;'>Error: " + e.getMessage() + "</td></tr>"); } 
            %>
        </tbody>
    </table>
</div>

</body>
</html>
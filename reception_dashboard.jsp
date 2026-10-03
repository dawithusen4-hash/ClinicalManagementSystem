<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session Management
    String user = (String) session.getAttribute("username"); 
    if (user == null) user = (String) session.getAttribute("userName");
    if (user == null) user = "Receptionist"; 
    
    // Status Notifications
    String msg = request.getParameter("status");
    String patientIdMsg = request.getParameter("id");

    // --- LOGIC: CLEAR HISTORY ---
    String action = request.getParameter("action");
    if("clearHistory".equals(action)) {
        Connection clearCon = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            clearCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            String clearSql = "DELETE FROM patients WHERE status NOT IN ('Reception', 'Registered', '') AND status IS NOT NULL";
            PreparedStatement clearPst = clearCon.prepareStatement(clearSql);
            clearPst.executeUpdate();
            response.sendRedirect("reception_dashboard.jsp?status=cleared");
            return;
        } catch(Exception e) {
            out.print("Error: " + e.getMessage());
        } finally {
            if(clearCon != null) clearCon.close();
        }
    }

    // --- LOGIC: RECALL & EDIT ---
    String recallId = request.getParameter("recallId");
    if(recallId != null) {
        Connection recallCon = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            recallCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            // Move status back to 'Registered' to put them back in the top list
            String recallSql = "UPDATE patients SET status = 'Registered' WHERE patient_id = ?";
            PreparedStatement recallPst = recallCon.prepareStatement(recallSql);
            recallPst.setString(1, recallId);
            recallPst.executeUpdate();
            response.sendRedirect("reception_dashboard.jsp?status=recalled");
            return;
        } catch(Exception e) {
            out.print("Error: " + e.getMessage());
        } finally {
            if(recallCon != null) recallCon.close();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard | Mattu Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; display: flex; background-color: #f8fafc; color: #334155; }
        
        /* Navigation Sidebar (Matches Admin Panel Theme) */
        .sidebar { width: 260px; height: 100vh; background: #0f172a; color: white; padding: 30px 20px; position: fixed; z-index: 1000; box-sizing: border-box; }
        .sidebar h2 { color: #38bdf8; margin: 0 0 35px 0; font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .sidebar a { display: block; color: #94a3b8; padding: 12px 15px; text-decoration: none; border-radius: 8px; margin-bottom: 8px; font-weight: 500; transition: all 0.2s ease; cursor: pointer; }
        .sidebar a:hover { color: white; background: #1e293b; padding-left: 20px; }
        .sidebar a.active { background: #38bdf8; color: #0f172a; font-weight: 600; }
        .sidebar a.signout { color: #f87171; margin-top: 40px; border: 1px solid rgba(248, 113, 113, 0.2); }
        .sidebar a.signout:hover { background: rgba(248, 113, 113, 0.1); color: #fca5a5; }
        
        /* Layout Structure Wrapper */
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); box-sizing: border-box; }
        
        /* Modern Alerts Banner Styles */
        .alert { padding: 15px 20px; border-radius: 12px; margin-bottom: 25px; border: 1px solid; font-size: 0.95rem; font-weight: 500; }
        .alert-success { background-color: #dcfce7; color: #166534; border-color: #bbf7d0; }
        .alert-warning { background-color: #fef3c7; color: #92400e; border-color: #fde68a; }
        
        /* Greeting Segment Card (Welcome Box) */
        .welcome-section { 
            background: white; padding: 30px; border-radius: 16px; margin-bottom: 30px; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.01);
            border-left: 6px solid #38bdf8;
            display: flex; justify-content: space-between; align-items: center;
        }
        .welcome-section h1 { margin: 0 0 8px 0; color: #1e293b; font-size: 1.75rem; font-weight: 700; }
        .welcome-section p { color: #64748b; font-size: 1rem; margin: 0; line-height: 1.5; }

        /* Professional Action Elements */
        .btn-add { background: #10b981; color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 0.95rem; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); transition: all 0.2s; }
        .btn-add:hover { background: #059669; transform: translateY(-2px); }
        
        .btn-send { background: #f59e0b; color: white; padding: 8px 16px; border-radius: 6px; border: none; cursor: pointer; font-weight: 600; font-size: 0.85rem; transition: background 0.2s; }
        .btn-send:hover { background: #d97706; }
        
        .btn-recall { background: #3b82f6; color: white; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-size: 0.8rem; font-weight: 600; transition: all 0.2s; display: inline-block; }
        .btn-recall:hover { background: #2563eb; transform: scale(1.03); }

        .btn-clear { background: #ef4444; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 0.85rem; font-weight: 600; transition: background 0.2s; }
        .btn-clear:hover { background: #dc2626; }

        /* Data Tables Layout Container */
        .table-container { background: white; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; overflow: hidden; margin-bottom: 35px; }
        .table-container { background: white; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; overflow: hidden; margin-bottom: 35px; }
        .table-header { padding: 20px 25px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .table-header h2 { margin: 0; font-size: 1.1rem; color: #1e293b; font-weight: 600; }
        
        h3.section-title { font-size: 1.2rem; color: #1e293b; font-weight: 600; margin: 0 0 15px 0; padding-left: 5px; }
        
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background-color: #f8fafc; color: #64748b; padding: 16px 25px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #e2e8f0; }
        td { padding: 16px 25px; font-size: 0.95rem; border-bottom: 1px solid #e2e8f0; color: #334155; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: #f8fafc; }
        
        /* Badges Formatting Components */
        .status-badge { padding: 5px 12px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; background: #e0f2fe; color: #0369a1; display: inline-block; text-transform: uppercase; }
        .dept-badge { font-weight: 500; color: #475569; background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-size: 0.85rem; }

        /* Animation Drop-down Wrapper for Archival logs */
        #history-section { display: none; margin-top: 35px; animation: fadeIn 0.4s ease forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
    <script>
        function toggleHistory() {
            var section = document.getElementById("history-section");
            if (section.style.display === "block") {
                section.style.display = "none";
            } else {
                section.style.display = "block";
                window.scrollTo({ top: section.offsetTop, behavior: 'smooth' });
            }
        }
        function confirmRecall() {
            return confirm("Move this patient back to active registry for editing?");
        }
    </script>
</head>
<body>

<div class="sidebar">
    <h2>🏥 Mattu Clinic</h2>
    <a href="reception_dashboard.jsp" class="active">Patient Registry</a>
    <a href="register_patient.jsp">Register New Patient</a>
    <a onclick="toggleHistory()">View Registry History</a>
    <a href="view_appointments.jsp">View Appointments</a>
    <a href="login.html" style="color: #f87171; margin-top: 50px;">Logout</a>
</div>

<div class="main-content">
    <%-- Status Feedback Banners --%>
    <% if("sent".equals(msg)) { %>
        <div class="alert alert-success"><strong>Success!</strong> Patient #<%= patientIdMsg %> forwarded to Doctor.</div>
    <% } %>
    <% if("recalled".equals(msg)) { %>
        <div class="alert alert-warning"><strong>Recalled!</strong> Patient record moved back to active list for editing.</div>
    <% } %>
    <% if("cleared".equals(msg)) { %>
        <div class="alert alert-warning"><strong>Cleared!</strong> Registry archival history logs dropped successfully.</div>
    <% } %>

    <div class="welcome-section">
        <div>
            <h1>Master Patient Registry</h1>
            <p>Welcome back, Receptionist: <strong><%= user %></strong></p>
        </div>
        <a href="register_patient.jsp" class="btn-add">+ Register New Patient</a>
    </div>

    <h3 class="section-title">Active Registry (Pending Action)</h3>
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Patient ID</th>
                    <th>Full Name</th>
                    <th>Age/Sex</th>
                    <th>Department</th>
                    <th>Action</th> 
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                        
                        // FIXED: Changed ORDER BY from registration_date to patient_id DESC
                        String sql = "SELECT * FROM patients WHERE (status IS NULL OR status = '' OR status = 'Reception' OR LOWER(status) = 'registered') ORDER BY patient_id DESC";
                        PreparedStatement pst = con.prepareStatement(sql);
                        ResultSet rs = pst.executeQuery();
                        boolean hasActive = false;
                        while(rs.next()) {
                            hasActive = true;
                            String pId = rs.getString("patient_id");
                %>
                <tr>
                    <td><strong>#<%= pId %></strong></td>
                    <td><strong><%= rs.getString("full_name") %></strong></td>
                    <td><%= rs.getInt("age") %> / <span style="text-transform: uppercase;"><%= rs.getString("sex") %></span></td>
                    <td><span class="dept-badge"><%= rs.getString("department") %></span></td>
                    <td>
                        <form action="send_to_doctor.jsp" method="POST" style="margin:0;">
                            <input type="hidden" name="patient_id" value="<%= pId %>">
                            <button type="submit" class="btn-send">Send to Doctor</button>
                        </form>
                    </td>
                </tr>
                <% 
                        } 
                        if(!hasActive) {
                %>
                <tr>
                    <td colspan="5" style="text-align:center; color: #64748b; padding:30px;">No active patients.</td>
                </tr>
                <% 
                        } 
                %>
            </tbody>
        </table>
    </div>

    <div id="history-section">
        <div class="table-container" style="border-top: 5px solid #0f172a;">
            <div class="table-header">
                <h2>Recently Processed (History)</h2>
                <a href="reception_dashboard.jsp?action=clearHistory" class="btn-clear" onclick="return confirm('Delete all history?')">Clear All</a>
            </div>
            <table>
                <thead>
                    <tr class="history-header">
                        <th>Patient ID</th>
                        <th>Full Name</th>
                        <th>Current Status</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // FIXED: Changed ORDER BY from registration_date to patient_id DESC
                        PreparedStatement pstHist = con.prepareStatement("SELECT * FROM patients WHERE status NOT IN ('Reception', 'Registered', '') AND status IS NOT NULL ORDER BY patient_id DESC LIMIT 10");
                        ResultSet rsHist = pstHist.executeQuery();
                        boolean hasHistory = false;
                        while(rsHist.next()) {
                            hasHistory = true;
                            String hId = rsHist.getString("patient_id");
                    %>
                    <tr>
                        <td>#<%= hId %></td>
                        <td><strong><%= rsHist.getString("full_name") %></strong></td>
                        <td><span class="status-badge">At: <%= rsHist.getString("status") %></span></td>
                        <td style="text-align: right;">
                            <a href="reception_dashboard.jsp?recallId=<%= hId %>" class="btn-recall" onclick="return confirmRecall()">
                                ↺ Recall & Edit
                            </a>
                        </td>
                    </tr>
                    <% 
                        }
                        if(!hasHistory) {
                    %>
                    <tr>
                        <td colspan="4" style="text-align:center; color: #64748b; padding:30px;">No history records available.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <%
        } catch(Exception e) { 
            out.print("<div class='alert alert-warning'>Error processing request: " + e.getMessage() + "</div>"); 
        } finally { 
            if(con != null) con.close(); 
        }
    %>
</div>
</body>
</html>
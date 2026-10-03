
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab Dashboard | Manage Results</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; display: flex; background-color: #f8fafc; color: #334155; }
        
        /* Navigation Sidebar (Unified across roles) */
        .sidebar { width: 260px; height: 100vh; background: #0f172a; color: white; padding: 30px 20px; position: fixed; z-index: 1000; box-sizing: border-box; display: flex; flex-direction: column; }
        .sidebar h2 { color: #38bdf8; margin: 0; font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .sub-title { font-size: 0.8rem; font-weight: 600; letter-spacing: 0.05em; text-transform: uppercase; color: #94a3b8; margin: 5px 0 35px 0; display: block; }
        
        .sidebar-nav-top { display: flex; flex-direction: column; gap: 10px; }
        .role-tag { padding: 12px 15px; font-size: 0.85rem; color: #38bdf8; font-weight: 600; border-left: 4px solid #38bdf8; background: #1e293b; border-radius: 6px; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.03em; }
        
        .nav-link { display: block; color: #94a3b8; padding: 12px 15px; text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.2s ease; cursor: pointer; }
        .nav-link:hover { color: white; background: #1e293b; padding-left: 20px; }
        .nav-link.active { background: #38bdf8; color: #0f172a; font-weight: 600; }
        
        /* Logout button within navigation layout */
        .nav-logout { color: #f87171 !important; margin-top: 40px; border: 1px solid rgba(248, 113, 113, 0.2); }
        .nav-logout:hover { background: rgba(248, 113, 113, 0.1) !important; color: #fca5a5 !important; }

        /* Main Content Layout Structure */
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); box-sizing: border-box; }
        
        /* Greeting Segment Card (Welcome Box) */
        .welcome-banner { 
            background: white; padding: 30px; border-radius: 16px; margin-bottom: 30px; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.01);
            border-left: 6px solid #e67e22; /* Lab Orange accent bar */
        }
        .welcome-banner h2 { margin: 0 0 8px 0; color: #1e293b; font-size: 1.75rem; font-weight: 700; }
        .welcome-banner p { color: #64748b; font-size: 1rem; margin: 0; line-height: 1.5; }

        /* Structural Content Titles */
        h1.section-main-title { font-size: 1.8rem; color: #0f172a; font-weight: 700; margin: 0 0 25px 0; }
        h3.section-title { font-size: 1.2rem; color: #1e293b; font-weight: 600; margin: 0 0 15px 0; padding-left: 2px; }
        
        /* Search Box Components */
        .search-container { background: white; padding: 15px; border-radius: 12px; margin-bottom: 30px; display: flex; gap: 12px; align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; }
        .search-input { padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 8px; flex-grow: 1; font-family: inherit; font-size: 0.95rem; color: #334155; outline: none; transition: border-color 0.2s; }
        .search-input:focus { border-color: #e67e22; }
        .btn-search { background: #0f172a; color: white; border: none; padding: 12px 24px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 0.95rem; transition: background 0.2s; }
        .btn-search:hover { background: #1e293b; }
        
        /* Comprehensive Case Request Cards */
        .card { background: white; border-radius: 16px; padding: 30px; margin-bottom: 25px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; }
        .pending-card { border-top: 5px solid #e67e22; }
        .card h4 { margin: 0 0 15px 0; font-size: 1.2rem; color: #0f172a; font-weight: 700; }
        
        /* Contextual Instructions Container */
        .doctor-instruction-box { background: #f0fdf4; border: 1px solid #bbf7d0; padding: 20px; border-radius: 12px; margin-bottom: 20px; }
        .instruction-label { font-weight: 600; color: #166534; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 6px; }
        
        /* Form Variables Input Formatting */
        textarea { width: 100%; height: 110px; margin-top: 10px; padding: 14px; border-radius: 8px; border: 1px solid #cbd5e1; box-sizing: border-box; font-family: inherit; font-size: 0.95rem; color: #334155; resize: vertical; outline: none; transition: border-color 0.2s; }
        textarea:focus { border-color: #e67e22; }
        
        .btn { padding: 14px 20px; border: none; border-radius: 8px; cursor: pointer; color: white; font-weight: 600; font-size: 1rem; width: 100%; margin-top: 15px; box-shadow: 0 4px 12px rgba(230, 126, 34, 0.15); transition: all 0.2s; }
        .btn-send { background: #e67e22; }
        .btn-send:hover { background: #d35400; transform: translateY(-1px); }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>🏥 Mattu Clinic</h2>
    <span class="sub-title">Laboratory System</span>
    
    <div class="sidebar-nav-top">
        <div class="role-tag">Role: <strong>Technician</strong></div>
        <a href="lab_dashboard.jsp" class="nav-link active">Active Requests</a>
        <a href="view_lab_history.jsp" class="nav-link">View Full History</a>
        <a href="login.html" class="nav-link nav-logout">Logout</a>
    </div>
</div>

<div class="main-content">
    <div class="welcome-banner">
        <h2>Welcome back, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Technician" %>!</h2>
        <p>Laboratory Information System Pipeline | System Node Status: <b style="color: #10b981;">Online Live</b></p>
    </div>

    <h1 class="section-main-title">Laboratory Management Triage</h1>

    <form method="GET" action="lab_dashboard.jsp" class="search-container">
        <input type="text" name="search" class="search-input" placeholder="Search missing worklist queue by patient name or record sequence reference ID..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit" class="btn-search">Search Queue</button>
    </form>

    <h3 class="section-title">New Test Requests (Pending)</h3>
    <%
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            
            String search = request.getParameter("search");
            String sql = "SELECT * FROM patients WHERE status = 'Lab'";
            
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (full_name LIKE ? OR patient_id LIKE ?)";
            }
            sql += " ORDER BY registration_date ASC";

            PreparedStatement pst = con.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                pst.setString(1, "%" + search + "%");
                pst.setString(2, "%" + search + "%");
            }
            
            ResultSet rs = pst.executeQuery();
            boolean hasPending = false;
            while(rs.next()) {
                hasPending = true;
                String pid = rs.getString("patient_id");
                String name = rs.getString("full_name");
                String docAdvice = rs.getString("doctor_advice"); 
    %>
        <div class="card pending-card">
            <h4>Patient: <%= name %> <span style="font-weight: 400; color: #64748b; font-size: 0.95rem;">(Record Reference ID: #<%= pid %>)</span></h4>
            
            <div class="doctor-instruction-box">
                <span class="instruction-label">🔬 Outpatient Diagnostic Order Instructions:</span>
                <p style="margin: 5px 0 0; color: #1e293b; font-style: italic; font-size: 0.95rem; line-height: 1.6;">
                    <%= (docAdvice != null && !docAdvice.isEmpty()) ? docAdvice : "No structural instructions provided by referring unit." %>
                </p>
            </div>

            <form action="process_lab_action.jsp" method="POST">
                <input type="hidden" name="patient_id" value="<%= pid %>">
                <textarea name="lab_result" required placeholder="Draft chemical metrics, complete blood counts, physical lab analysis profiles here..."></textarea>
                <button type="submit" name="next_status" value="Doctor" class="btn btn-send">Submit Results to Doctor</button>
            </form>
        </div>
    <% 
            } 
            if(!hasPending) {
                out.print("<div style='padding:40px; text-align:center; background:white; border:1px solid #e2e8f0; border-radius:12px; color:#64748b; font-style: italic;'>No pending lab test requisition items found in database buffer.</div>");
            }
            con.close();
        } catch(Exception e) { 
            out.print("<div class='alert' style='background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; padding:20px; border-radius:12px;'>Error executing query request syntax parameters: " + e.getMessage() + "</div>"); 
        } 
    %>
</div>
</body>
</html>

```
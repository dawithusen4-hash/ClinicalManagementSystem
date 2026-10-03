<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pharmacy Dashboard | Control Center</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; display: flex; background-color: #f8fafc; color: #334155; }
        /* Unified Navigation Sidebar */
        .sidebar { width: 260px; height: 100vh; background: #0f172a; color: white; padding: 30px 20px; position: fixed; z-index: 1000; box-sizing: border-box; display: flex; flex-direction: column; }
        .sidebar h2 { color: #10b981; margin: 0; font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .sub-title { font-size: 0.8rem; font-weight: 600; letter-spacing: 0.05em; text-transform: uppercase; color: #94a3b8; margin: 5px 0 35px 0; display: block; }
        
        .sidebar-nav { display: flex; flex-direction: column; gap: 10px; }
        .role-tag { padding: 12px 15px; font-size: 0.85rem; color: #10b981; font-weight: 600; border-left: 4px solid #10b981; background: #1e293b; border-radius: 6px; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.03em; }
        
        .sidebar a { display: block; color: #94a3b8; padding: 12px 15px; text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.2s ease; cursor: pointer; }
        .sidebar a:hover { color: white; background: #1e293b; padding-left: 20px; }
        .sidebar a.active { background: #10b981; color: #0f172a; font-weight: 600; }
        
        .sidebar a.signout { color: #f87171 !important; margin-top: 40px; border: 1px solid rgba(248, 113, 113, 0.2); }
        .sidebar a.signout:hover { background: rgba(248, 113, 113, 0.1) !important; color: #fca5a5 !important; }

        /* Workspace Main Layout Framework */
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); box-sizing: border-box; }
        
        /* Premium Greeting Section Banner */
        .welcome-section { 
            background: white; padding: 30px; border-radius: 16px; margin-bottom: 30px; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.01);
            border-left: 6px solid #10b981;
        }
        .welcome-section h1 { margin: 0 0 8px 0; color: #1e293b; font-size: 1.75rem; font-weight: 700; }
        .welcome-section p { color: #64748b; font-size: 1rem; margin: 0; line-height: 1.5; }

        /* Section Titles */
        h1.section-main-title { font-size: 1.8rem; color: #0f172a; font-weight: 700; margin: 0 0 25px 0; }
        h3.section-title { font-size: 1.2rem; color: #1e293b; font-weight: 600; margin: 25px 0 15px 0; padding-left: 2px; }
        
        /* Interactive Search Engine Container */
        .search-container { background: white; padding: 15px; border-radius: 12px; margin-bottom: 30px; display: flex; gap: 12px; align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; }
        .search-input { padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 8px; flex-grow: 1; font-family: inherit; font-size: 0.95rem; color: #334155; outline: none; transition: border-color 0.2s; }
        .search-input:focus { border-color: #10b981; }
        .btn-search { background: #0f172a; color: white; border: none; padding: 12px 24px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 0.95rem; transition: background 0.2s; }
        .btn-search:hover { background: #1e293b; }
        
        /* Queue Dispatcher Information Cards */
        .card { background: white; border-radius: 16px; padding: 30px; margin-bottom: 25px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; border-top: 5px solid #10b981; }
        .card h4 { margin: 0 0 15px 0; font-size: 1.2rem; color: #0f172a; font-weight: 700; }
        
        /* Prescription Details Box Container */
        .prescription-box { background: #f0fdf4; border: 1px dashed #a7f3d0; padding: 20px; border-radius: 12px; margin-bottom: 20px; }
        .prescription-label { font-weight: 600; color: #065f46; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 6px; }
        .prescription-text { margin: 0; color: #1e293b; font-size: 1rem; line-height: 1.6; font-weight: 500; }

        /* Form Submissions Interactive Component */
        .btn-complete { background: #10b981; color: white; border: none; padding: 14px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 1rem; width: 100%; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15); transition: all 0.2s; }
        .btn-complete:hover { background: #059669; transform: translateY(-1px); }
    </style>
</head>
<body>
<div class="sidebar">
    <h2>🏥 Mattu Clinic</h2>
    <span class="sub-title">Pharmacy System</span>
    
    <div class="sidebar-nav">
        <div class="role-tag">Role: <strong>Pharmacist</strong></div>
        <a href="pharmacist_dashboard.jsp" class="active">Medication Queue</a>
        <a href="dispensed_history.jsp">Dispensed History</a>
        <a href="view_inventory.jsp">Medicine Inventory</a>
        <a href="save_medicine.jsp">Register Medicine</a>
        <a href="login.html" class="signout">Sign Out</a>
    </div>
</div>

<div class="main-content">
    <div class="welcome-section">
        <h1>Pharmacist Control Center</h1>
        <p>Manage the dynamic medication queue and fulfill incoming client medical prescriptions.</p>
        <p style="font-size: 0.95rem; color: #64748b; margin-top: 10px;">
            Welcome Dr. <strong style="color: #0f172a;"><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Pharmacist Specialist" %></strong>
        </p>
    </div>

    <h1 class="section-main-title">Pharmacy Pipeline Processing</h1>

    <form method="GET" action="pharmacist_dashboard.jsp" class="search-container">
        <input type="text" name="search" class="search-input" placeholder="Search pharmacy queue using patient full name string or data record reference ID..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit" class="btn-search">Search Queue</button>
    </form>

    <h3 class="section-title">Inbound Active Prescriptions Queue</h3>

    <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            String search = request.getParameter("search");
            String sql = "SELECT * FROM patients WHERE status = 'Pharmacy'";
            
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (full_name LIKE ? OR patient_id LIKE ?)";
            }
            
            sql += " ORDER BY patient_id DESC";
            
            PreparedStatement pst = con.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                pst.setString(1, "%" + search + "%");
                pst.setString(2, "%" + search + "%");
            }
            
            ResultSet rs = pst.executeQuery();
            if (!rs.isBeforeFirst()) {
                out.print("<div style='padding:40px; text-align:center; background:white; border:1px solid #e2e8f0; border-radius:12px; color:#64748b; font-style: italic;'>No patient profiles are currently matched waiting in the pharmacy dispensing buffer database array.</div>");
            }
            
            // Loop runs over matching pharmacy items
            while(rs.next()) {
    %>
        <div class="card">
            <h4>Patient: <%= rs.getString("full_name") %> <span style="font-weight: 400; color: #64748b; font-size: 0.95rem;">(System ID Match: #<%= rs.getString("patient_id") %>)</span></h4>
            
            <div class="prescription-box">
                <span class="prescription-label">💊 Attending Physician Clinical Orders & Prescription:</span>
                <p class="prescription-text">
                    <%= rs.getString("doctor_advice") != null ? rs.getString("doctor_advice") : "<i>No prescriptions provided.</i>" %>
                </p>
            </div>
            
            <form action="process_doctor_action.jsp" method="POST">
                <input type="hidden" name="patient_id" value="<%= rs.getString("patient_id") %>">
                <button type="submit" name="next_status" value="Completed" class="btn-complete">Confirm Stock Allocation & Dispense Complete</button>
            </form>
        </div>
    <% 
            } // FIXED: Added missing closing bracket for the while loop iteration sequence
            con.close(); 
        } catch(Exception e) { 
            out.print("<div style='background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; padding:20px; border-radius:12px;'>Critical pipeline SQL loop parsing transaction exception structural error: " + e.getMessage() + "</div>"); 
        } 
    %>
</div>
</body>
</html>
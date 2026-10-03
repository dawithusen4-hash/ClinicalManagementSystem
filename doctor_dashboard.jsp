<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard | Mattu Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; display: flex; background-color: #f8fafc; color: #334155; }
        
        /* Navigation Sidebar (Matches Admin & Reception Theme) */
        .sidebar { width: 260px; height: 100vh; background: #0f172a; color: white; padding: 30px 20px; position: fixed; z-index: 1000; box-sizing: border-box; }
        .sidebar h2 { color: #38bdf8; margin: 0 0 5px 0; font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .sidebar p { margin: 0 0 35px 0; font-size: 0.8rem; font-weight: 600; letter-spacing: 0.05em; text-transform: uppercase; }
        .sidebar a { display: block; color: #94a3b8; padding: 12px 15px; text-decoration: none; border-radius: 8px; margin-bottom: 8px; font-weight: 500; transition: all 0.2s ease; cursor: pointer; }
        .sidebar a:hover { color: white; background: #1e293b; padding-left: 20px; }
        .sidebar a.active { background: #38bdf8; color: #0f172a; font-weight: 600; }
        .sidebar a.signout { color: #f87171; margin-top: 40px; border: 1px solid rgba(248, 113, 113, 0.2); }
        .sidebar a.signout:hover { background: rgba(248, 113, 113, 0.1); color: #fca5a5; }
        
        /* Layout Structure Wrapper */
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); box-sizing: border-box; }
        
        /* Greeting Segment Card (Welcome Box) */
        .welcome-section { 
            background: white; padding: 30px; border-radius: 16px; margin-bottom: 30px; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.01);
            border-left: 6px solid #38bdf8;
        }
        .welcome-section h1, .welcome-section h2 { margin: 0 0 8px 0; color: #1e293b; font-size: 1.75rem; font-weight: 700; }
        .welcome-section p { color: #64748b; font-size: 1rem; margin: 0; line-height: 1.5; }

        /* Structural Page Title Header */
        h1.section-title { font-size: 1.3rem; color: #1e293b; font-weight: 600; margin: 0 0 20px 0; padding-left: 2px; text-transform: uppercase; letter-spacing: 0.03em; }

        /* Unified Search Bar Elements */
        .search-container { background: white; padding: 15px; border-radius: 12px; margin-bottom: 30px; display: flex; gap: 12px; align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; }
        .search-input { padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 8px; flex-grow: 1; font-family: inherit; font-size: 0.95rem; color: #334155; outline: none; transition: border-color 0.2s; }
        .search-input:focus { border-color: #38bdf8; }
        .btn-search { background: #0f172a; color: white; border: none; padding: 12px 24px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 0.95rem; transition: background 0.2s; }
        .btn-search:hover { background: #1e293b; }
        
        /* Modern Comprehensive Patient Record Cards */
        .patient-card { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); margin-bottom: 30px; border: 1px solid #e2e8f0; border-top: 5px solid #38bdf8; }
        .patient-name { font-size: 1.4rem; font-weight: 700; color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        
        /* Modular Info Display Grids */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; background: #f8fafc; padding: 20px; border-radius: 12px; margin-bottom: 25px; border: 1px solid #f1f5f9; }
        .label { font-weight: 600; color: #64748b; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 4px; display: block; }
        .value { color: #1e293b; font-size: 1rem; font-weight: 500; }
        
        /* Tailored Laboratory Findings Box */
        .lab-result-box { 
            background: #fffbeb; 
            border: 1px solid #fef3c7; 
            padding: 20px; 
            border-radius: 12px; 
            margin: 25px 0; 
        }
        .lab-text { color: #d97706; font-weight: 500; font-size: 1rem; line-height: 1.6; margin-top: 6px; }

        /* Form Interaction Fields UI */
        textarea { width: 100%; padding: 14px; border-radius: 8px; border: 1px solid #cbd5e1; margin: 10px 0 25px 0; box-sizing: border-box; font-family: inherit; font-size: 0.95rem; color: #334155; resize: vertical; outline: none; transition: border-color 0.2s; }
        textarea:focus { border-color: #38bdf8; }
        
        select { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #cbd5e1; background-color: white; margin: 10px 0 25px 0; box-sizing: border-box; font-family: inherit; font-size: 0.95rem; color: #334155; outline: none; font-weight: 500; }
        select:focus { border-color: #38bdf8; }

        .btn-submit { background: #10b981; color: white; border: none; padding: 14px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 1rem; width: 100%; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15); transition: all 0.2s; }
        .btn-submit:hover { background: #059669; transform: translateY(-1px); }

        .badge-id { font-size: 0.9rem; color: #64748b; font-weight: 400; }
        .dept-badge { font-weight: 600; color: #0369a1; background: #e0f2fe; padding: 4px 10px; border-radius: 6px; font-size: 0.85rem; display: inline-block; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>🏥 Mattu Clinic</h2>
    <p style="color: #38bdf8;">Certified Doctor</p>
    <a href="doctor_dashboard.jsp" class="active">Dashboard</a>
    <a href="doctor_history.jsp">View History</a>
    <a href="consult_patient.jsp">Consultation Room</a>
    <a href="book_appointment.jsp">Give Appointment</a>
    <a href="login.html" class="signout">Logout</a>
</div>

<div class="main-content">
    <div class="welcome-section">
        <h2>Welcome Dr. <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Professional" %>!</h2>
        <p>Consultation Outpatient Division Room | Status System State: <strong style="color: #10b981;">Active Live Connection</strong></p>
    </div>

    <h1 class="section-title">Patient Consultation Triage List</h1>
    
    <form method="GET" action="doctor_dashboard.jsp" class="search-container">
        <input type="text" name="search" class="search-input" placeholder="Search incoming triage patient by name or unique patient medical system record id sequence..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit" class="btn-search">Search Patient</button>
    </form>

    <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            
            String search = request.getParameter("search");
            // The query still filters for 'Doctor' because that's where the receptionist forwards them!
            String query = "SELECT * FROM patients WHERE status = 'Doctor'";
            
            if (search != null && !search.trim().isEmpty()) {
                query += " AND (full_name LIKE ? OR patient_id LIKE ?)";
            }
            
            // FIXED: Standardized ordering sequence to use our text primary key layout sequence
            query += " ORDER BY patient_id DESC";
            
            PreparedStatement pst = con.prepareStatement(query);
            if (search != null && !search.trim().isEmpty()) {
                pst.setString(1, "%" + search + "%");
                pst.setString(2, "%" + search + "%");
            }
            
            ResultSet rs = pst.executeQuery();
            boolean hasPatients = false;
            while(rs.next()) {
                hasPatients = true;
                String labResult = rs.getString("lab_result");
    %>
        <div class="patient-card">
            <div class="patient-name">
                <%= rs.getString("full_name") %> <span class="badge-id">&nbsp;(Record ID: #<%= rs.getString("patient_id") %>)</span>
            </div>
            
            <div class="info-grid">
                <div>
                    <span class="label">Patient Age / Gender Structure</span>
                    <div class="value"><%= rs.getString("age") %> Years &bull; <span style="text-transform: uppercase;"><%= rs.getString("sex") %></span></div>
                </div>
                <div>
                    <span class="label">Assigned Target Department</span>
                    <div class="value"><span class="dept-badge"><%= rs.getString("department") %></span></div>
                </div>
            </div>

            <div class="lab-result-box">
                <span class="label">Checked Laboratory Diagnostic Findings Summary</span>
                <div class="lab-text">
                    <%= (labResult != null && !labResult.isEmpty()) ? labResult : "<i>No laboratory diagnostics structural metric data submitted for this patient profile loop record yet.</i>" %>
                </div>
            </div>
            
            <form action="process_doctor_action.jsp" method="POST">
                <input type="hidden" name="patient_id" value="<%= rs.getString("patient_id") %>">
                
                <span class="label">Doctor's Clinical Observations, Advice & Prescription Form Data</span>
                <textarea name="doctor_advice" rows="4" placeholder="Draft treatment protocols, pharmaceutical medications, clinical request descriptions here..." required></textarea>
                
                <span class="label">Select Next Stage Pipeline Step Status</span>
                <select name="next_status">
                    <option value="Lab">Lab (Request More Specialized Lab Diagnostics Tests)</option>
                    <option value="Pharmacy">Pharmacy (Fulfill Operational Pharmaceutical Medication Prescriptions)</option>
                    <option value="Completed">Discharge Patient (Treatment Registry Flow Cycle Finished Complete)</option>
                </select>
                
                <button type="submit" class="btn-submit">Submit Decisions & Forward Patient Registry Record</button>
            </form>
        </div>
    <% 
            } 
            if(!hasPatients) {
                out.println("<div style='text-align:center; padding:60px 20px; background:white; border-radius:16px; border:1px solid #e2e8f0; color:#64748b;'><h3>Your consultation queue dashboard is currently completely empty. No inbound active patient profiles require tracking evaluations right now.</h3></div>");
            }
            con.close(); 
        } catch(Exception e) { 
            out.print("<div class='alert' style='background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; padding:20px; border-radius:12px;'>Operational Exception Interruption Occurred parsing index parameter variables: " + e.getMessage() + "</div>"); 
        } 
    %>
</div>
</body>
</html>
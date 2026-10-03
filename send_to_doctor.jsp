<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. Retrieve form data sent from the dashboard button
    String patientId = request.getParameter("patient_id");

    // Check if patientId is missing to avoid NullPointerException crashes
    if (patientId == null || patientId.trim().isEmpty()) {
        response.sendRedirect("reception_dashboard.jsp?status=error&id=Missing_ID");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;

    try {
        // 2. Initialize Database Drivers and Establish Connection
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

        // 3. Update status query to route the patient to the Doctor queue
        String sql = "UPDATE patients SET status = 'Doctor' WHERE patient_id = ?";
        pst = con.prepareStatement(sql);
        pst.setString(1, patientId);

        int rowsUpdated = pst.executeUpdate();

        // 4. Evaluate execution outcomes and redirect with clear notifications
        if (rowsUpdated > 0) {
            // Success: matches the 'sent' parameter expected by your reception dashboard banner
            response.sendRedirect("reception_dashboard.jsp?status=sent&id=" + java.net.URLEncoder.encode(patientId, "UTF-8"));
        } else {
            // FIXED: Matches parameter names so the receptionist dashboard handles the mismatch gracefully
            response.sendRedirect("reception_dashboard.jsp?status=error&id=" + java.net.URLEncoder.encode(patientId, "UTF-8"));
        }

    } catch (Exception e) {
        // Fallback exception capture block in case of unexpected SQL errors
        out.print("<html><head><title>Database Transaction Failure</title>");
        out.print("<link href='https://fonts.googleapis.com/css2?family=Poppins:wght=400;600&display=swap' rel='stylesheet'>");
        out.print("<style>body{font-family:'Poppins',sans-serif; background:#f8fafc; padding:40px; color:#334155;} .err-card{background:white; padding:30px; border-radius:12px; border-left:5px solid #ef4444; max-width:600px; box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);}</style></head><body>");
        out.print("<div class='err-card'><h2>⚠️ Database Transaction Failure</h2>");
        out.print("<p>An exception prevented processing the patient triage pipeline status shift.</p>");
        out.print("<code style='color:#b91c1c; background:#fef2f2; padding:4px 8px; border-radius:4px; display:block; margin-top:15px; overflow-x:auto;'>Error Details: " + e.getMessage() + "</code>");
        out.print("<br><a href='reception_dashboard.jsp' style='color:#38bdf8; text-decoration:none; font-weight:600;'>&larr; Return to Dashboard</a></div></body></html>");
    } finally {
        // 5. Clean up open connections to avoid connection pooling leaks
        if (pst != null) { try { pst.close(); } catch(SQLException ignored) {} }
        if (con != null) { try { con.close(); } catch(SQLException ignored) {} }
    }
%>
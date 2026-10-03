<%@ page import="java.sql.*" %>
<%
    // Get parameters from the forms (Doctor, Lab, or Pharmacist)
    String pId = request.getParameter("patient_id");
    String nextStatus = request.getParameter("next_status"); 
    String doctorAdvice = request.getParameter("doctor_advice");
    String labResult = request.getParameter("lab_result");
    String username = (String)session.getAttribute("username");

    Connection con = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

        // Build a dynamic update query based on which actor is sending data
        String sql = "UPDATE patients SET status = ?";
        if (doctorAdvice != null) sql += ", doctor_advice = ?";
        if (labResult != null) sql += ", lab_result = ?";
        sql += " WHERE patient_id = ?";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, nextStatus);
        
        int paramIndex = 2;
        if (doctorAdvice != null) pst.setString(paramIndex++, doctorAdvice);
        if (labResult != null) pst.setString(paramIndex++, labResult);
        
        pst.setString(paramIndex, pId);
        pst.executeUpdate();

        // AUDIT LOG: Record the pharmacist or doctor operation
        PreparedStatement logPst = con.prepareStatement(
            "INSERT INTO system_logs (username, action_performed) VALUES (?, ?)");
        logPst.setString(1, username != null ? username : "System");
        logPst.setString(2, "Updated Patient #" + pId + " status to " + nextStatus);
        logPst.executeUpdate();

        // Redirect back based on who was using it
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : "login.html");

    } catch(Exception e) {
        out.print("Database Error: " + e.getMessage());
    } finally {
        if(con != null) con.close();
    }
%>
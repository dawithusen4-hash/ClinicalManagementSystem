<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String appIdStr = request.getParameter("app_id");
    String patientName = request.getParameter("patient_name");

    if (appIdStr == null || appIdStr.trim().isEmpty()) {
        response.sendRedirect("view_appointments.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement updateAppPst = null;
    PreparedStatement insertPatientPst = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
        
        con.setAutoCommit(false);

        // 1. Mark appointment as Checked-In so it vanishes from the receptionist's upcoming queue list
        String updateAppSql = "UPDATE appointments SET status = 'Checked-In' WHERE app_id = ?";
        updateAppPst = con.prepareStatement(updateAppSql);
        updateAppPst.setInt(1, Integer.parseInt(appIdStr));
        updateAppPst.executeUpdate();

        // 2. Generate a unique custom text string for patient_id (No Auto-Increment)
        String customPatientId = "PT-" + System.currentTimeMillis();

        // 3. Send the profile directly to the Doctor by defining status as 'Doctor'
        String insertPatientSql = "INSERT INTO patients (patient_id, full_name, status, visit_type, registration_date) VALUES (?, ?, 'Doctor', 'Appointment', CURDATE())";
        insertPatientPst = con.prepareStatement(insertPatientSql);
        insertPatientPst.setString(1, customPatientId);
        insertPatientPst.setString(2, patientName);
        insertPatientPst.executeUpdate();

        con.commit();
        
        response.sendRedirect("view_appointments.jsp?message=" + java.net.URLEncoder.encode("Patient '" + patientName + "' successfully reserved and sent directly to Doctor queue!", "UTF-8"));

    } catch (Exception e) {
        if (con != null) {
            try { con.rollback(); } catch (SQLException ex) { out.print(ex.getMessage()); }
        }
        out.print("<div style='color:red; padding:20px;'>Critical Routing Failure: " + e.getMessage() + "</div>");
    } finally {
        if (updateAppPst != null) updateAppPst.close();
        if (insertPatientPst != null) insertPatientPst.close();
        if (con != null) con.close();
    }
%>
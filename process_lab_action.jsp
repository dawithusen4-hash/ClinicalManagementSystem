<%@ page import="java.sql.*" %>
<%
    String pId = request.getParameter("patient_id");
    String nextStatus = request.getParameter("next_status");
    String labResult = request.getParameter("lab_result");
    String isRecall = request.getParameter("is_recall");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
        PreparedStatement pst;

        if ("true".equals(isRecall)) {
            // Logic for Recall: Just move the patient back to the Lab queue
            pst = con.prepareStatement("UPDATE patients SET status = ? WHERE patient_id = ?");
            pst.setString(1, nextStatus);
            pst.setString(2, pId);
        } else {
            // Logic for Submit: Update the result AND change status
            pst = con.prepareStatement("UPDATE patients SET lab_result = ?, status = ? WHERE patient_id = ?");
            pst.setString(1, labResult);
            pst.setString(2, nextStatus);
            pst.setString(3, pId);
        }
        
        pst.executeUpdate();
        con.close();
        
        if ("true".equals(isRecall)) {
            response.sendRedirect("lab_dashboard.jsp?msg=Recalled");
        } else {
            response.sendRedirect("view_lab_history.jsp?msg=Sent");
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
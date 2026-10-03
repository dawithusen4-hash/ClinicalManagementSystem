import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LabReportServlet")
public class LabReportServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String patientId = request.getParameter("patient_id");
        String testResult = request.getParameter("test_result");
        String testType = request.getParameter("test_type");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            
            // We update the patient record or a separate lab_results table
            // Here we update the 'advice' or a new 'lab_data' column in patients
            String sql = "UPDATE patients SET advice = CONCAT(IFNULL(advice,''), '\n[LAB RESULT]: ', ?, ' - ', ?) WHERE patient_id = ?";
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, testType);
            pstmt.setString(2, testResult);
            pstmt.setString(3, patientId);

            int i = pstmt.executeUpdate();
            if(i > 0) {
                response.sendRedirect("lab_dashboard.jsp?status=sent");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Error: " + e.getMessage());
        }
    }
}
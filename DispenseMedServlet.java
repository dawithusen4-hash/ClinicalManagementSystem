import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DispenseMedServlet")
public class DispenseMedServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pId = request.getParameter("patient_id");
        String meds = request.getParameter("meds");
        
        // Mandatory date for the pharmacy operation
        java.sql.Timestamp dispenseDate = new java.sql.Timestamp(System.currentTimeMillis());

        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            String sql = "INSERT INTO prescriptions (patient_id, medication_name, dispensed_date) VALUES (?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, pId);
            pstmt.setString(2, meds);
            pstmt.setTimestamp(3, dispenseDate);

            int result = pstmt.executeUpdate();
            if(result > 0) {
                response.sendRedirect("pharmacist_dashboard.jsp?status=success");
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
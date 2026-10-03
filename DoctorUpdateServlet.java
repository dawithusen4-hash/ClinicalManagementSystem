import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DoctorUpdateServlet")
public class DoctorUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // 1. Get Form Data
        String pId = request.getParameter("p_id");
        String advice = request.getParameter("advice");
        String doctorAdvice = request.getParameter("doctor_advice");
        String needsBed = request.getParameter("needs_bed");
        
        // 2. Logic: If Doctor wrote lab instructions, set status to 'Lab'
        // If lab instructions are empty, set status to 'Pharmacy'
        String nextStatus = (doctorAdvice != null && !doctorAdvice.trim().isEmpty()) ? "Lab" : "Pharmacy";

        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            // 3. SQL matched exactly to your screenshot columns
            String sql = "UPDATE consultation SET advice=?, doctor_advice=?, status=?, needs_bed=? WHERE patient_id=?";
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, advice);
            pstmt.setString(2, doctorAdvice);
            pstmt.setString(3, nextStatus);
            pstmt.setString(4, (needsBed != null) ? needsBed : "No");
            pstmt.setString(5, pId);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                // Success: Back to dashboard with message
                response.sendRedirect("doctor_dashboard.jsp?status=success&to=" + nextStatus);
            } else {
                response.sendRedirect("doctor_dashboard.jsp?status=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctor_dashboard.jsp?status=db_error&msg=" + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (SQLException se) { se.printStackTrace(); }
        }
    }
}
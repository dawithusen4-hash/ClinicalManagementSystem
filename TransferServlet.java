import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pId = request.getParameter("p_id");
        String advice = request.getParameter("advice");
        String labResults = request.getParameter("lab_results");
        String target = request.getParameter("target");
        String action = request.getParameter("action");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            if ("update_only".equals(action)) {
                // Doctor editing advice while patient is at Lab/Pharmacy
                String sql = "UPDATE consultations SET advice = ? WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, advice);
                pst.setString(2, pId);
                pst.executeUpdate();
            } 
            else if ("update_lab_only".equals(action)) {
                // Lab Tech editing results while patient is at Doctor
                String sql = "UPDATE consultations SET lab_results = ? WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, labResults);
                pst.setString(2, pId);
                pst.executeUpdate();
            }
            else if (labResults != null && target.equals("Doctor")) {
                // Normal Lab submission
                String sql = "UPDATE consultations SET status = 'Doctor', lab_results = ? WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, labResults);
                pst.setString(2, pId);
                pst.executeUpdate();
            }
            else {
                // Standard movement (Doctor -> Lab, Doctor -> Pharmacy, Pharmacy -> Completed, Recall)
                String sql = "UPDATE consultations SET status = ? WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, target);
                pst.setString(2, pId);
                pst.executeUpdate();
                
                // If advice was sent in the form, update that too
                if(advice != null) {
                    String sql2 = "UPDATE consultations SET advice = ? WHERE id = ?";
                    PreparedStatement pst2 = con.prepareStatement(sql2);
                    pst2.setString(1, advice);
                    pst2.setString(2, pId);
                    pst2.executeUpdate();
                }
            }
            
            con.close();
            response.sendRedirect(request.getHeader("Referer"));

        } catch (Exception e) { e.printStackTrace(); }
    }
}
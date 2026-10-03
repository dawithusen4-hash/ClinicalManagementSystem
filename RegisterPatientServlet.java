import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterPatientServlet")
public class RegisterPatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("patient_name");
        String age = request.getParameter("age");
        String status = request.getParameter("status"); // Value is 'Doctor'

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
            
            // Inserting into the columns you showed in your database screenshot
            String sql = "INSERT INTO consultations (patient_name, age, status) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, name);
            pst.setString(2, age);
            pst.setString(3, status);
            
            pst.executeUpdate();
            con.close();
            
            // Redirect back to reception with a success message
            response.sendRedirect("reception.jsp?msg=done");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
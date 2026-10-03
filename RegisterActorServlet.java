import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterActorServlet")
public class RegisterActorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");

        // 1. Backend Password Validation (Double check)
        if (pass == null || pass.length() < 8 || !pass.matches(".*[A-Za-z].*") || !pass.matches(".*\\d.*")) {
            response.sendRedirect("actorregistration.jsp?error=invalid_password");
            return;
        }

        try {
            // 2. Database Connection
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            // 3. Insert Statement
            String sql = "INSERT INTO users (username, password, role, registration_date) VALUES (?, ?, ?, NOW())";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, user);
            pst.setString(2, pass); 
            pst.setString(3, role);

            int rows = pst.executeUpdate();

            if (rows > 0) {
                // REDIRECT TO THE OWN SUCCESS PAGE
                response.sendRedirect("registration_success.jsp");
            } else {
                response.sendRedirect("actorregistration.jsp?error=db_fail");
            }
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("actorregistration.jsp?error=" + e.getMessage());
        }
    }
}
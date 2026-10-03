import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the ID from the URL link
        String idToDelete = request.getParameter("id");

        if (idToDelete != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

                // Delete the user matching the ID
                String sql = "DELETE FROM users WHERE user_id = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, idToDelete);

                int affectedRows = pstmt.executeUpdate();
                
                con.close();
                // Redirect back to the management page to see the updated list
                response.sendRedirect("manage_users.jsp?status=deleted");

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Database Error: " + e.getMessage());
            }
        }
    }
}
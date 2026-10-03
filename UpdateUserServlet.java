import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Capture parameters from the edit form
        String userId = request.getParameter("user_id");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        Connection con = null;
        PreparedStatement pst = null;

        try {
            // 2. Database Connection
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            // 3. Prepare Update Query
            String sql = "UPDATE users SET username=?, password=?, role=? WHERE user_id=?";
            pst = con.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, role);
            pst.setString(4, userId);

            // 4. Execute and Check Result
            int rowCount = pst.executeUpdate();

            if (rowCount > 0) {
                // REDIRECT TO THE OWN SUCCESS PAGE
                response.sendRedirect("update_success.jsp");
            } else {
                // If ID not found, go back with error
                response.sendRedirect("edit_user.jsp?id=" + userId + "&status=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to a generic error page if needed
            response.sendRedirect("manage_users.jsp?status=exception");
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
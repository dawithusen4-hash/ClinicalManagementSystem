import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database Configuration
    private String dbURL = "jdbc:mysql://localhost:3306/clinic_management_system";
    private String dbUser = "root";
    private String dbPass = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Capture Form Parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // Identify who is performing the action for the Audit Logs
        String activeAdmin = (session.getAttribute("adminName") != null) ? 
                             (String) session.getAttribute("adminName") : "Admin Manager";

        Connection con = null;
        try {
            // Load MySQL Driver
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // 2. INSERT New User with MD5 Hashing
            // Note: MD5(?) tells MySQL to hash the second parameter immediately
            String userSql = "INSERT INTO users (username, password, role) VALUES (?, MD5(?), ?)";
            PreparedStatement userPst = con.prepareStatement(userSql);
            userPst.setString(1, username);
            userPst.setString(2, password); // Sending plain text; DB saves it as MD5
            userPst.setString(3, role);

            int rowCount = userPst.executeUpdate();

            // 3. If Successful, LOG the action and REDIRECT
            if (rowCount > 0) {
                logAction(con, activeAdmin, "Added new " + role + ": " + username);
                response.sendRedirect("registration_success.jsp");
            } else {
                response.sendRedirect("admin_dashboard.jsp?status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect with error message (e.g., if username is already taken)
            response.sendRedirect("admin_dashboard.jsp?status=error&msg=User already exists or DB Error");
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    /**
     * Helper Method: Writes entries into the 'system_logs' table
     */
    private void logAction(Connection con, String performer, String action) {
        String logSql = "INSERT INTO system_logs (username, action_performed) VALUES (?, ?)";
        try (PreparedStatement logPst = con.prepareStatement(logSql)) {
            logPst.setString(1, performer);
            logPst.setString(2, action);
            logPst.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Critical Error: Audit Logging Failed. " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("admin_dashboard.jsp");
    }
}
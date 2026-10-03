import java.io.IOException;

import java.sql.*;

import java.security.MessageDigest;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.*;

@WebServlet("/LoginServlet")

public class LoginServlet extends HttpServlet {

    // Helper Method to convert plain text to MD5

    public String convertToMD5(String input) {

        try {

            MessageDigest md = MessageDigest.getInstance("MD5");

            byte[] messageDigest = md.digest(input.getBytes());

            StringBuilder sb = new StringBuilder();

            for (byte b : messageDigest) {

                sb.append(String.format("%02x", b));

            }

            return sb.toString();

        } catch (Exception e) {

            return null;

        }

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 

            throws ServletException, IOException {
  
        String user = request.getParameter("username");

        String pass = request.getParameter("password");

        String role = request.getParameter("role");

        String hashedPass = convertToMD5(pass);

        Connection con = null;

        try {

            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            // 1. Check Credentials with Case Sensitivity

            String sql = "SELECT * FROM users WHERE BINARY username = ? AND BINARY password = ? AND role = ?";

            PreparedStatement pst = con.prepareStatement(sql);

            pst.setString(1, user);

            pst.setString(2, hashedPass);

            pst.setString(3, role);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {

                // SUCCESS: Create Session

                HttpSession session = request.getSession();

                session.setAttribute("username", user);

                session.setAttribute("role", role);

             // 2. UPDATE LIVE STATUS: Mark user as online and update last seen

                String updateStatus = "UPDATE users SET is_online = 1, last_login = NOW() WHERE username = ?";

                PreparedStatement upst = con.prepareStatement(updateStatus);

                upst.setString(1, user);

                upst.executeUpdate();

                // 3. AUDIT LOG: Record this login in system_logs

                String logAction = "INSERT INTO system_logs (username, action_performed, action_time) VALUES (?, 'Login Successful', NOW())";

                PreparedStatement lpst = con.prepareStatement(logAction);

                lpst.setString(1, user);

                lpst.executeUpdate();

                // 4. ROLE-BASED REDIRECTION

                if (role.equalsIgnoreCase("admin")) {

                    response.sendRedirect("admin_dashboard.jsp");

                } else if (role.equalsIgnoreCase("doctor")) {

                    response.sendRedirect("doctor_dashboard.jsp");

                } else if (role.equalsIgnoreCase("pharmacist")) {

                    response.sendRedirect("pharmacist_dashboard.jsp");

                } else if (role.equalsIgnoreCase("lab_technician")) {

                    response.sendRedirect("lab_dashboard.jsp");

                } else if (role.equalsIgnoreCase("receptionist")) {

                    response.sendRedirect("reception_dashboard.jsp");

                } else {

                    response.sendRedirect("dashboard.jsp");

                }

            } else {

                // FAIL: Log failed attempt (Optional but good for security)

                response.sendRedirect("login.html?error=1");

            }
        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println("System Error: " + e.getMessage());

        } finally {

            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }

        }

    }

}
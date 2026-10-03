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

@WebServlet("/PatientRegistrationServlet")
public class PatientRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database configuration keys matching your local installation setup
    private final String dbUrl = "jdbc:mysql://localhost:3306/clinic_management_system";
    private final String dbUser = "root";
    private final String dbPassword = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Capture the form fields sent by the receptionist browser client
        String patientId = request.getParameter("patient_id");
        String fullName = request.getParameter("full_name");
        String sex = request.getParameter("sex");
        String ageStr = request.getParameter("age");
        String college = request.getParameter("college");
        String batch = request.getParameter("batch");
        String department = request.getParameter("department");
        
        // Default pipeline states for clinic routing workflows
        String defaultStatus = "Waiting";
        String defaultVisitType = "Walk-in";

        Connection con = null;
        PreparedStatement pst = null;

        try {
            // 2. Load driver instance class map targeting MySQL
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // 3. Construct explicit SQL injection-proof pipeline statement
            // Notice how patient_id is included inside the target columns layout instead of being ignored!
            String sql = "INSERT INTO patients (patient_id, full_name, sex, age, college, batch, department, status, visit_type) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            pst = con.prepareStatement(sql);
            
            // 4. Safely bind our parameter variables into matching statement layout slots
            pst.setString(1, patientId);
            pst.setString(2, fullName);
            pst.setString(3, sex);
            pst.setInt(4, Integer.parseInt(ageStr));
            pst.setString(5, college);
            pst.setString(6, batch);
            pst.setString(7, department);
            pst.setString(8, defaultStatus);
            pst.setString(9, defaultVisitType);

            // 5. Commit record transaction to server storage memory
            int rowsInserted = pst.executeUpdate();

            if (rowsInserted > 0) {
                // Success: Redirect straight back to your receptionist pipeline dashboard overview
                response.sendRedirect("reception_dashboard.jsp?registration=success");
            } else {
                response.sendRedirect("register_patient.html?error=failed_to_save");
            }

        } catch (ClassNotFoundException | SQLException | NumberFormatException e) {
            // Error handling fallback response rendering
            response.getWriter().println("<h1>Database Error Encountered During Registration</h1>");
            response.getWriter().println("<p style='color:red;'>Details: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            // 6. Housekeeping cleanup logic blocks to avoid resource or socket locking errors in GlassFish
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
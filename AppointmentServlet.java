import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.clinic.util.TelegramProvider; // Make sure this matches your package

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Collect Data from JSP (Including the new non-auto-increment patient_id)
        String pId = request.getParameter("patient_id");
        String pName = request.getParameter("patient_name");
        String dName = request.getParameter("doctor_name");
        String aDate = request.getParameter("app_date");
        String aTime = request.getParameter("app_time");
        String chatId = request.getParameter("telegram_id");
        String reason = request.getParameter("reason");

        Connection con = null;
        try {
            // 2. Database Connection
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Clinic_Management_System", "root", "");

            // 3. Insert Appointment into MySQL including patient_id explicitly
            String sql = "INSERT INTO appointments (patient_id, patient_name, doctor_name, app_date, app_time, telegram_id, reason, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, 'Scheduled')";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, pId); // Explicitly maps custom text sequence key safely
            ps.setString(2, pName);
            ps.setString(3, dName);
            ps.setString(4, aDate);
            ps.setString(5, aTime);
            ps.setString(6, chatId);
            ps.setString(7, reason);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // 4. Send Telegram Message if Database update succeeded
                String message = "🏥 *Med-Flow Clinic Confirmation*\n\n" +
                                 "Dear " + pName + ",\n" +
                                 "Your appointment with *" + dName + "* is confirmed.\n" +
                                 "🆔 *Patient ID:* " + pId + "\n" +
                                 "📅 *Date:* " + aDate + "\n" +
                                 "⏰ *Time:* " + aTime + "\n\n" +
                                 "Please arrive 10 minutes early.";
                
                TelegramProvider.sendNotification(chatId, message);

                // 5. Redirect back with success status
                response.sendRedirect("book_appointment.jsp?status=success");
            } else {
                response.sendRedirect("book_appointment.jsp?status=db_error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("book_appointment.jsp?status=db_error");
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
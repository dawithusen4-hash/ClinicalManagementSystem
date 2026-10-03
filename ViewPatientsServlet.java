import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

public class ViewPatientsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");

            // Query matching all columns in your image
            String sql = "SELECT * FROM patients ORDER BY registration_date DESC";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            // In a real app, you'd put these in a List and pass to the JSP
            // For now, let's assume the JSP handles the display.
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
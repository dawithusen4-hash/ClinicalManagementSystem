<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - User Control Center</title>
    <style>
        /* Modern Foundation */
        body { 
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; 
            background-color: #f0f2f5; 
            margin: 0; 
            padding: 40px 20px; 
        }
        
        .container { 
            max-width: 1100px; 
            margin: auto; 
            background: white; 
            padding: 35px; 
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.08); 
        }

        /* Header Style */
        h2 { 
            color: #2c3e50; 
            font-weight: 700;
            border-left: 5px solid #3498db; 
            padding-left: 15px; 
            margin-bottom: 30px; 
            letter-spacing: -0.5px;
        }

        /* Navigation Button Area */
        .nav-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        /* Table Design */
        table { 
            width: 100%; 
            border-collapse: collapse; 
            background: #fff;
            overflow: hidden;
            border-radius: 10px;
        }
        
        th { 
            background-color: #f8f9fa; 
            color: #5d6d7e; 
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            padding: 18px; 
            text-align: left; 
            border-bottom: 2px solid #edf2f7;
        }
        
        td { 
            padding: 15px 18px; 
            border-bottom: 1px solid #f1f1f1; 
            color: #2d3436;
            font-size: 0.95rem;
        }

        tr:hover { background-color: #fbfcfe; transition: 0.2s; }

        /* Role Badge System */
        .role-badge { 
            padding: 6px 14px; 
            border-radius: 50px; 
            font-size: 0.75rem; 
            font-weight: 700; 
            text-transform: uppercase; 
            display: inline-block;
        }
        .role-doctor { background: #e3f2fd; color: #1976d2; }
        .role-admin { background: #fff5f5; color: #c53030; }
        .role-reception { background: #f0fff4; color: #2f855a; }
        .role-lab { background: #faf5ff; color: #6b46c1; }
        .role-pharmacy { background: #fffaf0; color: #c05621; }
        .role-default { background: #edf2f7; color: #4a5568; }

        /* Button Styling */
        .btn { 
            padding: 10px 20px; 
            border-radius: 8px; 
            text-decoration: none; 
            font-size: 0.88rem; 
            font-weight: 600; 
            display: inline-flex; 
            align-items: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
        }

        .btn-add { background: #3498db; color: white; box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2); }
        .btn-back { background: #95a5a6; color: white; margin-left: 10px; }
        .btn-edit { background: #fdf2f2; color: #3498db; border: 1px solid #3498db; padding: 6px 12px; }
        .btn-delete { background: #fff5f5; color: #e74c3c; border: 1px solid #e74c3c; padding: 6px 12px; margin-left: 5px; }

        .btn:hover { 
            transform: translateY(-2px); 
            filter: brightness(1.05);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .btn-delete:hover { background: #e74c3c; color: white; }
        .btn-edit:hover { background: #3498db; color: white; }
    </style>
</head>
<body>

<div class="container">
    <h2>User Management Control</h2>
    
    <div class="nav-actions">
        <div>
            <a href="actorregistration.html" class="btn btn-add">+ Add New Actor</a>
            <a href="admin_dashboard.jsp" class="btn btn-back">? Back to Dashboard</a>
        </div>
        <span style="color: #95a5a6; font-size: 0.9rem;">Total Database Records</span>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Role</th>
                <th>Registration Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
                try {
                    // It is recommended to use the modern driver: com.mysql.cj.jdbc.Driver
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM users ORDER BY user_id DESC");

                    while(rs.next()) {
                        int userId = rs.getInt("user_id");
                        String role = rs.getString("role");
                        String roleClass = "role-default";
                        
                        // Enhanced Role Checking
                        if(role.equalsIgnoreCase("doctor")) roleClass = "role-doctor";
                        else if(role.equalsIgnoreCase("admin")) roleClass = "role-admin";
                        else if(role.equalsIgnoreCase("receptionist")) roleClass = "role-reception";
                        else if(role.equalsIgnoreCase("lab_technician")) roleClass = "role-lab";
                        else if(role.equalsIgnoreCase("pharmacist")) roleClass = "role-pharmacy";
            %>
            <tr>
                <td style="font-weight: bold; color: #95a5a6;">#<%= userId %></td>
                <td><strong><%= rs.getString("username") %></strong></td>
                <td><span class="role-badge <%= roleClass %>"><%= role %></span></td>
                <td><span style="color: #7f8c8d; font-size: 0.85rem;"><%= rs.getTimestamp("registration_date") %></span></td>
                <td>
                    <a href="edit_user.jsp?id=<%= userId %>" class="btn btn-edit">Edit</a>
                    <a href="DeleteUserServlet?id=<%= userId %>" class="btn btn-delete" 
                       onclick="return confirm('Are you sure you want to delete user: <%= rs.getString("username") %>?')">Delete</a>
                </td>
            </tr>
            <% 
                    }
                    con.close();
                } catch (Exception e) { 
                    out.print("<tr><td colspan='5' style='color:red; text-align:center;'>Database Error: " + e.getMessage() + "</td></tr>"); 
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>
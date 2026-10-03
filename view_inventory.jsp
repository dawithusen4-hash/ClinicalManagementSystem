<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medicine Inventory | Mattu Clinic</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f9f4; margin: 0; display: flex; }
        
        /* Sidebar */
        .sidebar { width: 280px; height: 100vh; background: #2c3e50; color: white; padding: 20px; position: fixed; z-index: 1000; }
        .sidebar h2 { color: #2ecc71; margin-bottom: 30px; }
        .sidebar a { display: block; color: #bdc3c7; padding: 12px 0; text-decoration: none; border-bottom: 1px solid #34495e; }
        .sidebar a:hover { color: white; padding-left: 10px; transition: 0.3s; }
        
        /* Main Content */
        .main-content { margin-left: 300px; padding: 25px; width: calc(100% - 330px); }
        
        /* Header & Back Button */
        .welcome-section { 
            background: white; padding: 30px; border-radius: 12px; margin-bottom: 25px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-left: 6px solid #2ecc71; 
            display: flex; justify-content: space-between; align-items: center;
        }
        .welcome-section h1 { margin: 0; color: #2c3e50; font-size: 1.8rem; }
        .back-btn { 
            background: #34495e; color: white; text-decoration: none; padding: 10px 20px; 
            border-radius: 6px; font-weight: bold; font-size: 0.9rem; transition: 0.3s; 
        }
        .back-btn:hover { background: #2c3e50; box-shadow: 0 2px 8px rgba(0,0,0,0.2); }

        /* Search Section */
        .search-container { background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; display: flex; gap: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .search-input { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 1rem; }
        .search-btn { background: #2c3e50; color: white; border: none; padding: 0 25px; border-radius: 6px; cursor: pointer; font-weight: bold; }

        /* Table */
        .inventory-table { width: 100%; background: white; border-collapse: collapse; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .inventory-table th { background: #f8fafc; color: #475569; padding: 15px; text-align: left; border-bottom: 2px solid #edf2f7; }
        .inventory-table td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #2c3e50; }
        
        /* Badges */
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; text-transform: uppercase; }
        .in-stock { background: #d1fae5; color: #065f46; }
        .low-stock { background: #fef3c7; color: #92400e; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Med-Flow</h2>
    <a href="pharmacist_dashboard.jsp">Dashboard</a>
    <a href="dispensed_history.jsp">Dispensed History</a>
    <a href="view_inventory.jsp" style="color: #2ecc71; font-weight: bold;">Medicine Inventory</a>
    <a href="index.html" style="color: #f87171; margin-top: 50px;">Sign Out</a>
</div>

<div class="main-content">
    <div class="welcome-section">
        <div>
            <h1>Medicine Stock Management</h1>
            <p style="margin: 5px 0 0 0; color: #7f8c8d;">Track and search your clinic's pharmacy supply.</p>
        </div>
        <a href="pharmacist_dashboard.jsp" class="back-btn">?Back to dashbourd</a>
    </div>

    <form method="GET" class="search-container">
        <input type="text" name="search" class="search-input" placeholder="Search Medicine Name or Category..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit" class="search-btn">Search Inventory</button>
    </form>

    <table class="inventory-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Medicine Name</th>
                <th>Category</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% 
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                    
                    String search = request.getParameter("search");
                    String sql = "SELECT * FROM medicines";
                    
                    // Apply Search Filter Dynamically
                    if(search != null && !search.trim().isEmpty()){
                        sql += " WHERE name LIKE ? OR category LIKE ?";
                    }
                    sql += " ORDER BY name ASC";

                    PreparedStatement pst = con.prepareStatement(sql);
                    if(search != null && !search.trim().isEmpty()){
                        pst.setString(1, "%" + search + "%");
                        pst.setString(2, "%" + search + "%");
                    }

                    ResultSet rs = pst.executeQuery();
                    while(rs.next()) {
                        int qty = rs.getInt("quantity");
                        String badge = (qty > 10) ? "in-stock" : "low-stock";
                        String text = (qty > 10) ? "In Stock" : "Low Stock";
            %>
            <tr>
                <td>#<%= rs.getInt("id") %></td>
                <td><strong><%= rs.getString("name") %></strong></td>
                <td><%= rs.getString("category") %></td>
                <td><%= qty %> units</td>
                <td>$<%= String.format("%.2f", rs.getDouble("unit_price")) %></td>
                <td><span class="status-badge <%= badge %>"><%= text %></span></td>
            </tr>
            <% 
                    }
                    con.close();
                } catch(Exception e) { 
                    out.print("<tr><td colspan='6' style='text-align:center; color:red;'>Error: " + e.getMessage() + "</td></tr>"); 
                } 
            %>
        </tbody>
    </table>
</div>

</body>
</html>
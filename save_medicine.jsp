<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Med-Flow Clinic | Medicine Inventory</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f0f4f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px; }
        .status-box { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); text-align: center; max-width: 450px; width: 100%; border: 1px solid #e1e8ed; }
        .success-text { color: #10b981; font-weight: 600; font-size: 1.3rem; margin-bottom: 15px; }
        .error-text { color: #e74c3c; font-weight: 600; font-size: 1.3rem; margin-bottom: 15px; }
        
        /* Interactive Elements */
        .btn-return { display: inline-block; padding: 12px 20px; background: #3498db; color: white; text-decoration: none; border-radius: 6px; font-size: 0.95rem; font-weight: 600; cursor: pointer; border: none; width: 100%; text-align: center; transition: background 0.2s ease; }
        .btn-return:hover { background: #2980b9; }
        
        .button-row { display: flex; gap: 12px; margin-top: 15px; }
        .btn-secondary { background-color: #94a3b8; color: white; text-decoration: none; padding: 12px 20px; border-radius: 6px; font-size: 0.95rem; font-weight: 600; display: inline-block; width: 100%; text-align: center; box-sizing: border-box; transition: background 0.2s ease; }
        .btn-secondary:hover { background-color: #64748b; }
        
        /* Styles for the Form */
        .status-box h2 { color: #2c3e50; margin-bottom: 5px; font-weight: 700; text-align: center; }
        .status-box p.subtitle { color: #636e72; font-size: 0.9rem; margin-bottom: 25px; text-align: center; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 8px; color: #475569; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; }
        input, select { width: 100%; padding: 12px; border: 1px solid #dcdde1; border-radius: 8px; font-size: 0.95rem; background-color: #f8fafc; box-sizing: border-box; }
        input:focus, select:focus { border-color: #3498db; outline: none; background-color: white; }

        /* Progress Bar UI Container */
        .progress-wrapper { display: none; padding: 20px 0; text-align: center; }
        .progress-bar-container { background-color: #e2e8f0; border-radius: 20px; width: 100%; height: 8px; overflow: hidden; margin-top: 15px; position: relative; }
        .progress-fill { background: linear-gradient(90deg, #3498db, #10b981); height: 100%; width: 0%; border-radius: 20px; animation: loadProgress 1.2s cubic-bezier(0.4, 0, 0.2, 1) forwards; }
        
        @keyframes loadProgress {
            0% { width: 0%; }
            100% { width: 100%; }
        }
    </style>
</head>
<body>

<div class="status-box">
<%
    // If it's a GET request, display the input form directly on this page
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
%>
        <h2>Inventory Stock Input</h2>
        <p class="subtitle">Add new pharmaceutical supplies directly to the clinic database.</p>
        
        <form action="save_medicine.jsp" method="post" onsubmit="showProcessingBar()">
            <div class="form-group">
                <label for="med_name">Medicine Name</label>
                <input type="text" id="med_name" name="name" placeholder="e.g., Paracetamol" required>
            </div>
            
            <div class="form-group">
                <label for="category">Category</label>
                <select id="category" name="category" required>
                    <option value="" disabled selected>Select category</option>
                    <option value="antibiotic">Antibiotic</option>
                    <option value="analgesic">Analgesic (Pain Reliever)</option>
                    <option value="antiviral">Antiviral</option>
                    <option value="antihistamine">Antihistamine</option>
                </select>
            </div>

            <div class="form-group">
                <label for="quantity">Stock Quantity</label>
                <input type="number" id="quantity" name="quantity" min="1" placeholder="e.g., 3" required>
            </div>

            <div class="form-group">
                <label for="unit_price">Unit Price ($)</label>
                <input type="number" id="unit_price" name="unit_price" step="0.01" min="0.00" placeholder="e.g., 5.00" required>
            </div>

            <div class="form-group">
                <label for="expiry">Expiry Date</label>
                <input type="date" id="expiry" name="expiry_date" required>
            </div>
            
            <div class="button-row">
                <a href="pharmacist_dashboard.jsp" class="btn-secondary">← Back</a>
                <button type="submit" class="btn-return" style="margin-top:0;">Save to Inventory</button>
            </div>
        </form>

        <div id="loadingScreen" class="progress-wrapper">
            <h3 style="color: #2c3e50; margin: 0;">Securing System Write...</h3>
            <p style="font-size:0.85rem; color:#64748b; margin: 5px 0 0 0;">Synchronizing with core clinic warehouse inventory</p>
            <div class="progress-bar-container">
                <div class="progress-fill"></div>
            </div>
        </div>
<%
    } else {
        // If it's a POST request, process the submitted data
        String medName = request.getParameter("name");
        String category = request.getParameter("category");
        String qtyStr = request.getParameter("quantity");
        String priceStr = request.getParameter("unit_price");
        String expiry = request.getParameter("expiry_date");

        if (medName == null || category == null || qtyStr == null || priceStr == null || expiry == null || medName.trim().isEmpty()) {
%>
            <div class="error-text">✕ Submission Failure</div>
            <p style="color: #636e72;">Required information was missing. All inventory inputs must be filled out.</p>
            <a href="save_medicine.jsp" class="btn-return">Try Again</a>
<%
        } else {
            Connection con = null;
            try {
                int quantity = Integer.parseInt(qtyStr);
                double unitPrice = Double.parseDouble(priceStr);
                
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_management_system", "root", "");
                
                String sql = "INSERT INTO medicines (name, category, expiry_date, quantity, unit_price) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, medName);
                pst.setString(2, category);
                pst.setString(3, expiry);
                pst.setInt(4, quantity);
                pst.setDouble(5, unitPrice);
                
                int rows = pst.executeUpdate();
                if (rows > 0) {
%>
                    <div class="success-text">✔ Inventory Updated</div>
                    <p style="color: #636e72;"><strong><%= medName %></strong> has been saved to warehouse records successfully.</p>
                    <div class="button-row">
                        <a href="pharmacist_dashboard.jsp" class="btn-secondary">Dashboard</a>
                        <a href="save_medicine.jsp" class="btn-return" style="margin-top:0;">Add Another</a>
                    </div>
<%
                }
            } catch (NumberFormatException nfe) {
%>
                <div class="error-text">✕ Invalid Data Formats</div>
                <p style="color: #636e72;">Please verify numeric fields. Quantity must be a whole number, and price a decimal number.</p>
                <a href="save_medicine.jsp" class="btn-return">Fix Form Inputs</a>
<%
            } catch (Exception e) {
%>
                <div class="error-text">✕ System Integration Error</div>
                <p style="color: #636e72;"><%= e.getMessage() %></p>
                <a href="save_medicine.jsp" class="btn-return">Return to Form</a>
<%
            } finally {
                if (con != null) { try { con.close(); } catch (SQLException se) { se.printStackTrace(); } }
            }
        }
    }
%>
</div>

<script>
    function showProcessingBar() {
        // Hide form contents smoothly during transition phase
        document.querySelector('form').style.display = 'none';
        document.querySelector('.status-box h2').style.display = 'none';
        document.querySelector('.subtitle').style.display = 'none';
        
        // Show visual tracking loader animation element
        document.getElementById('loadingScreen').style.display = 'block';
    }
</script>

</body>
</html>
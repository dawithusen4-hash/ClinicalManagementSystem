<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Med-Flow | Book Appointment</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; display: flex; justify-content: center; padding: 40px; }
        .form-card { 
            background: white; padding: 30px; border-radius: 15px; 
            width: 100%; max-width: 500px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
        }
        h2 { color: #2c3e50; text-align: center; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-top: 0; }
        label { display: block; margin: 15px 0 5px; font-weight: bold; color: #34495e; }
        input, select, textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; font-size: 1rem; }
        .btn-submit { 
            background: #3498db; color: white; border: none; padding: 15px; 
            width: 100%; border-radius: 8px; font-weight: bold; cursor: pointer; margin-top: 25px; font-size: 1.1rem;
        }
        .btn-submit:hover { background: #2980b9; }
        .help-text { font-size: 0.8rem; color: #7f8c8d; margin-top: 5px; }
        .alert { padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center; }
        .error { background: #f8d7da; color: #721c24; }
        .success { background: #d4edda; color: #155724; }
    </style>
</head>
<body>

<div class="form-card">
    <h2>Schedule Appointment</h2>

    <%-- Success/Error Messages --%>
    <% if("db_error".equals(request.getParameter("status"))) { %>
        <div class="alert error">Error saving to database. Check your connection.</div>
    <% } %>
    <% if("success".equals(request.getParameter("status"))) { %>
        <div class="alert success">Appointment Booked & Telegram Sent!</div>
    <% } %>

    <form action="AppointmentServlet" method="POST">
        
        <label>Patient ID Reference</label>
        <%
            // If you want to auto-generate a fallback unique token for new patients, 
            // we create it using a standard timestamp identifier string sequence
            String generatedId = "PT-" + System.currentTimeMillis();
        %>
        <input type="text" name="patient_id" value="<%= generatedId %>" placeholder="e.g. PT-10254" required style="border-color: #3498db; background-color: #f0fafb; font-weight: 600;">
        <p class="help-text">Modify this manually if the patient has an existing clinic registration number code.</p>

        <label>Patient Full Name</label>
        <input type="text" name="patient_name" placeholder="Full Name" required>

        <label>Assign Doctor</label>
        <select name="doctor_name">
            <option value="Dr.mihiret">Dr.Mihiret (General Medicine)</option>
            <option value="Dr.wonde">Dr.Wonde (Specialist)</option>
            <option value="Dr.dawit">Dr.Dawit (Pediatrics)</option>
            <option value="Dr.wonidmu">Dr.Wondimu (Pediatrics)</option>
        </select>

        <div style="display: flex; gap: 15px;">
            <div style="flex: 1;">
                <label>Date</label>
                <input type="date" name="app_date" required>
            </div>
            <div style="flex: 1;">
                <label>Time</label>
                <input type="time" name="app_time" required>
            </div>
        </div>

        <label>Telegram Chat ID</label>
        <input type="text" name="telegram_id" placeholder="e.g. 12345678" required>
        <p class="help-text">Ask patient to get ID from @userinfobot on Telegram.</p>

        <label>Reason for Visit</label>
        <textarea name="reason" rows="2" placeholder="Brief description..."></textarea>

        <button type="submit" class="btn-submit">Confirm & Notify Patient</button>
        <a href="reception_dashboard.jsp" style="display:block; text-align:center; margin-top:15px; color:#7f8c8d; text-decoration:none; font-size: 0.9rem;">← Back to Home</a>
    </form>
</div>

</body>
</html>
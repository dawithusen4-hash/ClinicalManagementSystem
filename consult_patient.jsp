<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Consultation | Med-Flow</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; margin: 0; padding: 20px; }
        .consult-container { max-width: 600px; margin: 40px auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-top: 8px solid #27ae60; }
        h2 { color: #2c3e50; margin-top: 0; display: flex; align-items: center; gap: 10px; }
        .patient-id-badge { background: #ecf0f1; padding: 4px 12px; border-radius: 20px; font-size: 0.9rem; color: #7f8c8d; }
        label { display: block; margin-top: 20px; font-weight: bold; color: #34495e; font-size: 0.9rem; }
        textarea, select { width: 100%; padding: 12px; margin-top: 8px; border-radius: 6px; border: 1px solid #dcdde1; box-sizing: border-box; font-size: 1rem; }
        .lab-section { background: #fff9f0; padding: 15px; border-radius: 8px; border: 1px solid #ffeaa7; margin-top: 20px; }
        .btn-submit { background: #27ae60; color: white; border: none; padding: 15px; width: 100%; cursor: pointer; border-radius: 6px; font-weight: bold; margin-top: 30px; }
    </style>
</head>
<body>

<div class="consult-container">
    <h2>? Consultation <span class="patient-id-badge">ID: #<%= request.getParameter("id") %></span></h2>
    
    <form action="DoctorUpdateServlet" method="POST">
        <input type="hidden" name="p_id" value="<%= request.getParameter("id") %>">

        <label>Medical Advice & Diagnosis:</label>
        <textarea name="advice" rows="4" required placeholder="General medical advice for the patient..."></textarea>

        <div class="lab-section">
            <label style="margin-top:0;"><strong>? Lab Instructions (Optional)</strong></label>
            <textarea name="doctor_advice" rows="3" placeholder="Tests needed: Blood, Urine, Malaria..."></textarea>
            <p style="font-size: 0.8rem; color: #7f8c8d;">If you write here, patient moves to 'Lab' status.</p>
        </div>

        <label>Admission Required?</label>
        <select name="needs_bed">
            <option value="No">No</option>
            <option value="Yes">Yes</option>
        </select>

        <button type="submit" class="btn-submit">Update & Route Patient</button>
        <div style="text-align: center; margin-top: 15px;">
            <a href="doctor_dashboard.jsp" style="color: #7f8c8d; text-decoration: none; font-size: 0.9rem;">back to dashboard</a>
        </div>
    </form>
</div>

</body>
</html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reception | Patient Registration</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; margin: 0; padding: 20px; }
        .form-container { 
            max-width: 600px; 
            margin: 40px auto; 
            background: white; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); 
        }
        h2 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #34495e; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; }
        .full-width { grid-column: span 2; }
        button { 
            background: #3498db; color: white; padding: 12px; border: none; 
            border-radius: 6px; cursor: pointer; width: 100%; font-size: 1rem; margin-top: 20px; 
        }
        button:hover { background: #2980b9; }
        .back-link { display: block; text-align: center; margin-top: 15px; text-decoration: none; color: #7f8c8d; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Patient Registration</h2>
    <form action="PatientRegistrationServlet" method="post">
        <div class="grid">
            <div class="full-width">
                <label>Patient ID / Card Number</label>
                <input type="text" name="patient_id" required placeholder="Enter custom Patient ID (e.g., PT-2026-001)">
            </div>

            <div class="full-width">
                <label>Full Name</label>
                <input type="text" name="full_name" required placeholder="Enter Patient Name">
            </div>
            
            <div>
                <label>Sex</label>
                <select name="sex" required>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select>
            </div>
            
            <div>
                <label>Age</label>
                <input type="number" name="age" required placeholder="Age">
            </div>

            <div>
                <label>College</label>
                <input type="text" name="college" required placeholder="e.g. Health Sciences">
            </div>

            <div>
                <label>Batch</label>
                <input type="text" name="batch" required placeholder="e.g. 2024">
            </div>

            <div class="full-width">
                <label>Department</label>
                <input type="text" name="department" required placeholder="e.g. Nursing">
            </div>
        </div>

        <button type="submit">Complete Registration</button>
        <a href="reception_dashboard.jsp" class="back-link">Cancel and Return</a>
    </form>
</div>

</body>
</html>
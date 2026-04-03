# Standalone workflow mode

This build now includes a local standalone workflow layer for deeper healthcare flows when the live backend is unavailable.

## Demo credentials
Password for seeded accounts: `Pass@123`

Examples:
- patient1@icare.demo
- doctor1@icare.demo
- lab1@icare.demo
- pharmacy1@icare.demo
- instructor1@icare.demo
- student1@icare.demo

## What is seeded
- 10 patients from different Pakistan regions
- 10 doctors (mix of general and specialist)
- 10 laboratories
- 10 pharmacies
- 10 patient health programs
- 10 doctor professional courses
- seeded appointments, records, lab requests, pharmacy orders, medicines, enrollments

## Standalone workflow behavior
If API calls fail, the app now falls back to a local data layer and still supports:
- login and signup for patient/doctor
- admin-managed role login for lab/pharmacy/instructor/student via seeded accounts
- appointment booking and status changes
- medical record creation
- automatic creation of pharmacy orders from prescriptions
- automatic creation of lab requests from doctor-ordered tests
- automatic assignment of health programs based on diagnosis keywords
- lab request processing and report completion state
- pharmacy order processing and inventory/analytics screens
- learning enrollments, progress, and certificates

## Important
- This is a client-side standalone workflow implementation inside the Flutter app.
- It is meant to satisfy deeper product flows for demo/testing when the backend is not reachable.
- If you later connect a production backend, the app will still try the live APIs first and only use standalone fallback when those calls fail.

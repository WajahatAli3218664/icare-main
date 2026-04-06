Role-based cleanup pass completed against the uploaded feedback document and the provided Figma theme direction.

Implemented in this pass:
- centralized role normalization helper (Patient / Doctor / Laboratory / Pharmacy / Instructor / Student)
- public onboarding limited to Patient and Doctor
- healthcare-oriented onboarding and login copy
- removal of public-facing "Switch Role / Testing Bypass" wording
- role-aware bottom navigation labels:
  - Pharmacy -> Orders
  - Laboratory -> Requests
  - Student/Instructor -> Learning
  - Patient/Doctor -> Appointments
- learning relabeling toward Health Programs / My Health Journey for patient-education flows
- role-aware quick actions in drawer
- role display cleanup (Lab Partner / Pharmacy Partner etc.)
- fixes for mixed-case role checks across core screens

Important:
- This pass focuses on UI, routing labels, and role presentation cleanup.
- It does not fully implement all backend workflow requirements from the document (lab/pharmacy end-to-end processing, referrals, QA analytics, admin portals, etc.).
- Flutter/Dart toolchain was not available in this environment, so local compile/run validation is still required.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iCare is a Flutter-based virtual hospital platform with multi-role support (Patient, Doctor, Laboratory, Pharmacy, Instructor, Student, Admin). The app runs on Android, iOS, Windows, Web, and supports both online (backend API) and offline (standalone fallback) modes.

## Development Commands

### Setup and Run
```bash
# Install dependencies
flutter pub get

# Run on default device
flutter run

# Run on specific platforms
flutter run -d windows
flutter run -d chrome
flutter run -d <device-id>

# Check available devices
flutter devices

# Static analysis
flutter analyze

# Clean build artifacts
flutter clean
```

### Building for Production
```bash
# Android APK
flutter build apk --release

# Windows desktop
flutter build windows --release

# Web
flutter build web --release
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

## Architecture

### Dual-Mode Operation (Critical Pattern)

The app operates in two modes:

1. **Backend Mode**: Connects to `https://icare-backend-delta.vercel.app/api`
2. **Standalone Mode**: Falls back to local mock data when backend is unavailable

**Implementation Pattern** (see `lib/services/auth_service.dart`, `lib/services/appointment_service.dart`):
- All service methods attempt backend API call first
- On network errors (connection timeout, no response), fall back to `StandaloneCareHubService`
- On server errors (4xx, 5xx), return error message without fallback
- This ensures the app remains functional for demos/development without backend

### Role-Based Architecture

**Role Normalization** (`lib/utils/role_ui.dart`):
- Backend sends roles in various formats: "patient", "Patient", "doctor", "Doctor", "Laboratory", "Pharmacy"
- Frontend normalizes to: "Patient", "Doctor", "Laboratory", "Pharmacy", "Instructor", "Student", "Admin", "Super Admin", "Security"
- Use `normalizeRoleName()` when storing/comparing roles
- Use helper functions: `isPatientRole()`, `isDoctorRole()`, `isLabRole()`, `isPharmacyRole()`, etc.

**Role-Specific UI** (`lib/screens/tabs.dart`, `lib/navigators/bottom_tabs.dart`):
- Each role has a different dashboard and navigation structure
- Patient: Home, Appointments, Chat, Profile
- Doctor: Dashboard, Appointments, Referrals, Profile
- Laboratory: Console, Bookings, Referrals, Profile
- Pharmacy: Console, Orders, Referrals, Profile
- Admin: Console, Management, Referrals, Profile

**Public vs Admin-Created Roles**:
- Public signup: Only Patient and Doctor roles available
- Admin-created: Laboratory, Pharmacy, Instructor, Student (created via admin panel)
- Doctors require admin approval after signup before account activation

### Healthcare Workflow Engine

**Core Concept** (`lib/services/healthcare_workflow_service.dart`):

The workflow engine orchestrates the connected virtual hospital ecosystem. When a doctor completes a consultation, it automatically:
1. Sends lab test requests to laboratories
2. Sends prescriptions to pharmacies (if patient requests fulfillment)
3. Assigns health programs to patients
4. Creates referrals to specialists
5. Updates all relevant dashboards
6. Creates audit logs

**Trigger Point**: `processConsultationCompletion(Consultation consultation)`

This is event-driven architecture - completing a consultation triggers cascading actions across the entire system.

### State Management

**Riverpod Providers** (`lib/providers/`):
- `authProvider`: User authentication state, token, role, user data
- `chatProvider`: Chat conversations and messages
- `commonProvider`: Shared UI state

**Auth State Persistence** (`lib/utils/shared_pref.dart`):
- Token stored in SharedPreferences
- User data cached locally
- Role cached for quick access
- On app restart, `lib/app.dart` loads cached state before showing UI

### API Service Layer

**Base Service** (`lib/services/api_service.dart`):
- Singleton pattern with Dio HTTP client
- Automatic token injection from SharedPreferences
- 30-second timeout for all requests
- Supports GET, POST, PUT, DELETE, and multipart uploads

**API Configuration** (`lib/services/api_config.dart`):
- Base URL: `https://icare-backend-delta.vercel.app/api`
- Endpoint constants for auth, users, doctors, appointments, pharmacy

**Service Pattern**:
```dart
// All services follow this pattern:
1. Try backend API call
2. On network error → fallback to StandaloneCareHubService
3. On server error → return error message
4. Parse response and return standardized format
```

### Data Models

**Backend Response Handling**:
- Backend returns flat appointment data: `{ appointment_date, doctor_name, patient_name, ... }`
- Models handle both flat backend format and nested standalone format
- See `lib/models/appointment_detail.dart` for example of dual-format parsing

**Key Models**:
- `Appointment`: Basic appointment data
- `AppointmentDetail`: Enriched with doctor/patient details
- `Doctor`: Handles both `doctorId` (int) and `_id` (string) from backend
- `Consultation`: SOAP notes structure (Subjective, Objective, Assessment, Plan)
- `LabTestRequest`: Lab workflow with status tracking
- `Prescription`: Pharmacy workflow
- `HealthProgramAssignment`: LMS integration

## Important Patterns and Conventions

### Error Handling

**User-Friendly Messages** (`lib/services/error_handling_service.dart`):
- Never expose DioException to users
- Convert technical errors to healthcare-appropriate messages
- Network errors: "Unable to connect. Please check your internet connection."
- Server errors: Extract message from response or provide generic fallback

### Appointment Booking

**Doctor ID Handling**:
- Backend expects `doctorId` as integer
- Frontend may have string IDs from various sources
- Always use: `int.tryParse(doctorId) ?? doctorId` when sending to backend
- See `lib/services/appointment_service.dart:23`

### Chat System

**Real-Time Messaging** (`lib/services/chat_service.dart`, `lib/services/pusher_service.dart`):
- Backend uses Pusher for real-time events
- Frontend has Pusher service ready (currently commented out, needs `pusher_channels_flutter` package)
- Chat works via polling without Pusher, but real-time requires package installation
- See `CHAT_IMPLEMENTATION_GUIDE.md` for integration details

### Firebase Integration

**Platform-Specific Initialization** (`lib/main.dart`):
- Firebase only initialized on mobile platforms (Android/iOS)
- Web skips Firebase initialization (no config available)
- FCM service handles push notifications on mobile

### Responsive Design

**Breakpoints** (`lib/main.dart`):
- Mobile: 0-600px
- Tablet: 600-900px
- Desktop: 901-1920px
- 4K: 1921px+

**Adaptive Layouts** (`lib/adaptive_layout/`):
- Separate layouts for mobile, tablet, desktop
- Use `MediaQuery.of(context).size.width` to determine layout
- Max width constraint of 430px for mobile-optimized views on web

## Backend Integration Notes

### Authentication Flow

1. User registers/logs in → receives JWT token
2. Token stored in SharedPreferences
3. Token automatically injected into all API requests via `ApiService`
4. On app restart, token loaded from cache
5. If token exists, user auto-logged in to dashboard

### Appointment Status Flow

Backend statuses: `pending`, `accepted`, `rejected`, `completed`, `cancelled`

Doctor workflow:
- Patient books → status: `pending`
- Doctor accepts → status: `accepted`
- Doctor rejects → status: `rejected`
- Appointment happens → status: `completed`
- Either party cancels → status: `cancelled`

### Lab Test Workflow

1. Doctor orders test during consultation → creates `LabTestRequest`
2. Lab dashboard shows pending requests
3. Lab accepts → status: `accepted`, begins processing
4. Lab uploads report → status: `completed`
5. Patient and doctor can view results

**Status Enum**: `pending`, `accepted`, `inProgress`, `completed`, `rejected`

### Pharmacy Order Workflow

1. Doctor creates prescription during consultation
2. Patient chooses: buy independently OR request pharmacy fulfillment
3. If fulfillment requested → creates `PharmacyOrder`
4. Pharmacy dashboard shows incoming orders
5. Pharmacy accepts → prepares medicines → dispatches → completed

## Common Development Tasks

### Adding a New Role-Specific Screen

1. Create screen in `lib/screens/`
2. Add route in `lib/screens/tabs.dart` based on role
3. Update `lib/navigators/bottom_tabs.dart` if adding to navigation
4. Use role helper functions: `isPatientRole(role)`, `isDoctorRole(role)`, etc.

### Adding a New API Endpoint

1. Add endpoint constant to `lib/services/api_config.dart`
2. Create/update service in `lib/services/`
3. Implement backend call with error handling
4. Add fallback to `StandaloneCareHubService` for network errors
5. Return standardized format: `{ 'success': bool, 'data': ..., 'message': ... }`

### Modifying Appointment Logic

Key files:
- `lib/services/appointment_service.dart` - API calls
- `lib/models/appointment.dart` - Basic model
- `lib/models/appointment_detail.dart` - Enriched model with doctor/patient details
- `lib/screens/book_appointment.dart` - Booking UI
- `lib/screens/my_appointments_list.dart` - Patient view
- `lib/screens/doctor_appointments.dart` - Doctor view

### Working with the Workflow Engine

To trigger workflows after consultation:
```dart
final result = await HealthcareWorkflowService()
  .processConsultationCompletion(consultation);

// Result contains:
// - labTestsCreated, labTestRequestIds
// - prescriptionsCreated, prescriptionIds
// - healthProgramsAssigned, healthProgramAssignmentIds
// - referralCreated, referralId
```

## Known Issues and Limitations

- Pusher real-time chat requires `pusher_channels_flutter` package (currently commented out)
- Firebase only works on mobile (no web config)
- Some features have UI but need backend API implementation (see `IMPLEMENTATION_STATUS.md`)
- Backend appointment format is flat, not nested - models handle both formats
- Doctor ID type inconsistency (int vs string) - always use `int.tryParse()` when sending to backend

## Testing Credentials

Backend may have test accounts. For standalone mode, any email/password works for demo purposes (handled by `StandaloneCareHubService`).

## Additional Documentation

- `IMPLEMENTATION_STATUS.md` - Detailed feature completion status
- `RUN_GUIDE.md` - Step-by-step setup instructions
- `CHAT_IMPLEMENTATION_GUIDE.md` - Chat feature integration guide
- `REQUIREMENTS_GAP_ANALYSIS.md` - Feature requirements analysis

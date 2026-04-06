# 🚀 ICare Virtual Hospital - Run Guide

## Prerequisites

1. **Flutter SDK** installed (version 3.9.0 or higher)
2. **Android Studio** or **VS Code** with Flutter extensions
3. **Android Emulator** or **Physical Device** connected
4. **Git** installed

## Step 1: Install Dependencies

Open your terminal/command prompt in the project directory and run:

```bash
cd D:\ICare_final
flutter pub get
```

This will download all required packages from pubspec.yaml.

## Step 2: Check Flutter Environment

```bash
flutter doctor
```

Make sure you have:
- ✓ Flutter SDK
- ✓ Android toolchain
- ✓ Connected device or emulator

## Step 3: Run the Project

### Option A: Using Command Line

```bash
# For Android
flutter run

# For Windows Desktop
flutter run -d windows

# For Web
flutter run -d chrome
```

### Option B: Using VS Code

1. Open the project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select your target device from the bottom right

### Option C: Using Android Studio

1. Open the project in Android Studio
2. Select your target device from the device dropdown
3. Click the green "Run" button

## Step 4: Build for Release (Optional)

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Windows Desktop
```bash
flutter build windows --release
```
Output: `build/windows/runner/Release/`

## 🎯 Testing the Virtual Hospital Features

Once the app is running, you can test:

### 1. **Login & Authentication**
- Try patient and doctor roles
- Test email verification flow
- Enable 2FA in security settings

### 2. **Doctor Consultation Flow**
- Login as doctor
- Create a consultation with 4-step workflow
- Complete consultation to trigger workflow engine

### 3. **Lab Service Workflow**
- Login as lab technician (admin must create account)
- View incoming lab test requests
- Accept and process requests

### 4. **Pharmacy Fulfillment**
- Login as pharmacist (admin must create account)
- View prescription orders
- Process fulfillment workflow

### 5. **Patient Dashboard**
- Login as patient
- View connected ecosystem
- Track prescriptions, lab tests, health programs

### 6. **Admin Panel**
- Login as admin
- Approve doctors
- Create lab, pharmacy, instructor, student accounts

### 7. **Analytics Dashboard**
- View system-wide metrics
- Check clinical quality indicators
- Monitor operational performance

### 8. **Gamification & Lifestyle**
- Track health metrics (BP, blood sugar, weight)
- View achievements and streaks
- Monitor progress

### 9. **Subscription Management**
- View subscription plans
- Explore chronic care packages
- Upgrade subscription

### 10. **Security Settings**
- View security score
- Manage active sessions
- Review login activity

## 🔧 Troubleshooting

### Issue: "Gradle build failed"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "Package not found"
**Solution:**
```bash
flutter pub get
flutter pub upgrade
```

### Issue: "Firebase configuration missing"
**Solution:**
- The app has Firebase dependencies but may not have configuration files
- You can either:
  1. Add Firebase configuration (google-services.json for Android)
  2. Or comment out Firebase imports if not using push notifications

### Issue: "Compilation errors in new files"
**Solution:**
- Some new files may have import issues
- Check the error messages and ensure all referenced files exist
- Run `flutter analyze` to see all issues

## 📱 Sample Login Credentials

Based on the sample data service:

### Patients
- Email: `john.doe@email.com`
- Email: `sarah.johnson@email.com`

### Doctors
- Email: `dr.sarah.johnson@hospital.com` (Cardiology)
- Email: `dr.mike.chen@hospital.com` (General Practice)

### Admin
- Create admin account through backend or use existing credentials

**Note:** Passwords depend on your backend implementation.

## 🎨 UI Features

The app includes:
- ✅ Healthcare-themed design
- ✅ Consistent color scheme (primary color: teal)
- ✅ Loading states with shimmer effects
- ✅ Empty states with helpful messages
- ✅ Error handling with user-friendly messages
- ✅ Status badges and info cards
- ✅ Pull-to-refresh functionality
- ✅ Responsive layouts

## 📊 Backend Integration

The app is designed to work with a backend API. Make sure:
1. Backend server is running
2. API endpoints are configured correctly
3. Base URL is set in your API service

## 🚨 Known Limitations

1. **Voice API & Multi-language** - Not yet implemented (Task #9)
2. **Backend Required** - Most features need backend API
3. **Firebase Setup** - May need configuration for push notifications
4. **Sample Data** - Currently uses mock data, needs backend integration

## 📞 Support

If you encounter issues:
1. Check Flutter version: `flutter --version`
2. Run diagnostics: `flutter doctor -v`
3. Clean and rebuild: `flutter clean && flutter pub get`
4. Check error logs in the console

---

**Happy Testing! 🏥**

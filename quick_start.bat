@echo off
echo ========================================
echo ICare Virtual Hospital - Quick Start
echo ========================================
echo.

echo Step 1: Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev
    pause
    exit /b 1
)
echo.

echo Step 2: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo Step 3: Checking for connected devices...
flutter devices
echo.

echo Step 4: Running Flutter analyze...
flutter analyze
echo.

echo ========================================
echo Ready to run! Choose an option:
echo ========================================
echo 1. Run on Android device/emulator
echo 2. Run on Windows desktop
echo 3. Run on Chrome (web)
echo 4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo.
    echo Starting on Android...
    flutter run
) else if "%choice%"=="2" (
    echo.
    echo Starting on Windows...
    flutter run -d windows
) else if "%choice%"=="3" (
    echo.
    echo Starting on Chrome...
    flutter run -d chrome
) else (
    echo Exiting...
    exit /b 0
)

pause

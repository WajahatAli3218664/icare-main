import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/providers/auth_provider.dart';
import 'package:icare/screens/bookings.dart';
import 'package:icare/screens/bookings_history.dart';
import 'package:icare/screens/courses.dart';
import 'package:icare/screens/notifications.dart';
import 'package:icare/screens/doctor_appointments.dart';
import 'package:icare/screens/doctor_schedule_calendar.dart';
import 'package:icare/screens/doctor_analytics.dart';
import 'package:icare/screens/doctor_notifications.dart';
import 'package:icare/screens/doctor_reviews.dart';
import 'package:icare/screens/doctor_availability.dart';
import 'package:icare/screens/doctor_profile_setup.dart';
import 'package:icare/screens/help_and_support.dart';
import 'package:icare/screens/health_tracker.dart';
import 'package:icare/screens/phase3_gamification_screen.dart';
import 'package:icare/screens/phase3_language_voice_screen.dart';
import 'package:icare/screens/phase3_admin_ops_screen.dart';
import 'package:icare/screens/phase4_analytics_screen.dart';
import 'package:icare/screens/phase4_security_hardening_screen.dart';
import 'package:icare/screens/phase4_referral_center_screen.dart';
import 'package:icare/screens/phase4_chronic_care_screen.dart';
import 'package:icare/screens/phase4_qa_completion_screen.dart';
import 'package:icare/screens/patient_records_list.dart';
import 'package:icare/screens/lab_bookings_management.dart';
import 'package:icare/screens/lab_reports_screen.dart';
import 'package:icare/screens/lab_list.dart';
import 'package:icare/screens/lab_appointment.dart';
import 'package:icare/screens/login.dart';
import 'package:icare/screens/my_appointment.dart';
import 'package:icare/screens/my_appointments_list.dart';
import 'package:icare/screens/my_learning.dart';
import 'package:icare/screens/my_orders.dart';
import 'package:icare/screens/payment_invoices.dart';
import 'package:icare/screens/pharmacies.dart';
import 'package:icare/screens/pharmacy_management.dart';
import 'package:icare/screens/pharmacist_dashboard.dart';
import 'package:icare/screens/pharmacy_inventory.dart';
import 'package:icare/screens/pharmacy_orders.dart';
import 'package:icare/screens/pharmacy_analytics.dart';
import 'package:icare/screens/pharmacy_profile_setup.dart';
import 'package:icare/screens/laboratory_dashboard.dart';
import 'package:icare/screens/lab_bookings_management.dart';
import 'package:icare/screens/lab_tests_management.dart';
import 'package:icare/screens/lab_analytics.dart';
import 'package:icare/screens/lab_profile_setup.dart';
import 'package:icare/screens/prescriptions.dart';
import 'package:icare/screens/reminder_list.dart';
import 'package:icare/screens/settings.dart';
import 'package:icare/screens/tabs.dart';
import 'package:icare/screens/tasks.dart';
import 'package:icare/screens/view_profile.dart';
import 'package:icare/screens/wallet.dart';
import 'package:icare/screens/lab_reports_screen.dart';
import 'package:icare/screens/student_profile_setup.dart';
import 'package:icare/screens/admin_dashboard.dart';
import 'package:icare/screens/clinical_audit_screen.dart';
import 'package:icare/screens/referrals_screen.dart';
import 'package:icare/screens/security_console_screen.dart';
import 'package:icare/screens/subscription_plans_screen.dart';
import 'package:icare/screens/upload_course.dart';
import 'package:icare/screens/products_screen.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/role_ui.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(authProvider).userRole;

    var drawerItems = [
      _drawerItem('Tasks', Icons.task_alt_rounded, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen()));
      }),
      _drawerItem('Booking History', Icons.history_rounded, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const BookingsScreen()));
      }),
      _drawerItem('Reminders', Icons.alarm_rounded, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ReminderList()));
      }),
      _drawerItem('Help & Support', Icons.help_outline_rounded, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
      }),
      _drawerItem('Wallet', Icons.account_balance_wallet_rounded, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const WalletScreen()));
      }),
      _drawerItem(coursesLabelForRole(selectedRole), Icons.school_rounded, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Courses()));
      }),
    ];

    if (isLabRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Dashboard', Icons.dashboard_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
        }),
        _drawerItem('Test Requests', Icons.biotech_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabBookingsManagement()));
        }),
        _drawerItem('Manage Tests', Icons.science_outlined, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabTestsManagement()));
        }),
        _drawerItem('Upload Reports', Icons.upload_file_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabReportsScreen()));
        }),
        _drawerItem('Analytics', Icons.analytics_outlined, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabAnalytics()));
        }),
        _drawerItem('Payment Invoices', Icons.receipt_long_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PaymentInvoices()));
        }),
        _drawerItem('Tasks', Icons.task_alt_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen()));
        }),
        _drawerItem('Notifications', Icons.notifications_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
      ];
    } else if (isPatientRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Dashboard', Icons.dashboard_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
        }),
        _drawerItem('Bookings History', Icons.history_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const BookingsHistoryScreen()));
        }),
        _drawerItem('Tasks', Icons.task_alt_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen()));
        }),
        _drawerItem('Book a Lab', Icons.science_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabsListScreen()));
        }),
        _drawerItem('Lab Results/Reports', Icons.biotech_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabReportsScreen()));
        }),
        _drawerItem('Appointments', Icons.calendar_month_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyAppointmentsListScreen()));
        }),
        _drawerItem('Pharmacies', Icons.medication_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmaciesScreen()));
        }),
        _drawerItem('Reminders', Icons.alarm_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ReminderList()));
        }),
        _drawerItem(coursesLabelForRole(selectedRole), Icons.school_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Courses()));
        }),
        _drawerItem('Lifestyle Tracking', Icons.monitor_heart_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HealthTracker()));
        }),
        _drawerItem('Motivation & Rewards', Icons.workspace_premium_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3GamificationScreen()));
        }),
        _drawerItem('Language & Voice', Icons.record_voice_over_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3LanguageVoiceScreen()));
        }),
        _drawerItem('Plans & Care Packages', Icons.workspace_premium_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SubscriptionPlansScreen()));
        }),
        _drawerItem('Chronic Care Programs', Icons.favorite_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4ChronicCareScreen()));
        }),
        _drawerItem('Referral Updates', Icons.swap_horizontal_circle_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4ReferralCenterScreen()));
        }),
        _drawerItem('Settings', Icons.settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }),
      ];
    } else if (isDoctorRole(selectedRole)) {
      drawerItems = [
        _drawerItem('My Appointments', Icons.calendar_month_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorAppointmentsScreen()));
        }),
        _drawerItem('My Schedule', Icons.schedule_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorScheduleCalendar()));
        }),
        _drawerItem('Patient Records', Icons.folder_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PatientRecordsListScreen()));
        }),
        _drawerItem('Referral Center', Icons.swap_horizontal_circle_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4ReferralCenterScreen()));
        }),
        _drawerItem('Clinical Audit & QA', Icons.fact_check_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4QaCompletionScreen()));
        }),
        _drawerItem('Lifestyle Monitoring', Icons.monitor_heart_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HealthTracker()));
        }),
        _drawerItem('Language & Voice', Icons.record_voice_over_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3LanguageVoiceScreen()));
        }),
        _drawerItem('Analytics', Icons.analytics_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4AnalyticsScreen()));
        }),
        _drawerItem('Reviews', Icons.star_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorReviews()));
        }),
        _drawerItem('Availability', Icons.event_available_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorAvailability()));
        }),
        _drawerItem('Notifications', Icons.notifications_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorNotifications()));
        }),
        _drawerItem('My Profile', Icons.person_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorProfileSetup()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
        _drawerItem('Language & Voice', Icons.record_voice_over_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3LanguageVoiceScreen()));
        }),
        _drawerItem('Settings', Icons.settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }),
      ];
    } else if (isPharmacyRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Dashboard', Icons.dashboard_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacistDashboard()));
        }),
        _drawerItem('Incoming Prescriptions', Icons.description_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacyOrders()));
        }),
        _drawerItem('Inventory Management', Icons.inventory_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacyInventory()));
        }),
        _drawerItem('Order Fulfillment', Icons.shopping_basket_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyOrdersScreen()));
        }),
        _drawerItem('Analytics', Icons.analytics_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacyAnalytics()));
        }),
        _drawerItem('Payment Invoices', Icons.receipt_long_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PaymentInvoices()));
        }),
        _drawerItem('Tasks', Icons.task_alt_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen()));
        }),
        _drawerItem('Notifications', Icons.notifications_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
        }),
        _drawerItem('Profile Setup', Icons.edit_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacyProfileSetup()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
      ];
    } else if (isLabRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Dashboard', Icons.dashboard_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LaboratoryDashboard()));
        }),
        _drawerItem('Profile Setup', Icons.edit_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabProfileSetup()));
        }),
        _drawerItem('Test Requests', Icons.calendar_today_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabBookingsManagement()));
        }),
        _drawerItem('Tests Management', Icons.science_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabTestsManagement()));
        }),
        _drawerItem('Analytics', Icons.analytics_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabAnalytics()));
        }),
        _drawerItem('Payment Invoices', Icons.receipt_long_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PaymentInvoices()));
        }),
        _drawerItem('Tasks', Icons.task_alt_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen()));
        }),
        _drawerItem('Appointments', Icons.calendar_month_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyAppointment()));
        }),
        _drawerItem('Notifications', Icons.notifications_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
        _drawerItem('Language & Voice', Icons.record_voice_over_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3LanguageVoiceScreen()));
        }),
        _drawerItem('Settings', Icons.settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }),
      ];
    } else if (isAdminRole(selectedRole) || isSuperAdminRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Admin Command Center', Icons.dashboard_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AdminDashboard()));
        }),
        _drawerItem('Clinical Audit & QA', Icons.fact_check_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4QaCompletionScreen()));
        }),
        _drawerItem('Referral Center', Icons.swap_horizontal_circle_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4ReferralCenterScreen()));
        }),
        _drawerItem('Security Console', Icons.security_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4SecurityHardeningScreen()));
        }),
        _drawerItem('Phase 3 Ops Center', Icons.admin_panel_settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3AdminOpsScreen()));
        }),
        _drawerItem('Enterprise Analytics', Icons.analytics_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4AnalyticsScreen()));
        }),
        _drawerItem('Language & Voice', Icons.record_voice_over_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3LanguageVoiceScreen()));
        }),
        _drawerItem('Settings', Icons.settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }),
      ];
    } else if (isSecurityRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Security Console', Icons.security_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4SecurityHardeningScreen()));
        }),
        _drawerItem('Clinical Audit & QA', Icons.fact_check_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4QaCompletionScreen()));
        }),
        _drawerItem('Referral Center', Icons.swap_horizontal_circle_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4ReferralCenterScreen()));
        }),
        _drawerItem('Phase 3 Ops Center', Icons.admin_panel_settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase3AdminOpsScreen()));
        }),
        _drawerItem('Enterprise Analytics', Icons.analytics_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Phase4AnalyticsScreen()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
      ];
    } else if (isInstructorRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Dashboard', Icons.dashboard_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
        }),
        _drawerItem('My Courses', Icons.school_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Courses()));
        }),
        _drawerItem('Create Course', Icons.add_circle_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const UploadCourseScreen()));
        }),
        _drawerItem('Student Progress', Icons.people_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyLearningScreen()));
        }),
        _drawerItem('Tasks', Icons.task_alt_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen()));
        }),
        _drawerItem('Notifications', Icons.notifications_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
        _drawerItem('Settings', Icons.settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }),
      ];
    } else if (isStudentRole(selectedRole)) {
      drawerItems = [
        _drawerItem('Pharmacies', Icons.medication_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmaciesScreen()));
        }),
        _drawerItem('Reports & Lab Results', Icons.biotech_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabsListScreen()));
        }),
        _drawerItem('Help & Support', Icons.help_outline_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HelpAndSupport()));
        }),
        _drawerItem('Settings', Icons.settings_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }),
        _drawerItem('Profile Setup', Icons.person_rounded, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const StudentProfileSetup()));
        }),
      ];
    }
    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(40)),
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Close button (top-right)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Profile section with border and edit icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigate to role-specific profile setup or view profile
                      if (isLabRole(selectedRole)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const LabProfileSetup()),
                        );
                      } else if (isPharmacyRole(selectedRole)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const PharmacyProfileSetup()),
                        );
                      } else if (isStudentRole(selectedRole)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const StudentProfileSetup()),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => ViewProfile()),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage(ImagePaths.user7),
                      ),
                    ),
                  ),
                  Positioned(
                    // bottom: 4,
                    top: ScallingConfig.verticalScale(5),
                    right: ScallingConfig.scale(5),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, child) {
                  final userName = ref.watch(authProvider).user?.name ?? 'User';
                  return Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final userEmail = ref.watch(authProvider).user?.email ?? '';
                  return Text(
                    userEmail,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  );
                },
              ),
              const SizedBox(height: 25),

              // Menu list (exact items)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _drawerItem('Home', Icons.home_rounded, () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
                    }, isActive: true),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: CustomText(
                        text: "ROLE ACTIONS",
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 1.5,
                      ),
                    ),
                    
                    _drawerActionItem(context, selectedRole, quickActionPrimaryLabel(selectedRole), const Color(0xFF6366F1)),
                    _drawerActionItem(context, selectedRole, quickActionSecondaryLabel(selectedRole), const Color(0xFF0EA5E9)),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: CustomText(
                        text: "NAVIGATION",
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 1.5,
                      ),
                    ),

                    // _drawerItem('Reports/Lab Results', () {}),
                    ...drawerItems,
                  ],
                ),
              ),

              // Logout button
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: CustomButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  },
                  width: Utils.windowWidth(context) * 0.6,
                  borderRadius: 30,
                  label: "Logout",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: isActive ? AppColors.primaryColor.withValues(alpha: 0.08) : null,
        dense: true,
        leading: Icon(
          icon,
          size: 20,
          color: isActive ? AppColors.primaryColor : const Color(0xFF64748B),
        ),
        title: CustomText(
          text: title,
          fontFamily: "Gilroy-Bold",
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
          color: isActive ? AppColors.primaryColor : const Color(0xFF0F172A),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _drawerActionItem(BuildContext context, String role, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          if (title == quickActionPrimaryLabel(role)) {
            if (isDoctorRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PatientRecordsListScreen()));
            } else if (isLabRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabBookingsManagement()));
            } else if (isPharmacyRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacyOrders()));
            } else if (isInstructorRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Courses()));
            } else if (isStudentRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyLearningScreen()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
            }
          } else {
            if (isDoctorRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorScheduleCalendar()));
            } else if (isLabRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabBookingsManagement()));
            } else if (isPharmacyRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PharmacyInventory()));
            } else if (isInstructorRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Courses()));
            } else if (isStudentRole(role)) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyLearningScreen()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LabReportsScreen()));
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flash_on_rounded, size: 12, color: color),
              ),
              const SizedBox(width: 12),
              CustomText(
                text: title,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/screens/about_us.dart';
import 'package:icare/screens/change_password.dart';
import 'package:icare/screens/demo_users_screen.dart';
import 'package:icare/screens/login.dart';
import 'package:icare/screens/notification_settings.dart';
import 'package:icare/screens/privacy_policy.dart';
import 'package:icare/screens/reset_password.dart';
import 'package:icare/screens/terms_and_conditions.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/app_modals.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Security toggles (client req — 2FA, biometric, remember device)
  bool _twoFactor = false;
  bool _biometric = false;
  bool _rememberDevice = true;

  void _showContactDialog() {
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Update Contact Info', style: TextStyle(fontWeight: FontWeight.w700)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined))),
        const SizedBox(height: 12),
        TextField(controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () { Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Contact info updated successfully'),
              backgroundColor: Color(0xFF10B981), behavior: SnackBarBehavior.floating));
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
          child: const Text('Save', style: TextStyle(color: Colors.white))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _settingsList = [
      {
        "id": "1",
        "title": "Notifications",
        "onPress": () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NotificationSettings()));
        },
      },
      {
        "id": "7",
        "title": "Demo User Accounts",
        "onPress": () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DemoUsersScreen()));
        },
      },
      {
        "id": "6",
        "title": "Update Contact Info",
        "onPress": () => _showContactDialog(),
      },
      {
        "id": "2",
        "title": "Change Password",
        "onPress": () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => ChangePassword()));
        },
      },
      {
        "id": "3",
        "title": "Privacy Policy",
        "onPress": () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => PrivacyPolicy()));
        },
      },
      {
        "id": "4",
        "title": "About Us",
        "onPress": () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => AboutUs()));
        },
      },
      {
        "id": "5",
        "title": "Terms & Conditions",
        "onPress": () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => TermsAndConditions()));
        },
      },
    ];
    if (MediaQuery.of(context).size.width > 600) {
      return _WebSettingsScreen(settingsList: _settingsList);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: CustomText(
          text: "Settings",
          fontWeight: FontWeight.bold,
          letterSpacing: -0.31,
          lineHeight: 1.0,
          fontSize: 16.78,
          fontFamily: "Gilroy-Bold",
          color: AppColors.primary500,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Security section (client req)
            const Align(alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(bottom: 8),
                child: Text('Security', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8), letterSpacing: 0.8)))),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                _securityToggle('Two-Factor Authentication', 'Extra security on login',
                    Icons.security_rounded, const Color(0xFF0036BC), _twoFactor,
                    (v) => setState(() => _twoFactor = v)),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _securityToggle('Biometric Login', 'Fingerprint or Face ID',
                    Icons.fingerprint_rounded, const Color(0xFF10B981), _biometric,
                    (v) => setState(() => _biometric = v)),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _securityToggle('Remember This Device', 'Stay logged in automatically',
                    Icons.devices_rounded, const Color(0xFF8B5CF6), _rememberDevice,
                    (v) => setState(() => _rememberDevice = v)),
              ]),
            ),
            const Align(alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(bottom: 8),
                child: Text('Account', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8), letterSpacing: 0.8)))),
            Container(
              width: Utils.windowWidth(context) * 0.85,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: _settingsList.map((item) {
                  return GestureDetector(
                    onTap: item["onPress"],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            // vertical: 12.0,
                            horizontal: 18.0,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: item["title"],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primary500,
                                fontFamily: "Gilroy-SemiBold",
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        if (item['id'] != "5")
                          const Divider(
                            color: AppColors.darkGreyColor,
                            thickness: 0.2,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: Utils.windowHeight(context) * 0.4),
            CustomButton(
              borderRadius: 30,
              onPressed: () {
                AppDialogs.showWarningDialog(
                  context,
                  "Are you sure do you want to delete your account",
                  null,
                  [
                    "I don’t need it anymore",
                    "I don’t find it useful",
                    "Other",
                  ],
                  numOfActions: 2,
                  onPrimaryButtonPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  },
                );
              },
              label: "Delete Account",
            ),
            // SizedBox(height: ScallingConfig.scale(100),)
          ],
        ),
      ),
    );
  }
  Widget _securityToggle(String title, String subtitle, IconData icon, Color color,
      bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ])),
        Switch(value: value, onChanged: onChanged, activeColor: color),
      ]),
    );
  }

}

// ═══════════════════════════════════════════════════════════════════════════
// NEW STUNNING WEB VIEW
// ═══════════════════════════════════════════════════════════════════════════

class _WebSettingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> settingsList;

  const _WebSettingsScreen({required this.settingsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: CustomText(
          text: "Account Settings",
          fontFamily: "Gilroy-Bold",
          fontSize: 20,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.31,
          lineHeight: 1.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left Side: Profile Sidebar / Header ──
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Preferences & Security", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: "Gilroy-Bold", color: Color(0xFF1E293B))),
                      const SizedBox(height: 12),
                      const Text("Manage your account settings, view legal documents, and configure your notification preferences.", style: TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.5)),
                      
                      const SizedBox(height: 48),
                      
                      // Delete Account Zone
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Danger Zone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: "Gilroy-Bold", color: Color(0xFFDC2626))),
                            const SizedBox(height: 8),
                            const Text("Permanently delete your account and all associated data.", style: TextStyle(fontSize: 13, color: Color(0xFF991B1B))),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFDC2626), 
                                  side: const BorderSide(color: Color(0xFFDC2626)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  AppDialogs.showWarningDialog(
                                    context,
                                    "Are you sure you want to delete your account?",
                                    null,
                                    ["I don’t need it anymore", "I don’t find it useful", "Other"],
                                    numOfActions: 2,
                                    onPrimaryButtonPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
                                    },
                                  );
                                },
                                child: const Text("Delete Account", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 48),

                // ── Right Side: Settings List ──
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF1F4F9), width: 1.5),
                      boxShadow: const [BoxShadow(color: Color(0x05000000), offset: Offset(0, 4), blurRadius: 16)],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: settingsList.length,
                      separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1.5, indent: 24, endIndent: 24),
                      itemBuilder: (context, index) {
                        final item = settingsList[index];
                        final isLast = index == settingsList.length - 1;
                        final isFirst = index == 0;
                        
                        // Map specific icons to settings
                        IconData iconData = Icons.settings_rounded;
                        Color iconColor = const Color(0xFF64748B);
                        Color bgColor = const Color(0xFFF8FAFC);
                        
                        if (item['title'].toString().contains("Notification")) { iconData = Icons.notifications_active_rounded; iconColor = const Color(0xFF3B82F6); bgColor = const Color(0xFFEFF6FF); }
                        else if (item['title'].toString().contains("Password")) { iconData = Icons.lock_rounded; iconColor = const Color(0xFF8B5CF6); bgColor = const Color(0xFFF5F3FF); }
                        else if (item['title'].toString().contains("Privacy")) { iconData = Icons.shield_rounded; iconColor = const Color(0xFF10B981); bgColor = const Color(0xFFECFDF5); }
                        else if (item['title'].toString().contains("About")) { iconData = Icons.info_rounded; iconColor = const Color(0xFFF59E0B); bgColor = const Color(0xFFFEF3C7); }
                        else if (item['title'].toString().contains("Terms")) { iconData = Icons.gavel_rounded; iconColor = const Color(0xFF64748B); bgColor = const Color(0xFFF1F5F9); }

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: item["onPress"],
                            borderRadius: BorderRadius.vertical(
                              top: isFirst ? const Radius.circular(20) : Radius.zero,
                              bottom: isLast ? const Radius.circular(20) : Radius.zero,
                            ),
                            hoverColor: const Color(0xFFF8FAFC),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                                    child: Icon(iconData, color: iconColor, size: 22),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      item["title"] as String,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: "Gilroy-SemiBold"),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0)), shape: BoxShape.circle),
                                    child: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

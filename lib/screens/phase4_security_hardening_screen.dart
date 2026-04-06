import 'package:flutter/material.dart';

import '../services/standalone_phase4_service.dart';
import '../utils/theme.dart';

class Phase4SecurityHardeningScreen extends StatefulWidget {
  const Phase4SecurityHardeningScreen({super.key});

  @override
  State<Phase4SecurityHardeningScreen> createState() => _Phase4SecurityHardeningScreenState();
}

class _Phase4SecurityHardeningScreenState extends State<Phase4SecurityHardeningScreen> {
  final StandalonePhase4Service _service = StandalonePhase4Service();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getSecurityCenter();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _service.getSecurityCenter();
    });
  }

  Future<void> _setBool(String key, bool value) async {
    if (key == 'twoFactorEnabled') {
      await _service.toggleTwoFactor(value);
    } else if (key == 'biometricEnabled') {
      await _service.toggleBiometric(value);
    } else if (key == 'emailVerified' && value) {
      await _service.completeEmailVerification();
    } else {
      await _service.updateSecuritySetting(key, value);
    }
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('Security & Verification')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final settings = Map<String, dynamic>.from(data['settings'] as Map? ?? {});
          final devices = List<dynamic>.from(settings['trustedDevices'] as List? ?? []);
          final events = List<dynamic>.from(data['events'] as List? ?? []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  SwitchListTile(
                    title: const Text('Email verified'),
                    subtitle: const Text('Simulated verification flow for account readiness'),
                    value: settings['emailVerified'] == true,
                    onChanged: (value) => _setBool('emailVerified', value),
                  ),
                  SwitchListTile(
                    title: const Text('Two-factor authentication'),
                    subtitle: const Text('OTP-based sign-in hardening for sensitive roles'),
                    value: settings['twoFactorEnabled'] == true,
                    onChanged: (value) => _setBool('twoFactorEnabled', value),
                  ),
                  SwitchListTile(
                    title: const Text('Biometric login'),
                    subtitle: const Text('Enable fingerprint/face access toggle structure'),
                    value: settings['biometricEnabled'] == true,
                    onChanged: (value) => _setBool('biometricEnabled', value),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Trusted devices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  const SizedBox(height: 12),
                  ...devices.map((item) {
                    final device = Map<String, dynamic>.from(item as Map);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.devices_rounded, color: AppColors.primary500),
                      title: Text(device['name']?.toString() ?? '-'),
                      subtitle: Text('Last seen: ${device['lastSeen']?.toString().split('T').first ?? '-'}'),
                    );
                  }),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Security event log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  const SizedBox(height: 12),
                  ...events.take(8).map((item) {
                    final event = Map<String, dynamic>.from(item as Map);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.security_rounded, color: AppColors.primary500),
                      title: Text(event['title']?.toString() ?? '-'),
                      subtitle: Text('${event["details"] ?? ""}\n${event["createdAt"]?.toString().split("T").first ?? "-"}'),
                      isThreeLine: true,
                    );
                  }),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}

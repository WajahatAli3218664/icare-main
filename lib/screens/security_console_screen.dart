import 'package:flutter/material.dart';

import '../services/standalone_care_hub_service.dart';
import '../utils/theme.dart';

class SecurityConsoleScreen extends StatefulWidget {
  const SecurityConsoleScreen({super.key});

  @override
  State<SecurityConsoleScreen> createState() => _SecurityConsoleScreenState();
}

class _SecurityConsoleScreenState extends State<SecurityConsoleScreen> {
  final StandaloneCareHubService _hub = StandaloneCareHubService();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _hub.getSecurityOverview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Console')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final feed = List<dynamic>.from(data['riskFeed'] as List? ?? []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _SecurityCard(title: 'Login Events', value: '${data['loginEvents'] ?? 0}', icon: Icons.login_rounded),
                  _SecurityCard(title: 'Risk Events', value: '${data['riskEvents'] ?? 0}', icon: Icons.warning_amber_rounded),
                  _SecurityCard(title: 'Security Users', value: '${data['securityUsers'] ?? 0}', icon: Icons.security_rounded),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Access & risk feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                    const SizedBox(height: 12),
                    ...feed.map((item) {
                      final event = Map<String, dynamic>.from(item as Map);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            const Icon(Icons.shield_moon_rounded, color: AppColors.primary500),
                            const SizedBox(width: 10),
                            Expanded(child: Text('${event['action'] ?? 'Alert'} • ${event['category'] ?? 'security'}')),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SecurityCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary500)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: AppColors.darkGreyColor)),
      ]),
    );
  }
}

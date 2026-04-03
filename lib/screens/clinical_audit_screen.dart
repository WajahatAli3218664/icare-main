import 'package:flutter/material.dart';

import '../services/standalone_care_hub_service.dart';
import '../utils/theme.dart';

class ClinicalAuditScreen extends StatefulWidget {
  const ClinicalAuditScreen({super.key});

  @override
  State<ClinicalAuditScreen> createState() => _ClinicalAuditScreenState();
}

class _ClinicalAuditScreenState extends State<ClinicalAuditScreen> {
  final StandaloneCareHubService _hub = StandaloneCareHubService();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _hub.getAuditDashboard();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _hub.getAuditDashboard();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinical Audit & QA')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final data = snapshot.data!;
            final events = List<dynamic>.from(data['recentEvents'] as List? ?? []);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatCard(label: 'Total Events', value: '${data['totalEvents'] ?? 0}'),
                    _StatCard(label: 'Today', value: '${data['todayEvents'] ?? 0}'),
                    _StatCard(label: 'Priority Alerts', value: '${data['mediumOrHigher'] ?? 0}'),
                    _StatCard(label: 'Open Referrals', value: '${data['openReferrals'] ?? 0}'),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recent audit trail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                      const SizedBox(height: 12),
                      ...events.map((item) {
                        final event = Map<String, dynamic>.from(item as Map);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(backgroundColor: Colors.blue.shade50, child: const Icon(Icons.fact_check_rounded, color: AppColors.primary500)),
                          title: Text(event['action']?.toString() ?? 'Audit event'),
                          subtitle: Text('${event['category'] ?? 'general'} • ${event['severity'] ?? 'info'}'),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary500)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: AppColors.darkGreyColor)),
      ]),
    );
  }
}

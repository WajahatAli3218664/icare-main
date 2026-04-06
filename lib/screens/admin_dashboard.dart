import 'package:flutter/material.dart';

import '../services/standalone_care_hub_service.dart';
import '../utils/theme.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final StandaloneCareHubService _hub = StandaloneCareHubService();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _hub.getAdminOverview();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _hub.getAdminOverview();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('Admin Command Center')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            final audits = List<dynamic>.from(data['recentAudits'] as List? ?? []);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Phase 2 administration overview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Monitor platform operations, partner readiness, subscriptions, referrals, and clinical governance from one place.',
                  style: TextStyle(color: AppColors.darkGreyColor),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricCard(label: 'Total Users', value: '${data['users'] ?? 0}', icon: Icons.groups_rounded),
                    _MetricCard(label: 'Doctors', value: '${data['doctors'] ?? 0}', icon: Icons.medical_services_rounded),
                    _MetricCard(label: 'Labs', value: '${data['labs'] ?? 0}', icon: Icons.biotech_rounded),
                    _MetricCard(label: 'Pharmacies', value: '${data['pharmacies'] ?? 0}', icon: Icons.local_pharmacy_rounded),
                    _MetricCard(label: 'Active Plans', value: '${data['activeSubscriptions'] ?? 0}', icon: Icons.workspace_premium_rounded),
                    _MetricCard(label: 'Pending Referrals', value: '${data['pendingReferrals'] ?? 0}', icon: Icons.swap_horizontal_circle_rounded),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent governance activity',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500),
                      ),
                      const SizedBox(height: 12),
                      ...audits.take(8).map((event) => _AuditTile(event: Map<String, dynamic>.from(event as Map))),
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

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary500)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.darkGreyColor)),
        ],
      ),
    );
  }
}

class _AuditTile extends StatelessWidget {
  final Map<String, dynamic> event;

  const _AuditTile({required this.event});

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.orange.shade100;
      default:
        return Colors.blue.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severity = (event['severity']?.toString() ?? 'info');
    final actor = Map<String, dynamic>.from(event['actor'] as Map? ?? {});
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _severityColor(severity),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fact_check_rounded, color: AppColors.primary500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['action']?.toString() ?? 'Audit event', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary500)),
                const SizedBox(height: 2),
                Text('${event['category'] ?? 'general'} • ${actor['name'] ?? 'System'}', style: const TextStyle(color: AppColors.darkGreyColor)),
              ],
            ),
          ),
          Text(severity.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

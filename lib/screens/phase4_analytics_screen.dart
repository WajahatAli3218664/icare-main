import 'package:flutter/material.dart';

import '../services/standalone_phase4_service.dart';
import '../utils/theme.dart';

class Phase4AnalyticsScreen extends StatefulWidget {
  const Phase4AnalyticsScreen({super.key});

  @override
  State<Phase4AnalyticsScreen> createState() => _Phase4AnalyticsScreenState();
}

class _Phase4AnalyticsScreenState extends State<Phase4AnalyticsScreen> {
  final StandalonePhase4Service _service = StandalonePhase4Service();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getAnalyticsDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('Enterprise Analytics')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final headline = Map<String, dynamic>.from(data['headline'] as Map? ?? {});
          final revenue = Map<String, dynamic>.from(data['revenue'] as Map? ?? {});
          final quality = Map<String, dynamic>.from(data['quality'] as Map? ?? {});
          final qaMetrics = List<dynamic>.from(data['qaMetrics'] as List? ?? []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Operational snapshot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary500)),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _MetricCard(label: 'Patients', value: '${headline['patients'] ?? 0}', icon: Icons.groups_rounded),
                _MetricCard(label: 'Active Doctors', value: '${headline['activeDoctors'] ?? 0}', icon: Icons.medical_services_rounded),
                _MetricCard(label: 'Consultations', value: '${headline['consultationsToday'] ?? 0}', icon: Icons.video_call_rounded),
                _MetricCard(label: 'Lab Requests', value: '${headline['labRequestsToday'] ?? 0}', icon: Icons.biotech_rounded),
                _MetricCard(label: 'Orders', value: '${headline['pharmacyOrdersToday'] ?? 0}', icon: Icons.local_pharmacy_rounded),
              ]),
              const SizedBox(height: 18),
              const Text('Revenue channels', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary500)),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _MetricCard(label: 'Subscriptions', value: 'Rs ${revenue['subscriptionRevenue'] ?? 0}', icon: Icons.workspace_premium_rounded),
                _MetricCard(label: 'Consultations', value: 'Rs ${revenue['consultationRevenue'] ?? 0}', icon: Icons.receipt_long_rounded),
                _MetricCard(label: 'Pharmacy', value: 'Rs ${revenue['pharmacyRevenue'] ?? 0}', icon: Icons.shopping_bag_rounded),
                _MetricCard(label: 'Laboratory', value: 'Rs ${revenue['labRevenue'] ?? 0}', icon: Icons.science_rounded),
              ]),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Quality & usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  const SizedBox(height: 12),
                  Text('Average lab turnaround: ${quality['avgLabTurnaroundHours'] ?? 0} hours'),
                  Text('Prescription fulfillment: ${quality['prescriptionFulfillmentRate'] ?? 0}%'),
                  Text('Consultation completion: ${quality['consultationCompletionRate'] ?? 0}%'),
                  Text('Daily logins: ${quality['dailyLogins'] ?? 0}'),
                  Text('Care plan engagement: ${quality['carePlanEngagement'] ?? 0}%'),
                ]),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('QA metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  const SizedBox(height: 12),
                  ...qaMetrics.map((item) {
                    final metric = Map<String, dynamic>.from(item as Map);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.fact_check_rounded, color: AppColors.primary500),
                      title: Text(metric['label']?.toString() ?? '-'),
                      subtitle: Text('Current: ${metric['value'] ?? 0}% • Target: ${metric['target'] ?? 0}%'),
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

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: AppColors.primary500),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary500)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.darkGreyColor)),
      ]),
    );
  }
}

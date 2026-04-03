import 'package:flutter/material.dart';

import '../services/standalone_phase4_service.dart';
import '../utils/theme.dart';

class Phase4ReferralCenterScreen extends StatefulWidget {
  const Phase4ReferralCenterScreen({super.key});

  @override
  State<Phase4ReferralCenterScreen> createState() => _Phase4ReferralCenterScreenState();
}

class _Phase4ReferralCenterScreenState extends State<Phase4ReferralCenterScreen> {
  final StandalonePhase4Service _service = StandalonePhase4Service();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getReferralCenter();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getReferralCenter();
    });
  }

  Future<void> _update(String id, String status) async {
    await _service.updateReferralStatus(id, status);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('Referral Center')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final summary = Map<String, dynamic>.from(data['summary'] as Map? ?? {});
          final referrals = List<dynamic>.from(data['referrals'] as List? ?? []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(spacing: 12, runSpacing: 12, children: [
                _StatBox(label: 'Total', value: '${summary['total'] ?? 0}'),
                _StatBox(label: 'Pending', value: '${summary['pending'] ?? 0}'),
                _StatBox(label: 'Accepted', value: '${summary['accepted'] ?? 0}'),
              ]),
              const SizedBox(height: 16),
              ...referrals.map((item) {
                final referral = Map<String, dynamic>.from(item as Map);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(referral['patientName']?.toString() ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                    const SizedBox(height: 6),
                    Text('From: ${referral['fromDoctor'] ?? '-'}'),
                    Text('Specialty: ${referral['toSpecialty'] ?? '-'}'),
                    Text('Priority: ${referral['priority'] ?? '-'}'),
                    Text('Reason: ${referral['reason'] ?? '-'}'),
                    Text('Status: ${referral['status'] ?? '-'}'),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, children: [
                      OutlinedButton(onPressed: () => _update(referral['_id'].toString(), 'accepted'), child: const Text('Accept')),
                      OutlinedButton(onPressed: () => _update(referral['_id'].toString(), 'rejected'), child: const Text('Reject')),
                      OutlinedButton(onPressed: () => _update(referral['_id'].toString(), 'completed'), child: const Text('Close')),
                    ]),
                  ]),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary500)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.darkGreyColor)),
      ]),
    );
  }
}

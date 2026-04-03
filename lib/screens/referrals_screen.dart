import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../services/standalone_care_hub_service.dart';
import '../utils/role_ui.dart';
import '../utils/theme.dart';

class ReferralsScreen extends ConsumerStatefulWidget {
  const ReferralsScreen({super.key});

  @override
  ConsumerState<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends ConsumerState<ReferralsScreen> {
  final StandaloneCareHubService _hub = StandaloneCareHubService();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _hub.getReferrals();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _hub.getReferrals();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authProvider).userRole;
    return Scaffold(
      appBar: AppBar(title: const Text('Referral Center')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final referrals = snapshot.data!;
            if (referrals.isEmpty) {
              return ListView(children: const [SizedBox(height: 180), Center(child: Text('No referrals available yet.'))]);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: referrals.length,
              itemBuilder: (context, index) {
                final referral = Map<String, dynamic>.from(referrals[index] as Map);
                final patient = Map<String, dynamic>.from(referral['patient'] as Map? ?? {});
                final source = Map<String, dynamic>.from(referral['sourceDoctor'] as Map? ?? {});
                final target = Map<String, dynamic>.from(referral['targetDoctor'] as Map? ?? {});
                final status = referral['status']?.toString() ?? 'pending';
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${referral['specialty'] ?? 'Specialist'} referral • ${patient['name'] ?? 'Patient'}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary500),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: _statusColor(status), borderRadius: BorderRadius.circular(30)),
                            child: Text(status.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('From: ${source['name'] ?? '-'}  →  To: ${target['name'] ?? '-'}'),
                      const SizedBox(height: 4),
                      Text(referral['reason']?.toString() ?? '', style: const TextStyle(color: AppColors.darkGreyColor)),
                      if ((referral['notes']?.toString() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Notes: ${referral['notes']}', style: const TextStyle(color: AppColors.darkGreyColor)),
                      ],
                      if (isDoctorRole(role) || isBackofficeRole(role)) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            _ActionChip(label: 'Accept', onTap: () async { await _hub.updateReferralStatus(referral['_id'].toString(), 'accepted'); await _reload(); }),
                            _ActionChip(label: 'Schedule', onTap: () async { await _hub.updateReferralStatus(referral['_id'].toString(), 'scheduled'); await _reload(); }),
                            _ActionChip(label: 'Complete', onTap: () async { await _hub.updateReferralStatus(referral['_id'].toString(), 'completed'); await _reload(); }),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'completed':
        return Colors.green.shade100;
      case 'scheduled':
        return Colors.blue.shade100;
      default:
        return Colors.orange.shade100;
    }
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Future<void> Function() onTap;

  const _ActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () async => onTap(),
      backgroundColor: AppColors.veryLightGrey,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/standalone_phase3_service.dart';
import '../utils/theme.dart';
import '../widgets/back_button.dart';

class Phase3AdminOpsScreen extends StatefulWidget {
  const Phase3AdminOpsScreen({super.key});

  @override
  State<Phase3AdminOpsScreen> createState() => _Phase3AdminOpsScreenState();
}

class _Phase3AdminOpsScreenState extends State<Phase3AdminOpsScreen> with SingleTickerProviderStateMixin {
  final StandalonePhase3Service _service = StandalonePhase3Service();
  bool _loading = true;
  List<Map<String, dynamic>> _approvals = [];
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _service.ensureSeeded();
    final approvals = await _service.getApprovalQueue();
    final events = await _service.getSecurityEvents();
    if (!mounted) return;
    setState(() {
      _approvals = approvals;
      _events = events;
      _loading = false;
    });
  }

  Future<void> _updateApproval(String id, String status) async {
    await _service.updateApprovalStatus(id, status);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approval moved to $status')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Phase 3 Admin & Security', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const Material(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: AppColors.primaryColor,
                      indicatorColor: AppColors.primaryColor,
                      tabs: [
                        Tab(text: 'Approval Queue'),
                        Tab(text: 'Security Events'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: _approvals.map(_approvalCard).toList(),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: _events.map(_eventCard).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _approvalCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    Text(item['type']?.toString() ?? '-', style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(999)),
                child: Text(item['priority']?.toString() ?? 'normal', style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item['details']?.toString() ?? '-', style: const TextStyle(color: Color(0xFF475569))),
          const SizedBox(height: 10),
          Text(
            'Submitted ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.tryParse(item['submittedAt']?.toString() ?? '') ?? DateTime.now())}',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(onPressed: () => _updateApproval(item['_id']?.toString() ?? '', 'approved'), child: const Text('Approve')),
              OutlinedButton(onPressed: () => _updateApproval(item['_id']?.toString() ?? '', 'rejected'), child: const Text('Reject')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eventCard(Map<String, dynamic> event) {
    final severity = event['severity']?.toString() ?? 'info';
    final color = severity == 'high'
        ? const Color(0xFFDC2626)
        : severity == 'medium'
            ? const Color(0xFFD97706)
            : const Color(0xFF0284C7);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['title']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(event['details']?.toString() ?? '-', style: const TextStyle(color: Color(0xFF475569))),
                const SizedBox(height: 8),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.tryParse(event['createdAt']?.toString() ?? '') ?? DateTime.now()),
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

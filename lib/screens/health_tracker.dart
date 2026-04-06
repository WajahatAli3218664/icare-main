import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/standalone_phase3_service.dart';
import '../utils/shared_pref.dart';
import '../utils/theme.dart';
import '../utils/role_ui.dart';
import '../widgets/back_button.dart';

class HealthTracker extends StatefulWidget {
  const HealthTracker({super.key});

  @override
  State<HealthTracker> createState() => _HealthTrackerState();
}

class _HealthTrackerState extends State<HealthTracker> {
  final StandalonePhase3Service _service = StandalonePhase3Service();
  final SharedPref _sharedPref = SharedPref();
  bool _loading = true;
  String _role = 'Patient';
  Map<String, dynamic> _dashboard = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _service.ensureSeeded();
    final user = await _sharedPref.getUserData();
    final dashboard = await _service.getLifestyleDashboard();
    if (!mounted) return;
    setState(() {
      _role = normalizeRoleName(user?.role ?? 'Patient');
      _dashboard = dashboard;
      _loading = false;
    });
  }

  Future<void> _addEntry() async {
    final metricController = TextEditingController();
    final valueController = TextEditingController();
    final unitController = TextEditingController();
    final noteController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add lifestyle reading'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: metricController, decoration: const InputDecoration(labelText: 'Metric')),
              TextField(controller: valueController, decoration: const InputDecoration(labelText: 'Value')),
              TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit')),
              TextField(controller: noteController, decoration: const InputDecoration(labelText: 'Note')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );
    if (saved == true && metricController.text.trim().isNotEmpty && valueController.text.trim().isNotEmpty) {
      await _service.addLifestyleEntry(
        metric: metricController.text.trim(),
        value: valueController.text.trim(),
        unit: unitController.text.trim(),
        note: noteController.text.trim(),
      );
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = (_dashboard['entries'] as List?)?.cast<Map<String, dynamic>>() ?? <Map<String, dynamic>>[];
    final summary = Map<String, dynamic>.from(_dashboard['summary'] as Map? ?? <String, dynamic>{});
    final monitoringView = isDoctorRole(_role) || isAdminRole(_role) || isSuperAdminRole(_role) || isSecurityRole(_role);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          monitoringView ? 'Lifestyle Monitoring' : 'Lifestyle Tracking',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
          ),
        ],
      ),
      floatingActionButton: monitoringView
          ? null
          : FloatingActionButton.extended(
              onPressed: _addEntry,
              backgroundColor: AppColors.primaryColor,
              label: const Text('Add Reading'),
              icon: const Icon(Icons.add),
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _summaryCard(summary, monitoringView),
                  const SizedBox(height: 20),
                  Text(
                    monitoringView ? 'Patient monitoring board' : 'Recent lifestyle updates',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),
                  if (entries.isEmpty)
                    _emptyState('No lifestyle readings yet', 'Start capturing BP, sugar, sleep, activity and wellness data.')
                  else
                    ...entries.map((entry) => _entryCard(entry, monitoringView)),
                ],
              ),
            ),
    );
  }

  Widget _summaryCard(Map<String, dynamic> summary, bool monitoringView) {
    final latestUpdate = DateTime.tryParse(summary['latestUpdate']?.toString() ?? '');
    final latestLabel = latestUpdate == null ? 'No updates yet' : DateFormat('dd MMM, hh:mm a').format(latestUpdate);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0036BC), Color(0xFF14B1FF)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monitoringView ? 'Care monitoring overview' : 'Your wellness overview',
            style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            '${summary['metricsTracked'] ?? 0} metrics actively tracked',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _miniPill('${summary['activePatients'] ?? 0} ${monitoringView ? 'patients monitored' : 'patient profile'}'),
              _miniPill('Latest update: $latestLabel'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  Widget _entryCard(Map<String, dynamic> entry, bool monitoringView) {
    final date = DateTime.tryParse(entry['createdAt']?.toString() ?? '');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite_rounded, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry['metric']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text(
                      monitoringView ? (entry['patientName']?.toString() ?? 'Patient') : (entry['note']?.toString().isNotEmpty == true ? entry['note'].toString() : 'Logged from patient dashboard'),
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(entry['trend']?.toString() ?? 'stable', style: const TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${entry['value'] ?? '-'} ${entry['unit'] ?? ''}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 6),
          Text(
            date == null ? 'Unknown time' : DateFormat('dd MMM yyyy, hh:mm a').format(date),
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Icon(Icons.monitor_heart_outlined, size: 42, color: AppColors.primaryColor),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

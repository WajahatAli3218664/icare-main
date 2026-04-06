import 'package:flutter/material.dart';

import '../services/standalone_phase4_service.dart';
import '../utils/theme.dart';

class Phase4QaCompletionScreen extends StatefulWidget {
  const Phase4QaCompletionScreen({super.key});

  @override
  State<Phase4QaCompletionScreen> createState() => _Phase4QaCompletionScreenState();
}

class _Phase4QaCompletionScreenState extends State<Phase4QaCompletionScreen> {
  final StandalonePhase4Service _service = StandalonePhase4Service();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getQaCommandCenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('QA Completion Center')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final metrics = List<dynamic>.from(data['metrics'] as List? ?? []);
          final queues = List<dynamic>.from(data['adminQueues'] as List? ?? []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Text('Metrics below target: ${data['belowTarget'] ?? 0}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Quality metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  const SizedBox(height: 12),
                  ...metrics.map((item) {
                    final metric = Map<String, dynamic>.from(item as Map);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(metric['label']?.toString() ?? '-'),
                      subtitle: Text('Current ${metric['value'] ?? 0}% • Target ${metric['target'] ?? 0}%'),
                    );
                  }),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Approval queue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                  const SizedBox(height: 12),
                  ...queues.map((item) {
                    final queue = Map<String, dynamic>.from(item as Map);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.approval_rounded, color: AppColors.primary500),
                      title: Text(queue['subject']?.toString() ?? '-'),
                      subtitle: Text('${queue['type'] ?? '-'} • ${queue['status'] ?? '-'}'),
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

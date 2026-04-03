import 'package:flutter/material.dart';

import '../services/standalone_phase4_service.dart';
import '../utils/theme.dart';

class Phase4ChronicCareScreen extends StatefulWidget {
  const Phase4ChronicCareScreen({super.key});

  @override
  State<Phase4ChronicCareScreen> createState() => _Phase4ChronicCareScreenState();
}

class _Phase4ChronicCareScreenState extends State<Phase4ChronicCareScreen> {
  final StandalonePhase4Service _service = StandalonePhase4Service();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getChronicCareCenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('Chronic Care Programs')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final summary = Map<String, dynamic>.from(data['summary'] as Map? ?? {});
          final programs = List<dynamic>.from(data['programs'] as List? ?? []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Count(label: 'Programs', value: '${summary['totalPrograms'] ?? 0}'),
                    _Count(label: 'Active', value: '${summary['activePrograms'] ?? 0}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...programs.map((item) {
                final program = Map<String, dynamic>.from(item as Map);
                final includes = List<dynamic>.from(program['includes'] as List? ?? []);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(program['name']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary500)),
                    const SizedBox(height: 6),
                    Text('Condition: ${program['condition'] ?? '-'}'),
                    Text('Duration: ${program['duration'] ?? '-'}'),
                    Text('Status: ${program['status'] ?? '-'}'),
                    const SizedBox(height: 8),
                    ...includes.map((value) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(children: [const Icon(Icons.check_circle_rounded, size: 18, color: Colors.green), const SizedBox(width: 8), Expanded(child: Text(value.toString()))]),
                    )),
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

class _Count extends StatelessWidget {
  final String label;
  final String value;
  const _Count({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primary500)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: AppColors.darkGreyColor)),
    ]);
  }
}

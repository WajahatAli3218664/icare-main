import 'package:flutter/material.dart';

import '../services/standalone_care_hub_service.dart';
import '../utils/theme.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  final StandaloneCareHubService _hub = StandaloneCareHubService();
  late Future<void> _future;
  List<dynamic> _plans = const [];
  Map<String, dynamic>? _current;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<void> _load() async {
    _plans = await _hub.getSubscriptionPlans();
    _current = await _hub.getCurrentSubscription();
  }

  Future<void> _subscribe(String planId) async {
    await _hub.subscribeCurrentPatient(planId);
    setState(() {
      _future = _load();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription updated successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plans & Chronic Care Packages')),
      body: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_current != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current active plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500)),
                      const SizedBox(height: 8),
                      Text(_current!['plan']?['name']?.toString() ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Renewal: ${_current!['renewalDate']?.toString().split('T').first ?? '-'}'),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              ..._plans.map((item) {
                final plan = Map<String, dynamic>.from(item as Map);
                final features = List<dynamic>.from(plan['features'] as List? ?? []);
                final selected = _current != null && (_current!['plan']?['_id'] == plan['_id']);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? AppColors.primaryColor : Colors.transparent, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(plan['name']?.toString() ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary500))),
                          Text('Rs ${plan['price'] ?? 0}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(children: [const Icon(Icons.check_circle_rounded, size: 18, color: Colors.green), const SizedBox(width: 8), Expanded(child: Text(f.toString()))]),
                      )),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: selected ? null : () => _subscribe(plan['_id'].toString()),
                        child: Text(selected ? 'Active Plan' : 'Choose Plan'),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

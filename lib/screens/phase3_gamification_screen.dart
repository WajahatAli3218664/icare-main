import 'package:flutter/material.dart';

import '../services/standalone_phase3_service.dart';
import '../utils/theme.dart';
import '../widgets/back_button.dart';

class Phase3GamificationScreen extends StatefulWidget {
  const Phase3GamificationScreen({super.key});

  @override
  State<Phase3GamificationScreen> createState() => _Phase3GamificationScreenState();
}

class _Phase3GamificationScreenState extends State<Phase3GamificationScreen> {
  final StandalonePhase3Service _service = StandalonePhase3Service();
  bool _loading = true;
  Map<String, dynamic> _dashboard = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _service.ensureSeeded();
    final dashboard = await _service.getGamificationDashboard();
    if (!mounted) return;
    setState(() {
      _dashboard = dashboard;
      _loading = false;
    });
  }

  Future<void> _completeHabit(String habitId) async {
    await _service.completeHabit(habitId);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Habit marked complete for today')));
  }

  @override
  Widget build(BuildContext context) {
    final habits = (_dashboard['habits'] as List?)?.cast<Map<String, dynamic>>() ?? <Map<String, dynamic>>[];
    final badges = (_dashboard['badges'] as List?)?.cast<Map<String, dynamic>>() ?? <Map<String, dynamic>>[];
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Motivation & Rewards', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _overviewCard(),
                  const SizedBox(height: 20),
                  const Text('Healthy habits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  ...habits.map(_habitCard),
                  const SizedBox(height: 20),
                  const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  ...badges.map(_badgeCard),
                ],
              ),
            ),
    );
  }

  Widget _overviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF2563EB)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _stat('Points', '${_dashboard['totalPoints'] ?? 0}')),
          Expanded(child: _stat('Best streak', '${_dashboard['longestStreak'] ?? 0} days')),
          Expanded(child: _stat('Badges', '${_dashboard['earnedBadges'] ?? 0}')),
        ],
      ),
    );
  }

  Widget _stat(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _habitCard(Map<String, dynamic> habit) {
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
                    Text(habit['title']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    Text(habit['target']?.toString() ?? '-', style: const TextStyle(color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(999)),
                child: Text('+${habit['points'] ?? 0} pts', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Streak: ${habit['streak'] ?? 0} days', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryColor)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _completeHabit(habit['_id']?.toString() ?? ''),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text('Complete today'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _badgeCard(Map<String, dynamic> badge) {
    final earned = badge['earned'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: earned ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: earned ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
            child: Icon(earned ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded, color: earned ? const Color(0xFFD97706) : const Color(0xFF64748B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badge['title']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(badge['description']?.toString() ?? '-', style: const TextStyle(color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text(earned ? 'Earned' : 'Locked', style: TextStyle(color: earned ? const Color(0xFFD97706) : const Color(0xFF64748B), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

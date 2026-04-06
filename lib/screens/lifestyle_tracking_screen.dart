import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/models/gamification.dart';
import 'package:icare/utils/theme.dart';
import 'package:intl/intl.dart';

/// Lifestyle Tracking & Gamification Screen
///
/// Patient engagement features including health metrics tracking,
/// streaks, achievements, and gamification elements
class LifestyleTrackingScreen extends ConsumerStatefulWidget {
  const LifestyleTrackingScreen({super.key});

  @override
  ConsumerState<LifestyleTrackingScreen> createState() => _LifestyleTrackingScreenState();
}

class _LifestyleTrackingScreenState extends ConsumerState<LifestyleTrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  UserGamificationProfile? _profile;
  List<HealthMetricEntry> _recentMetrics = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    // Sample data
    setState(() {
      _profile = UserGamificationProfile(
        userId: 'current_user',
        totalPoints: 450,
        level: 5,
        achievements: _getSampleAchievements(),
        streaks: _getSampleStreaks(),
        consultationsCompleted: 8,
        healthProgramsCompleted: 2,
        daysActive: 45,
      );
      _recentMetrics = _getSampleMetrics();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Health Journey',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Track your progress and achievements',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, fontFamily: 'Gilroy-Bold'),
              tabs: const [
                Tab(text: 'OVERVIEW'),
                Tab(text: 'TRACK HEALTH'),
                Tab(text: 'ACHIEVEMENTS'),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTrackHealthTab(),
                _buildAchievementsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    if (_profile == null) return const SizedBox();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildLevelCard(),
        const SizedBox(height: 24),
        const Text(
          'Active Streaks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Gilroy-Bold',
          ),
        ),
        const SizedBox(height: 16),
        ..._profile!.streaks.map((streak) => _buildStreakCard(streak)),
        const SizedBox(height: 24),
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Gilroy-Bold',
          ),
        ),
        const SizedBox(height: 16),
        _buildStatsGrid(),
      ],
    );
  }

  Widget _buildTrackHealthTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Track Your Health Metrics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Gilroy-Bold',
          ),
        ),
        const SizedBox(height: 16),
        _buildTrackingCard(
          'Blood Pressure',
          'Track your BP readings',
          Icons.favorite,
          Colors.red,
          () => _showBloodPressureDialog(),
        ),
        _buildTrackingCard(
          'Blood Sugar',
          'Monitor glucose levels',
          Icons.water_drop,
          Colors.blue,
          () => _showBloodSugarDialog(),
        ),
        _buildTrackingCard(
          'Weight',
          'Track your weight',
          Icons.monitor_weight,
          Colors.purple,
          () => _showWeightDialog(),
        ),
        _buildTrackingCard(
          'Sleep',
          'Log your sleep hours',
          Icons.bedtime,
          Colors.indigo,
          () => _showSleepDialog(),
        ),
        _buildTrackingCard(
          'Exercise',
          'Record physical activity',
          Icons.fitness_center,
          Colors.orange,
          () => _showExerciseDialog(),
        ),
        const SizedBox(height: 24),
        const Text(
          'Recent Entries',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Gilroy-Bold',
          ),
        ),
        const SizedBox(height: 16),
        ..._recentMetrics.map((metric) => _buildMetricEntryCard(metric)),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    if (_profile == null) return const SizedBox();

    final unlockedAchievements = _profile!.achievements.where((a) => a.isUnlocked).toList();
    final lockedAchievements = _profile!.achievements.where((a) => !a.isUnlocked).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events, color: AppColors.primaryColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${unlockedAchievements.length} / ${_profile!.achievements.length}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Gilroy-Bold',
                      ),
                    ),
                    const Text(
                      'Achievements Unlocked',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (unlockedAchievements.isNotEmpty) ...[
          const Text(
            'Unlocked',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 16),
          ...unlockedAchievements.map((achievement) => _buildAchievementCard(achievement)),
          const SizedBox(height: 24),
        ],
        if (lockedAchievements.isNotEmpty) ...[
          const Text(
            'Locked',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 16),
          ...lockedAchievements.map((achievement) => _buildAchievementCard(achievement)),
        ],
      ],
    );
  }

  Widget _buildLevelCard() {
    if (_profile == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Level',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'Gilroy-Medium',
                    ),
                  ),
                  Text(
                    '${_profile!.level}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_profile!.totalPoints}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Points',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${_profile!.level + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${_profile!.pointsToNextLevel} points to go',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _profile!.progressToNextLevel,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(HealthStreak streak) {
    IconData icon;
    Color color;
    String title;

    switch (streak.streakType) {
      case 'daily_checkin':
        icon = Icons.check_circle;
        color = const Color(0xFF10B981);
        title = 'Daily Check-in';
        break;
      case 'medication':
        icon = Icons.medication;
        color = const Color(0xFF3B82F6);
        title = 'Medication';
        break;
      case 'exercise':
        icon = Icons.fitness_center;
        color = const Color(0xFFF59E0B);
        title = 'Exercise';
        break;
      case 'sleep':
        icon = Icons.bedtime;
        color = const Color(0xFF8B5CF6);
        title = 'Sleep Tracking';
        break;
      default:
        icon = Icons.star;
        color = AppColors.primaryColor;
        title = streak.streakType;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Longest: ${streak.longestStreak} days',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.local_fire_department, color: color, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${streak.currentStreak}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: color,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ],
              ),
              const Text(
                'days',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    if (_profile == null) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Consultations',
            '${_profile!.consultationsCompleted}',
            Icons.medical_services,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Programs',
            '${_profile!.healthProgramsCompleted}',
            Icons.school,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Days Active',
            '${_profile!.daysActive}',
            Icons.calendar_today,
            const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricEntryCard(HealthMetricEntry metric) {
    String title = '';
    String value = '';
    IconData icon = Icons.favorite;
    Color color = Colors.blue;

    switch (metric.metricType) {
      case 'blood_pressure':
        title = 'Blood Pressure';
        value = '${metric.values['systolic']}/${metric.values['diastolic']} mmHg';
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case 'blood_sugar':
        title = 'Blood Sugar';
        value = '${metric.values['glucose']} mg/dL';
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'weight':
        title = 'Weight';
        value = '${metric.values['weightKg']} kg';
        icon = Icons.monitor_weight;
        color = Colors.purple;
        break;
      case 'sleep':
        title = 'Sleep';
        value = '${metric.values['hoursSlept']} hours';
        icon = Icons.bedtime;
        color = Colors.indigo;
        break;
      case 'exercise':
        title = 'Exercise';
        value = '${metric.values['durationMinutes']} min';
        icon = Icons.fitness_center;
        color = Colors.orange;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(metric.recordedAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? _getTierColor(achievement.tier).withOpacity(0.3)
              : const Color(0xFFF1F5F9),
          width: achievement.isUnlocked ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? _getTierColor(achievement.tier).withOpacity(0.1)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.emoji_events,
              color: achievement.isUnlocked ? _getTierColor(achievement.tier) : const Color(0xFF94A3B8),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: achievement.isUnlocked ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                  ),
                ),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                if (achievement.isUnlocked && achievement.unlockedAt != null)
                  Text(
                    'Unlocked ${DateFormat('MMM dd, yyyy').format(achievement.unlockedAt!)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          if (achievement.isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getTierColor(achievement.tier).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${achievement.pointsAwarded}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _getTierColor(achievement.tier),
                ),
              ),
            )
          else
            const Icon(Icons.lock, size: 20, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Color _getTierColor(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFFE5E4E2);
    }
  }

  List<Achievement> _getSampleAchievements() {
    return [
      Achievement(
        id: 'ach_001',
        type: AchievementType.firstConsultation,
        name: 'First Steps',
        description: 'Complete your first consultation',
        iconName: 'medical_services',
        tier: AchievementTier.bronze,
        pointsAwarded: 50,
        unlockedAt: DateTime.now().subtract(const Duration(days: 40)),
        isUnlocked: true,
      ),
      Achievement(
        id: 'ach_002',
        type: AchievementType.weekStreak,
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        iconName: 'local_fire_department',
        tier: AchievementTier.silver,
        pointsAwarded: 100,
        unlockedAt: DateTime.now().subtract(const Duration(days: 20)),
        isUnlocked: true,
      ),
      Achievement(
        id: 'ach_003',
        type: AchievementType.healthProgramComplete,
        name: 'Dedicated Learner',
        description: 'Complete a health program',
        iconName: 'school',
        tier: AchievementTier.gold,
        pointsAwarded: 200,
        unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
        isUnlocked: true,
      ),
      Achievement(
        id: 'ach_004',
        type: AchievementType.monthStreak,
        name: 'Month Master',
        description: 'Maintain a 30-day streak',
        iconName: 'emoji_events',
        tier: AchievementTier.platinum,
        pointsAwarded: 500,
        isUnlocked: false,
      ),
    ];
  }

  List<HealthStreak> _getSampleStreaks() {
    return [
      HealthStreak(
        id: 'streak_001',
        userId: 'current_user',
        streakType: 'daily_checkin',
        currentStreak: 12,
        longestStreak: 15,
        lastActivityDate: DateTime.now(),
        streakStartDate: DateTime.now().subtract(const Duration(days: 12)),
      ),
      HealthStreak(
        id: 'streak_002',
        userId: 'current_user',
        streakType: 'medication',
        currentStreak: 8,
        longestStreak: 10,
        lastActivityDate: DateTime.now(),
        streakStartDate: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];
  }

  List<HealthMetricEntry> _getSampleMetrics() {
    return [
      HealthMetricEntry.bloodPressure(
        userId: 'current_user',
        systolic: 120,
        diastolic: 80,
        heartRate: 72,
      ),
      HealthMetricEntry.bloodSugar(
        userId: 'current_user',
        glucose: 95,
        measurementType: 'fasting',
      ),
      HealthMetricEntry.weight(
        userId: 'current_user',
        weightKg: 75.5,
        bmi: 24.2,
      ),
    ];
  }

  void _showBloodPressureDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Blood pressure tracking dialog')),
    );
  }

  void _showBloodSugarDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Blood sugar tracking dialog')),
    );
  }

  void _showWeightDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weight tracking dialog')),
    );
  }

  void _showSleepDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sleep tracking dialog')),
    );
  }

  void _showExerciseDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exercise tracking dialog')),
    );
  }
}

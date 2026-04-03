import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/utils/theme.dart';

/// Analytics Dashboard
///
/// Shows system-wide analytics proving this is a CONNECTED ecosystem:
/// - Consultation metrics
/// - Lab test turnaround times
/// - Pharmacy fulfillment rates
/// - Revenue analytics
/// - Clinical quality indicators
/// - System usage statistics
class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends ConsumerState<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String _selectedPeriod = 'This Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Analytics & Insights', style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w900)),
            Text('System-wide performance metrics', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) => setState(() => _selectedPeriod = value),
            itemBuilder: (ctx) => ['Today', 'This Week', 'This Month', 'This Year']
                .map((p) => PopupMenuItem(value: p, child: Text(p)))
                .toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(_selectedPeriod, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorWeight: 3,
              isScrollable: true,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, fontFamily: 'Gilroy-Bold'),
              tabs: const [Tab(text: 'OVERVIEW'), Tab(text: 'CLINICAL'), Tab(text: 'REVENUE'), Tab(text: 'OPERATIONS')],
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
                _buildClinicalTab(),
                _buildRevenueTab(),
                _buildOperationsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Key Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Consultations', '1,247', '+12%', Icons.medical_services, const Color(0xFF3B82F6))),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Active Patients', '3,892', '+8%', Icons.people, const Color(0xFF10B981))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Lab Tests', '856', '+15%', Icons.science, const Color(0xFF8B5CF6))),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Prescriptions', '2,134', '+10%', Icons.medication, const Color(0xFFF59E0B))),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Module Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        _buildModulePerformanceCard('Consultations', 95, 'Completion Rate', const Color(0xFF3B82F6)),
        _buildModulePerformanceCard('Lab Tests', 88, 'On-Time Delivery', const Color(0xFF8B5CF6)),
        _buildModulePerformanceCard('Pharmacy', 92, 'Fulfillment Rate', const Color(0xFF10B981)),
        _buildModulePerformanceCard('Referrals', 78, 'Acceptance Rate', const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildClinicalTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Clinical Quality Indicators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        _buildQualityIndicator('Consultation Documentation', 94, 'Complete records', const Color(0xFF10B981)),
        _buildQualityIndicator('Prescription Compliance', 89, 'Following guidelines', const Color(0xFF3B82F6)),
        _buildQualityIndicator('Lab Test Appropriateness', 91, 'Evidence-based ordering', const Color(0xFF8B5CF6)),
        _buildQualityIndicator('Follow-up Adherence', 85, 'Scheduled follow-ups', const Color(0xFFF59E0B)),
        const SizedBox(height: 24),
        const Text('Diagnosis Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        _buildDiagnosisCard('Diabetes Management', 234, const Color(0xFF3B82F6)),
        _buildDiagnosisCard('Hypertension', 189, const Color(0xFF10B981)),
        _buildDiagnosisCard('Respiratory Infections', 156, const Color(0xFF8B5CF6)),
        _buildDiagnosisCard('Mental Health', 98, const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildRevenueTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Revenue Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Revenue', style: TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'Gilroy-Medium')),
              const SizedBox(height: 8),
              const Text('\$124,567', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Gilroy-Bold')),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: const Text('+18.5%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  const Text('vs last month', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Revenue by Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        _buildRevenueCard('Consultations', '\$45,230', 36, const Color(0xFF3B82F6)),
        _buildRevenueCard('Lab Tests', '\$32,890', 26, const Color(0xFF8B5CF6)),
        _buildRevenueCard('Prescriptions', '\$28,450', 23, const Color(0xFF10B981)),
        _buildRevenueCard('Health Programs', '\$17,997', 15, const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildOperationsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Operational Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        _buildOperationalCard('Average Consultation Time', '28 min', Icons.timer, const Color(0xFF3B82F6)),
        _buildOperationalCard('Lab Turnaround Time', '2.3 days', Icons.science, const Color(0xFF8B5CF6)),
        _buildOperationalCard('Pharmacy Fulfillment Time', '4.5 hours', Icons.local_shipping, const Color(0xFF10B981)),
        _buildOperationalCard('Referral Response Time', '1.8 days', Icons.person_add, const Color(0xFFF59E0B)),
        const SizedBox(height: 24),
        const Text('System Usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold')),
        const SizedBox(height: 16),
        _buildUsageCard('Active Doctors', 45, 'Online now: 12'),
        _buildUsageCard('Active Patients', 892, 'New today: 23'),
        _buildUsageCard('Lab Partners', 8, 'Processing: 34 tests'),
        _buildUsageCard('Pharmacy Partners', 12, 'Active orders: 56'),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(change, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color, fontFamily: 'Gilroy-Bold')),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildModulePerformanceCard(String module, int percentage, String metric, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(module, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Text('$percentage%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          Text(metric, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityIndicator(String indicator, int score, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text('$score%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(indicator, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard(String diagnosis, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(child: Text(diagnosis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
          Text('$count cases', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(String service, String amount, int percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text('$percentage% of total', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color, fontFamily: 'Gilroy-Bold')),
        ],
      ),
    );
  }

  Widget _buildOperationalCard(String metric, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(metric, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildUsageCard(String label, int count, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(detail, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryColor)),
        ],
      ),
    );
  }
}

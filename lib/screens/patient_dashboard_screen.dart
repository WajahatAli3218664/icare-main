import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/utils/theme.dart';

/// Patient Dashboard
///
/// This is the MAIN patient view showing the connected virtual hospital:
/// - Upcoming appointments
/// - My prescriptions (with order status)
/// - My lab reports (with test status)
/// - My health programs (assigned by doctor)
/// - Health metrics (lifestyle tracking)
/// - Recent consultations
class PatientDashboardScreen extends ConsumerStatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  ConsumerState<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends ConsumerState<PatientDashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(child: _buildQuickStats()),
                  SliverToBoxAdapter(child: _buildUpcomingAppointments()),
                  SliverToBoxAdapter(child: _buildActivePrescriptions()),
                  SliverToBoxAdapter(child: _buildPendingLabTests()),
                  SliverToBoxAdapter(child: _buildHealthPrograms()),
                  SliverToBoxAdapter(child: _buildHealthMetrics()),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor.withOpacity(0.1),
                AppColors.primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontFamily: 'Gilroy-Medium',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your Health Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Appointments', '2', Icons.calendar_today, const Color(0xFF3B82F6))),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Prescriptions', '3', Icons.medication, const Color(0xFF10B981))),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Lab Tests', '1', Icons.science, const Color(0xFF8B5CF6))),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontFamily: 'Gilroy-Medium',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return _buildSection(
      'Upcoming Appointments',
      Icons.calendar_today,
      [
        _buildAppointmentCard('Dr. Sarah Johnson', 'Cardiology', 'Tomorrow, 10:00 AM'),
        _buildAppointmentCard('Dr. Mike Chen', 'General Practice', 'Mar 15, 2:30 PM'),
      ],
      onViewAll: () {},
    );
  }

  Widget _buildActivePrescriptions() {
    return _buildSection(
      'Active Prescriptions',
      Icons.medication,
      [
        _buildPrescriptionCard('Metformin 500mg', '2x daily', 'In Pharmacy', const Color(0xFF3B82F6)),
        _buildPrescriptionCard('Lisinopril 10mg', '1x daily', 'Ready for Pickup', const Color(0xFF10B981)),
        _buildPrescriptionCard('Atorvastatin 20mg', '1x daily', 'Delivered', const Color(0xFF64748B)),
      ],
      onViewAll: () {},
    );
  }

  Widget _buildPendingLabTests() {
    return _buildSection(
      'Lab Tests',
      Icons.science,
      [
        _buildLabTestCard('Complete Blood Count', 'Pending', const Color(0xFFF59E0B)),
      ],
      onViewAll: () {},
    );
  }

  Widget _buildHealthPrograms() {
    return _buildSection(
      'My Health Programs',
      Icons.favorite,
      [
        _buildHealthProgramCard('Diabetes Management', 65),
      ],
      onViewAll: () {},
    );
  }

  Widget _buildHealthMetrics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.monitor_heart, color: AppColors.primaryColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Health Metrics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Track More'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard('Blood Pressure', '120/80', 'mmHg', Icons.favorite, Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('Blood Sugar', '95', 'mg/dL', Icons.water_drop, Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ],
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(String doctor, String specialty, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: AppColors.primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(specialty, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(String medicine, String dosage, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.medication, color: Color(0xFF10B981), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(dosage, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabTestCard(String test, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.science, color: Color(0xFF8B5CF6), size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(test, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthProgramCard(String program, int progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(program, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
              Text('$progress%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryColor)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color, fontFamily: 'Gilroy-Bold')),
          Text('$label ($unit)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

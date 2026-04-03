import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/utils/theme.dart';

/// Admin Panel
///
/// This is where admin-controlled users are onboarded:
/// - Laboratories (verified partners)
/// - Pharmacies (verified partners)
/// - Instructors (LMS teachers)
/// - Students (LMS learners)
/// - Doctor approvals
///
/// These roles CANNOT self-signup. Admin creates them.
class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock data
  List<Map<String, dynamic>> _pendingDoctors = [];
  List<Map<String, dynamic>> _laboratories = [];
  List<Map<String, dynamic>> _pharmacies = [];
  List<Map<String, dynamic>> _instructors = [];
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation, fetch from backend
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
            const Text(
              'Admin Panel',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Manage users and system settings',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontFamily: 'Gilroy-Medium',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 8),
        ],
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
              isScrollable: true,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                fontFamily: 'Gilroy-Bold',
              ),
              tabs: [
                Tab(text: 'DOCTOR APPROVALS (${_pendingDoctors.length})'),
                Tab(text: 'LABORATORIES (${_laboratories.length})'),
                Tab(text: 'PHARMACIES (${_pharmacies.length})'),
                Tab(text: 'INSTRUCTORS (${_instructors.length})'),
                Tab(text: 'STUDENTS (${_students.length})'),
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
                _buildDoctorApprovalsTab(),
                _buildLaboratoriesTab(),
                _buildPharmaciesTab(),
                _buildInstructorsTab(),
                _buildStudentsTab(),
              ],
            ),
    );
  }

  Widget _buildDoctorApprovalsTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Doctor Approvals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review and approve doctor registrations',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),
          if (_pendingDoctors.isEmpty)
            _buildEmptyState('No pending approvals', Icons.check_circle_outline)
          else
            Expanded(
              child: ListView.builder(
                itemCount: _pendingDoctors.length,
                itemBuilder: (ctx, i) => _buildDoctorApprovalCard(_pendingDoctors[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLaboratoriesTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Laboratory Partners',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Gilroy-Bold'),
                  ),
                  SizedBox(height: 4),
                  Text('Verified lab partners in the system', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _addLaboratory,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Laboratory'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_laboratories.isEmpty)
            _buildEmptyState('No laboratories added', Icons.science_outlined)
          else
            Expanded(
              child: ListView.builder(
                itemCount: _laboratories.length,
                itemBuilder: (ctx, i) => _buildLabCard(_laboratories[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPharmaciesTab() {
    return Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Pharmacy Partners', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ElevatedButton.icon(onPressed: _addPharmacy, icon: const Icon(Icons.add), label: const Text('Add')),
      ]),
      if (_pharmacies.isEmpty) _buildEmptyState('No pharmacies', Icons.local_pharmacy_outlined),
    ]));
  }

  Widget _buildInstructorsTab() {
    return Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Instructors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ElevatedButton.icon(onPressed: _addInstructor, icon: const Icon(Icons.add), label: const Text('Add')),
      ]),
      if (_instructors.isEmpty) _buildEmptyState('No instructors', Icons.school_outlined),
    ]));
  }

  Widget _buildStudentsTab() {
    return Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ElevatedButton.icon(onPressed: _addStudent, icon: const Icon(Icons.add), label: const Text('Add')),
      ]),
      if (_students.isEmpty) _buildEmptyState('No students', Icons.person_outline),
    ]));
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.06), shape: BoxShape.circle),
        child: Icon(icon, size: 48, color: AppColors.primaryColor.withOpacity(0.5))),
      const SizedBox(height: 16),
      Text(msg, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    ]));
  }

  Widget _buildDoctorApprovalCard(Map<String, dynamic> d) {
    return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Row(children: [const CircleAvatar(child: Icon(Icons.person)), const SizedBox(width: 12),
          Expanded(child: Text('Dr. ${d['name'] ?? 'Unknown'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)))]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => _rejectDoctor(d), child: const Text('Reject'))),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: ElevatedButton(onPressed: () => _approveDoctor(d), child: const Text('Approve'))),
        ]),
      ]));
  }

  Widget _buildLabCard(Map<String, dynamic> lab) {
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [const Icon(Icons.science), const SizedBox(width: 12),
        Expanded(child: Text(lab['name'] ?? 'Lab')), IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {})]));
  }

  void _addLaboratory() {}
  void _addPharmacy() {}
  void _addInstructor() {}
  void _addStudent() {}
  void _approveDoctor(Map<String, dynamic> d) {}
  void _rejectDoctor(Map<String, dynamic> d) {}
}

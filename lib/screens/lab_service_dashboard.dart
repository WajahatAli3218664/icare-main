import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/models/lab_test_request.dart';
import 'package:icare/services/healthcare_workflow_service.dart';
import 'package:icare/utils/theme.dart';
import 'package:intl/intl.dart';

/// Lab Service Dashboard
///
/// This is the PROPER lab dashboard for lab technicians.
/// It follows the service workflow pattern:
/// 1. Receive test requests from doctors
/// 2. Accept/Reject requests
/// 3. Process tests (mark as in-progress)
/// 4. Upload reports
/// 5. Mark as completed
///
/// This is NOT a patient-facing view.
class LabServiceDashboard extends ConsumerStatefulWidget {
  const LabServiceDashboard({super.key});

  @override
  ConsumerState<LabServiceDashboard> createState() => _LabServiceDashboardState();
}

class _LabServiceDashboardState extends ConsumerState<LabServiceDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  // Mock data - in real implementation, this would come from backend
  List<LabTestRequest> _pendingRequests = [];
  List<LabTestRequest> _inProgressRequests = [];
  List<LabTestRequest> _completedRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTestRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTestRequests() async {
    setState(() => _isLoading = true);

    try {
      // In real implementation, fetch from backend API
      // For now, using mock data to demonstrate the workflow

      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _pendingRequests = [];
      _inProgressRequests = [];
      _completedRequests = [];

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading test requests: $e');
      setState(() => _isLoading = false);
      _showError('Failed to load test requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lab Service Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Manage incoming test requests',
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
            onPressed: _loadTestRequests,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryColor),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              // Stats Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    _buildStatChip(
                      'Pending',
                      _pendingRequests.length,
                      Icons.pending_actions_rounded,
                      const Color(0xFFF59E0B),
                      const Color(0xFFFEF3C7),
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      'In Progress',
                      _inProgressRequests.length,
                      Icons.science_rounded,
                      const Color(0xFF3B82F6),
                      const Color(0xFFDBEAFE),
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      'Completed',
                      _completedRequests.length,
                      Icons.check_circle_rounded,
                      const Color(0xFF10B981),
                      const Color(0xFFD1FAE5),
                    ),
                  ],
                ),
              ),
              // Tabs
              Container(
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
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.5,
                    fontFamily: 'Gilroy-Bold',
                  ),
                  tabs: const [
                    Tab(text: 'PENDING REQUESTS'),
                    Tab(text: 'IN PROGRESS'),
                    Tab(text: 'COMPLETED'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1200 : double.infinity,
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPendingRequestsList(),
                    _buildInProgressList(),
                    _buildCompletedList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: color,
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                      fontFamily: 'Gilroy-SemiBold',
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

  Widget _buildPendingRequestsList() {
    if (_pendingRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox_rounded,
        title: 'No Pending Requests',
        subtitle: 'New test requests from doctors will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _pendingRequests.length,
      itemBuilder: (ctx, i) => _buildPendingRequestCard(_pendingRequests[i]),
    );
  }

  Widget _buildInProgressList() {
    if (_inProgressRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.science_rounded,
        title: 'No Tests In Progress',
        subtitle: 'Tests you accept will appear here for processing',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _inProgressRequests.length,
      itemBuilder: (ctx, i) => _buildInProgressCard(_inProgressRequests[i]),
    );
  }

  Widget _buildCompletedList() {
    if (_completedRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'No Completed Tests',
        subtitle: 'Completed tests with uploaded reports will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _completedRequests.length,
      itemBuilder: (ctx, i) => _buildCompletedCard(_completedRequests[i]),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              fontFamily: 'Gilroy-Medium',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestCard(LabTestRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with priority indicator
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.04),
                  AppColors.primaryColor.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                // Priority indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(request.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _getPriorityColor(request.priority).withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    _getPriorityIcon(request.priority),
                    color: _getPriorityColor(request.priority),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            request.testTypes.join(', '),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Gilroy-Bold',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(request.priority).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              request.priority.toString().split('.').last.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: _getPriorityColor(request.priority),
                                fontFamily: 'Gilroy-Bold',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Requested ${_formatDate(request.requestedAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Gilroy-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body with patient and doctor info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient info
                _buildInfoRow(
                  Icons.person_rounded,
                  'Patient',
                  'Patient ID: ${request.patientId}',
                ),
                const SizedBox(height: 12),
                // Doctor info
                _buildInfoRow(
                  Icons.medical_services_rounded,
                  'Ordered by',
                  'Dr. ${request.doctorId}',
                ),
                const SizedBox(height: 12),
                // Diagnosis
                _buildInfoRow(
                  Icons.assignment_rounded,
                  'Diagnosis',
                  request.diagnosis,
                ),

                if (request.clinicalNotes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Clinical Notes',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      request.clinicalNotes,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF334155),
                        height: 1.5,
                        fontFamily: 'Gilroy-Medium',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _rejectRequest(request),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => _acceptRequest(request),
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Accept Request'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressCard(LabTestRequest request) {
    // Similar structure but with "Upload Report" button
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.science_rounded,
                    color: Color(0xFF3B82F6),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.testTypes.join(', '),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      Text(
                        'In progress since ${_formatDate(request.acceptedAt!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Gilroy-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _uploadReport(request),
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: const Text('Upload Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(LabTestRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1FAE5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.testTypes.join(', '),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                  Text(
                    'Completed ${_formatDate(request.completedAt!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontFamily: 'Gilroy-Medium',
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
            fontFamily: 'Gilroy-SemiBold',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontFamily: 'Gilroy-Medium',
            ),
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(LabTestPriority priority) {
    switch (priority) {
      case LabTestPriority.urgent:
        return const Color(0xFFEF4444);
      case LabTestPriority.normal:
        return const Color(0xFF3B82F6);
      case LabTestPriority.routine:
        return const Color(0xFF10B981);
    }
  }

  IconData _getPriorityIcon(LabTestPriority priority) {
    switch (priority) {
      case LabTestPriority.urgent:
        return Icons.priority_high_rounded;
      case LabTestPriority.normal:
        return Icons.science_rounded;
      case LabTestPriority.routine:
        return Icons.schedule_rounded;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  Future<void> _acceptRequest(LabTestRequest request) async {
    try {
      // Call workflow engine
      final workflowService = HealthcareWorkflowService();
      final success = await workflowService.handleLabTestAcceptance(
        request.id,
        'current_lab_id', // In real implementation, get from auth
      );

      if (success) {
        _showSuccess('Test request accepted successfully');
        _loadTestRequests();
      } else {
        _showError('Failed to accept request');
      }
    } catch (e) {
      _showError('Error accepting request: $e');
    }
  }

  Future<void> _rejectRequest(LabTestRequest request) async {
    // Show dialog to get rejection reason
    final reason = await _showRejectDialog();
    if (reason == null) return;

    try {
      // In real implementation, call backend API
      _showSuccess('Test request rejected');
      _loadTestRequests();
    } catch (e) {
      _showError('Error rejecting request: $e');
    }
  }

  Future<void> _uploadReport(LabTestRequest request) async {
    // Show dialog to upload report
    final result = await _showUploadReportDialog(request);
    if (result == null) return;

    try {
      // Call workflow engine
      final workflowService = HealthcareWorkflowService();
      final success = await workflowService.handleLabReportUpload(
        request.id,
        result['reportUrl'],
        result['reportNotes'],
      );

      if (success) {
        _showSuccess('Report uploaded successfully');
        _loadTestRequests();
      } else {
        _showError('Failed to upload report');
      }
    } catch (e) {
      _showError('Error uploading report: $e');
    }
  }

  Future<String?> _showRejectDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Test Request'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Reason for rejection',
            hintText: 'Enter reason...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>?> _showUploadReportDialog(LabTestRequest request) async {
    final notesController = TextEditingController();
    final urlController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Upload Test Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Report URL',
                hintText: 'Enter report file URL...',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Report Notes',
                hintText: 'Enter findings...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx, {
                'reportUrl': urlController.text,
                'reportNotes': notesController.text,
              });
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

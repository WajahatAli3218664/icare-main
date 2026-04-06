import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/models/health_program_assignment.dart';
import 'package:icare/utils/theme.dart';

/// Patient Health Journey Screen
///
/// This is what patients see instead of "My Learning" or "Courses"
/// Shows health programs assigned by their doctor as part of treatment
class PatientHealthJourneyScreen extends ConsumerStatefulWidget {
  const PatientHealthJourneyScreen({super.key});

  @override
  ConsumerState<PatientHealthJourneyScreen> createState() =>
      _PatientHealthJourneyScreenState();
}

class _PatientHealthJourneyScreenState
    extends ConsumerState<PatientHealthJourneyScreen> {
  bool _isLoading = true;
  List<HealthProgramAssignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
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
              'My Health Journey',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Programs assigned by your doctor',
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
            onPressed: _loadAssignments,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryColor),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _assignments.isEmpty
              ? _buildEmptyState()
              : _buildProgramsList(),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.favorite_border_rounded,
              size: 64,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Health Programs Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your doctor will assign health programs\nas part of your treatment plan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Gilroy-Medium',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsList() {
    final inProgress = _assignments.where((a) => a.status == HealthProgramAssignmentStatus.inProgress).toList();
    final assigned = _assignments.where((a) => a.status == HealthProgramAssignmentStatus.assigned).toList();
    final completed = _assignments.where((a) => a.status == HealthProgramAssignmentStatus.completed).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (inProgress.isNotEmpty) ...[
          const Text(
            'In Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 12),
          ...inProgress.map((a) => _buildProgramCard(a, true)),
          const SizedBox(height: 24),
        ],
        if (assigned.isNotEmpty) ...[
          const Text(
            'Assigned by Your Doctor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 12),
          ...assigned.map((a) => _buildProgramCard(a, false)),
          const SizedBox(height: 24),
        ],
        if (completed.isNotEmpty) ...[
          const Text(
            'Completed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy-Bold',
            ),
          ),
          const SizedBox(height: 12),
          ...completed.map((a) => _buildCompletedCard(a)),
        ],
      ],
    );
  }

  Widget _buildProgramCard(HealthProgramAssignment assignment, bool inProgress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: inProgress ? AppColors.primaryColor.withOpacity(0.3) : const Color(0xFFF1F5F9),
          width: inProgress ? 2 : 1.5,
        ),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite, color: AppColors.primaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.programName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Assigned by Dr. ${assignment.doctorId.substring(0, 8)}',
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (assignment.reasonForAssignment.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            assignment.reasonForAssignment,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF92400E),
                              fontFamily: 'Gilroy-Medium',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (inProgress) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        '${assignment.progressPercentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: assignment.progressPercentage / 100,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openProgram(assignment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(inProgress ? 'Continue Program' : 'Start Program'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(HealthProgramAssignment assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1FAE5), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.programName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy-Bold',
                  ),
                ),
                Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openProgram(HealthProgramAssignment assignment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${assignment.programName}')),
    );
  }
}

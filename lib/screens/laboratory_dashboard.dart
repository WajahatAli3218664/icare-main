import 'package:flutter/material.dart';
import '../services/laboratory_service.dart';
import 'package:intl/intl.dart';
import 'package:icare/screens/lab_bookings_management.dart';
import 'package:icare/screens/lab_tests_management.dart';
import 'package:icare/screens/lab_analytics.dart';
import 'package:icare/screens/settings.dart';
import 'package:icare/screens/payment_invoices.dart';
import 'package:icare/screens/tasks.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'dart:async';

class LaboratoryDashboard extends StatefulWidget {
  const LaboratoryDashboard({super.key});

  @override
  State<LaboratoryDashboard> createState() => _LaboratoryDashboardState();
}

class _LaboratoryDashboardState extends State<LaboratoryDashboard> with SingleTickerProviderStateMixin {
  final LaboratoryService _labService = LaboratoryService();
  bool _isLoading = true;
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _labProfile;
  String? _error;
  Timer? _refreshTimer;
  int _lastKnownBookingCount = 0;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  // Premium Theme Colors
  final Color primaryColor = const Color(0xFF0B2D6E);
  final Color secondaryColor = const Color(0xFF1565C0);
  final Color accentColor = const Color(0xFF0EA5E9);
  final Color backgroundColor = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
    );
    _loadData();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      if (mounted && !_isLoading) {
        _checkForNewBookings();
      }
    });
  }

  Future<void> _checkForNewBookings() async {
    try {
      if (_labProfile == null) return;
      final stats = await _labService.getDashboardStats(_labProfile!['_id']);
      final currentCount = stats['totalBookings'] ?? 0;
      
      if (currentCount > _lastKnownBookingCount && _lastKnownBookingCount > 0) {
        _showNewBookingNotification();
        _loadData(); // Full refresh to update UI
      }
      _lastKnownBookingCount = currentCount;
    } catch (e) {
      debugPrint('Error auto-refreshing: $e');
    }
  }

  void _showNewBookingNotification() {
    SmartDialog.showToast(
      '',
      builder: (context) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_active_rounded, color: Colors.white),
            const SizedBox(width: 12),
            const Text(
              'New Lab Booking Received!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () {
                SmartDialog.dismiss();
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabBookingsManagement()));
              },
              child: const Text('VIEW', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
      displayTime: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _labService.getProfile();
      final stats = await _labService.getDashboardStats(profile['_id']);

      setState(() {
        _labProfile = profile;
        _stats = stats;
        _lastKnownBookingCount = stats['totalBookings'] ?? 0;
        _isLoading = false;
      });
      _animationController?.forward();
    } catch (e) {
      setState(() {
        _error = "Unable to load dashboard data right now. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text('Loading dashboard...', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 64, color: Color(0xFFEF4444)),
                      const SizedBox(height: 16),
                      Column(children: [const Text('Unable to load dashboard right now', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))), const SizedBox(height: 8), const Text('Please check your connection and try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),]),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: primaryColor,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: _fadeAnimation != null
                        ? FadeTransition(
                            opacity: _fadeAnimation!,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildWelcomeCard(isMobile),
                                const SizedBox(height: 24),
                                _buildStatsGrid(isMobile),
                                const SizedBox(height: 32),
                                _buildQuickActions(isMobile),
                                const SizedBox(height: 32),
                                _buildRecentActivity(isMobile),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelcomeCard(isMobile),
                              const SizedBox(height: 24),
                              _buildStatsGrid(isMobile),
                              const SizedBox(height: 32),
                              _buildQuickActions(isMobile),
                              const SizedBox(height: 32),
                              _buildRecentActivity(isMobile),
                            ],
                          ),
                  ),
                ),
    );
  }

  Widget _buildWelcomeCard(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.science,
              size: 150,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Icon(
                    Icons.biotech,
                    size: isMobile ? 40 : 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _labProfile?['labName'] ?? 'Laboratory Dashboard',
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome back! Here\'s your overview',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: accentColor),
                            const SizedBox(width: 6),
                            Text(
                              _labProfile?['city'] ?? 'Location not set',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabBookingsManagement())),
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isMobile) {
    final stats = [
      {
        'title': 'Pending Requests',
        'value': _stats?['pendingBookings']?.toString() ?? '0',
        'icon': Icons.pending_actions_rounded,
        'trend': 'Needs Action',
        'color': Colors.orange,
      },
      {
        'title': 'In Progress',
        'value': _stats?['inProgressBookings']?.toString() ?? '0',
        'icon': Icons.hourglass_bottom_rounded,
        'trend': 'Processing',
        'color': Colors.blue,
      },
      {
        'title': 'Completed',
        'value': _stats?['completedBookings']?.toString() ?? '0',
        'icon': Icons.task_alt_rounded,
        'trend': 'Done',
        'color': Colors.green,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 2.5 : 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final statColor = stat['color'] as Color;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: statColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: statColor.withOpacity(0.2)),
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        color: statColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        size: isMobile ? 22 : 26,
                        color: statColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        stat['trend'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat['value'] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat['title'] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: primaryColor),
              child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildActionButton(
                  'Bookings',
                  Icons.list_alt_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabBookingsManagement())),
                  isMobile,
                ),
                _buildActionButton(
                  'Manage Tests',
                  Icons.science_outlined,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabTestsManagement())),
                  isMobile,
                ),
                _buildActionButton(
                  'Analytics',
                  Icons.analytics_outlined,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabAnalytics())),
                  isMobile,
                ),
                _buildActionButton(
                  'Invoices',
                  Icons.receipt_long_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PaymentInvoices())),
                  isMobile,
                ),
                _buildActionButton(
                  'Tasks',
                  Icons.task_alt_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TaskScreen())),
                  isMobile,
                ),
                _buildActionButton(
                  'Settings',
                  Icons.settings_outlined,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen())),
                  isMobile,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap, bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: primaryColor.withOpacity(0.05),
        splashColor: primaryColor.withOpacity(0.1),
        child: Container(
          width: isMobile ? 140 : 160,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 16 : 20,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Icon(icon, color: primaryColor, size: isMobile ? 24 : 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(bool isMobile) {
    final testRequests = _stats?['recentActivity'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Test Requests',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabBookingsManagement())),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('View All'),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: testRequests.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox_rounded, size: 48, color: Color(0xFF94A3B8)),
                        SizedBox(height: 12),
                        Text(
                          'No test requests yet',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: testRequests.map((request) => _buildTestRequestRow(request, isMobile)).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildTestRequestRow(Map<String, dynamic> request, bool isMobile) {
    final status = request['status']?.toString().toLowerCase() ?? 'pending';
    final statusColor = _getStatusColor(status);
    final patientName = request['patient']?['name'] ?? 'Unknown Patient';
    final doctorName = request['doctor']?['name'] ?? 'N/A';
    final testName = request['testName'] ?? (request['tests'] as List<dynamic>?)?.map((t) => t['testName']).join(', ') ?? 'Test';
    final date = DateTime.tryParse(request['date'] ?? request['createdAt'] ?? '') ?? DateTime.now();
    final bookingId = request['_id'] ?? request['id'];

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isMobile ? 1 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.medical_services_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Dr. $doctorName',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isMobile) const SizedBox(width: 16),
              Expanded(
                flex: isMobile ? 1 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.science_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            testName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('MMM dd, yyyy').format(date),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isMobile) const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionButtons(status, bookingId, isMobile),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String status, String? bookingId, bool isMobile) {
    if (bookingId == null) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (status == 'pending')
          ElevatedButton.icon(
            onPressed: () => _acceptRequest(bookingId),
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text('Accept Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        if (status == 'confirmed' || status == 'in_progress')
          ElevatedButton.icon(
            onPressed: () => _markAsCompleted(bookingId),
            icon: const Icon(Icons.task_alt, size: 16),
            label: const Text('Mark Completed'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        if (status == 'confirmed' || status == 'in_progress')
          OutlinedButton.icon(
            onPressed: () => _uploadReport(bookingId),
            icon: const Icon(Icons.upload_file, size: 16),
            label: const Text('Upload Report'),
            style: OutlinedButton.styleFrom(
              foregroundColor: accentColor,
              side: BorderSide(color: accentColor),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LabBookingsManagement())),
          icon: const Icon(Icons.visibility_outlined, size: 16),
          label: const Text('View Details'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _acceptRequest(String bookingId) async {
    try {
      await _labService.updateBookingStatus(bookingId, 'confirmed');
      SmartDialog.showToast('Request accepted successfully');
      _loadData();
    } catch (e) {
      SmartDialog.showToast('Unable to accept request. Please try again.');
    }
  }

  Future<void> _markAsCompleted(String bookingId) async {
    try {
      await _labService.updateBookingStatus(bookingId, 'completed');
      SmartDialog.showToast('Test marked as completed');
      _loadData();
    } catch (e) {
      SmartDialog.showToast('Unable to update status. Please try again.');
    }
  }

  Future<void> _uploadReport(String bookingId) async {
    SmartDialog.showToast('Report upload feature coming soon');
  }
}

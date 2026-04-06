import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/services/pharmacy_service.dart';
import 'package:icare/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// Pharmacy Fulfillment Dashboard
///
/// This is the PROPER pharmacy dashboard for pharmacy staff.
/// It follows the fulfillment workflow pattern:
/// 1. Receive prescriptions from patients (who requested fulfillment)
/// 2. Accept orders
/// 3. Prepare medicines
/// 4. Dispatch orders
/// 5. Mark as delivered
///
/// This is NOT a patient shopping interface.
class PharmacyFulfillmentDashboard extends ConsumerStatefulWidget {
  const PharmacyFulfillmentDashboard({super.key});

  @override
  ConsumerState<PharmacyFulfillmentDashboard> createState() =>
      _PharmacyFulfillmentDashboardState();
}

class _PharmacyFulfillmentDashboardState
    extends ConsumerState<PharmacyFulfillmentDashboard>
    with SingleTickerProviderStateMixin {
  final PharmacyService _pharmacyService = PharmacyService();
  late TabController _tabController;
  bool _isLoading = true;

  // Orders from backend
  List<dynamic> _newOrders = [];
  List<dynamic> _preparingOrders = [];
  List<dynamic> _dispatchedOrders = [];
  List<dynamic> _deliveredOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    try {
      // Fetch all orders from backend
      final allOrders = await _pharmacyService.getPharmacyOrders();

      // Categorize orders by status
      _newOrders = allOrders.where((o) => o['status'] == 'pending').toList();
      _preparingOrders = allOrders.where((o) => o['status'] == 'preparing' || o['status'] == 'accepted').toList();
      _dispatchedOrders = allOrders.where((o) => o['status'] == 'dispatched').toList();
      _deliveredOrders = allOrders.where((o) => o['status'] == 'delivered' || o['status'] == 'completed').toList();

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading orders: $e');
      setState(() => _isLoading = false);
      _showError('Unable to load orders. Please check your connection.');
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
              'Pharmacy Fulfillment',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Manage prescription orders',
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
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryColor),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () {
              // Navigate to inventory management
            },
            icon: const Icon(Icons.inventory_2_outlined, color: AppColors.primaryColor),
            tooltip: 'Inventory',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Stats Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    _buildStatChip(
                      'New',
                      _newOrders.length,
                      Icons.new_releases_rounded,
                      const Color(0xFFF59E0B),
                      const Color(0xFFFEF3C7),
                    ),
                    const SizedBox(width: 10),
                    _buildStatChip(
                      'Preparing',
                      _preparingOrders.length,
                      Icons.medication_rounded,
                      const Color(0xFF3B82F6),
                      const Color(0xFFDBEAFE),
                    ),
                    const SizedBox(width: 10),
                    _buildStatChip(
                      'Dispatched',
                      _dispatchedOrders.length,
                      Icons.local_shipping_rounded,
                      const Color(0xFF8B5CF6),
                      const Color(0xFFEDE9FE),
                    ),
                    const SizedBox(width: 10),
                    _buildStatChip(
                      'Delivered',
                      _deliveredOrders.length,
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
                  isScrollable: true,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.5,
                    fontFamily: 'Gilroy-Bold',
                  ),
                  tabs: const [
                    Tab(text: 'NEW ORDERS'),
                    Tab(text: 'PREPARING'),
                    Tab(text: 'DISPATCHED'),
                    Tab(text: 'DELIVERED'),
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
                    _buildNewOrdersList(),
                    _buildPreparingList(),
                    _buildDispatchedList(),
                    _buildDeliveredList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
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
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Gilroy-SemiBold',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewOrdersList() {
    if (_newOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox_rounded,
        title: 'No New Orders',
        subtitle: 'Prescription orders from patients will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _newOrders.length,
      itemBuilder: (ctx, i) => _buildNewOrderCard(_newOrders[i]),
    );
  }

  Widget _buildPreparingList() {
    if (_preparingOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.medication_rounded,
        title: 'No Orders Being Prepared',
        subtitle: 'Orders you accept will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _preparingOrders.length,
      itemBuilder: (ctx, i) => _buildPreparingCard(_preparingOrders[i]),
    );
  }

  Widget _buildDispatchedList() {
    if (_dispatchedOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.local_shipping_rounded,
        title: 'No Dispatched Orders',
        subtitle: 'Orders ready for delivery will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _dispatchedOrders.length,
      itemBuilder: (ctx, i) => _buildDispatchedCard(_dispatchedOrders[i]),
    );
  }

  Widget _buildDeliveredList() {
    if (_deliveredOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'No Delivered Orders',
        subtitle: 'Completed deliveries will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _deliveredOrders.length,
      itemBuilder: (ctx, i) => _buildDeliveredCard(_deliveredOrders[i]),
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
            child: Icon(icon, size: 48, color: AppColors.primaryColor.withOpacity(0.5)),
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

  Widget _buildNewOrderCard(Map<String, dynamic> order) {
    final orderId = order['_id'] ?? order['id'] ?? 'N/A';
    final patientName = order['patient']?['name'] ?? order['patientName'] ?? 'Unknown Patient';
    final doctorName = order['doctor']?['name'] ?? order['doctorName'] ?? 'N/A';
    final items = order['items'] as List<dynamic>? ?? [];
    final totalAmount = order['totalAmount'] ?? 0;
    final createdAt = DateTime.tryParse(order['createdAt'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFEF3C7), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
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
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFF59E0B), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId.toString().substring(0, orderId.toString().length > 8 ? 8 : orderId.toString().length)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      Text(
                        '${items.length} medicines • PKR $totalAmount',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Gilroy-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'NEW',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF59E0B),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Patient: $patientName',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Gilroy-Medium',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.medical_services_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Prescribed by: Dr. $doctorName',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Gilroy-Medium',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(createdAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontFamily: 'Gilroy-Medium',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewOrderDetails(order),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: AppColors.primaryColor.withOpacity(0.3)),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptOrder(order),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Accept Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreparingCard(Map<String, dynamic> order) {
    final orderId = order['_id'] ?? order['id'] ?? 'N/A';
    final patientName = order['patient']?['name'] ?? order['patientName'] ?? 'Unknown Patient';
    final items = order['items'] as List<dynamic>? ?? [];
    final totalAmount = order['totalAmount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
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
                  child: const Icon(Icons.medication_rounded, color: Color(0xFF3B82F6), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId.toString().substring(0, orderId.toString().length > 8 ? 8 : orderId.toString().length)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      Text(
                        'Patient: $patientName',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Gilroy-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'PREPARING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B82F6),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Medicines (${items.length}):',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Gilroy-SemiBold',
              ),
            ),
            const SizedBox(height: 8),
            ...items.take(3).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${item['medicineName'] ?? item['name'] ?? 'Medicine'} × ${item['quantity'] ?? 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'Gilroy-Medium',
                      ),
                    ),
                  ),
                ],
              ),
            )),
            if (items.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+ ${items.length - 3} more items',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Gilroy-Medium',
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewOrderDetails(order),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Color(0xFF3B82F6)),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsDispatched(order),
                    icon: const Icon(Icons.local_shipping_rounded, size: 18),
                    label: const Text('Mark as Dispatched'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDispatchedCard(Map<String, dynamic> order) {
    final orderId = order['_id'] ?? order['id'] ?? 'N/A';
    final patientName = order['patient']?['name'] ?? order['patientName'] ?? 'Unknown Patient';
    final items = order['items'] as List<dynamic>? ?? [];
    final dispatchedAt = DateTime.tryParse(order['updatedAt'] ?? order['createdAt'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
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
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_shipping_rounded, color: Color(0xFF8B5CF6), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId.toString().substring(0, orderId.toString().length > 8 ? 8 : orderId.toString().length)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      Text(
                        'Patient: $patientName',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Gilroy-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DISPATCHED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5CF6),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  'Dispatched: ${DateFormat('MMM dd, hh:mm a').format(dispatchedAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontFamily: 'Gilroy-Medium',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  '${items.length} items',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontFamily: 'Gilroy-Medium',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewOrderDetails(order),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsDelivered(order),
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Mark as Delivered'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveredCard(Map<String, dynamic> order) {
    final orderId = order['_id'] ?? order['id'] ?? 'N/A';
    final patientName = order['patient']?['name'] ?? order['patientName'] ?? 'Unknown Patient';
    final items = order['items'] as List<dynamic>? ?? [];
    final totalAmount = order['totalAmount'] ?? 0;
    final deliveredAt = DateTime.tryParse(order['updatedAt'] ?? order['createdAt'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1FAE5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
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
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId.toString().substring(0, orderId.toString().length > 8 ? 8 : orderId.toString().length)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      Text(
                        'Patient: $patientName',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Gilroy-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DELIVERED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                      fontFamily: 'Gilroy-Bold',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF10B981)),
                const SizedBox(width: 6),
                Text(
                  'Delivered: ${DateFormat('MMM dd, hh:mm a').format(deliveredAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontFamily: 'Gilroy-Medium',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  '${items.length} items • PKR $totalAmount',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontFamily: 'Gilroy-Medium',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _viewOrderDetails(order),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: Color(0xFF10B981)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('View Order Details'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    // Show order details dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: AppColors.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Order #${(order['_id'] ?? order['id'] ?? 'N/A').toString().substring(0, 8)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Patient', order['patient']?['name'] ?? order['patientName'] ?? 'N/A'),
              _buildDetailRow('Doctor', 'Dr. ${order['doctor']?['name'] ?? order['doctorName'] ?? 'N/A'}'),
              _buildDetailRow('Status', (order['status'] ?? 'pending').toString().toUpperCase()),
              _buildDetailRow('Total Amount', 'PKR ${order['totalAmount'] ?? 0}'),
              const SizedBox(height: 16),
              const Text(
                'Medicines:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
              const SizedBox(height: 8),
              ...(order['items'] as List<dynamic>? ?? []).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.medication, size: 16, color: AppColors.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['medicineName'] ?? item['name'] ?? 'Medicine',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy-SemiBold',
                            ),
                          ),
                          Text(
                            'Qty: ${item['quantity'] ?? 1} • PKR ${item['price'] ?? 0}',
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
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                fontFamily: 'Gilroy-SemiBold',
              ),
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
      ),
    );
  }

  Future<void> _acceptOrder(Map<String, dynamic> order) async {
    try {
      final orderId = order['_id'] ?? order['id'];
      if (orderId == null) {
        _showError('Invalid order ID');
        return;
      }

      SmartDialog.showLoading(msg: 'Accepting order...');
      await _pharmacyService.updateOrderStatus(orderId, 'preparing');
      SmartDialog.dismiss();

      SmartDialog.showToast('Order accepted successfully');

      _loadOrders();
    } catch (e) {
      SmartDialog.dismiss();
      _showError('Unable to accept order. Please try again.');
    }
  }

  Future<void> _markAsDispatched(Map<String, dynamic> order) async {
    try {
      final orderId = order['_id'] ?? order['id'];
      if (orderId == null) {
        _showError('Invalid order ID');
        return;
      }

      SmartDialog.showLoading(msg: 'Updating status...');
      await _pharmacyService.updateOrderStatus(orderId, 'dispatched');
      SmartDialog.dismiss();

      SmartDialog.showToast('Order marked as dispatched');

      _loadOrders();
    } catch (e) {
      SmartDialog.dismiss();
      _showError('Unable to update status. Please try again.');
    }
  }

  Future<void> _markAsDelivered(Map<String, dynamic> order) async {
    try {
      final orderId = order['_id'] ?? order['id'];
      if (orderId == null) {
        _showError('Invalid order ID');
        return;
      }

      SmartDialog.showLoading(msg: 'Updating status...');
      await _pharmacyService.updateOrderStatus(orderId, 'delivered');
      SmartDialog.dismiss();

      SmartDialog.showToast('Order marked as delivered');

      _loadOrders();
    } catch (e) {
      SmartDialog.dismiss();
      _showError('Unable to update status. Please try again.');
    }
  }

  void _showError(String message) {
    SmartDialog.showToast(message);
  }
}

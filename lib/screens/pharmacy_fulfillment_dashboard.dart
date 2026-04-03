import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/models/prescription.dart';
import 'package:icare/services/healthcare_workflow_service.dart';
import 'package:icare/utils/theme.dart';
import 'package:intl/intl.dart';

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
  late TabController _tabController;
  bool _isLoading = true;

  // Mock data - in real implementation, this would come from backend
  List<Prescription> _newOrders = [];
  List<Prescription> _preparingOrders = [];
  List<Prescription> _dispatchedOrders = [];
  List<Prescription> _deliveredOrders = [];

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
      // In real implementation, fetch from backend API
      // For now, using mock data to demonstrate the workflow

      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _newOrders = [];
      _preparingOrders = [];
      _dispatchedOrders = [];
      _deliveredOrders = [];

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading orders: $e');
      setState(() => _isLoading = false);
      _showError('Failed to load orders');
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

  Widget _buildNewOrderCard(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFEF3C7), width: 2),
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
                        'Order #${prescription.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                      Text(
                        '${prescription.medicines.length} medicines',
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewOrderDetails(prescription),
                    child: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptOrder(prescription),
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

  Widget _buildPreparingCard(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Order #${prescription.id.substring(0, 8)}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _markAsDispatched(prescription),
              icon: const Icon(Icons.local_shipping_rounded, size: 18),
              label: const Text('Mark as Dispatched'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDispatchedCard(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text('Dispatched: ${prescription.id}'),
    );
  }

  Widget _buildDeliveredCard(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text('Delivered: ${prescription.id}'),
    );
  }

  void _viewOrderDetails(Prescription prescription) {}
  void _acceptOrder(Prescription prescription) {}
  void _markAsDispatched(Prescription prescription) {}
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

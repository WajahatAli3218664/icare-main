
import 'package:icare/services/api_service.dart';
import 'package:icare/services/standalone_care_hub_service.dart';

class PharmacyService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();
  String? _cachedPharmacyId;

  Future<List<dynamic>> getAllPharmacies() async {
    try {
      final response = await _apiService.get('/pharmacy/get_all_pharmacy');
      return response.data['pharmacies'] as List;
    } catch (_) {
      return _hub.getAllPharmacies();
    }
  }

  Future<Map<String, dynamic>> getPharmacyProfile() async {
    try {
      final response = await _apiService.get('/pharmacy/profile');
      final pharmacy = response.data['pharmacy'];
      _cachedPharmacyId = pharmacy['_id'];
      return pharmacy;
    } catch (_) {
      final pharmacy = await _hub.getPharmacyProfile();
      _cachedPharmacyId = pharmacy['_id']?.toString();
      return pharmacy;
    }
  }

  Future<Map<String, dynamic>> updatePharmacyProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/pharmacy/add_pharmacy_details', data);
      return response.data['pharmacy'] ?? response.data['existingProfile'];
    } catch (_) {
      return _hub.updatePharmacyProfile(data);
    }
  }

  Future<String> _getPharmacyId() async {
    if (_cachedPharmacyId != null) return _cachedPharmacyId!;
    final profile = await getPharmacyProfile();
    return profile['_id'];
  }

  Future<Map<String, dynamic>> getPharmacyStats() async {
    try {
      final pharmacyId = await _getPharmacyId();
      final ordersResponse = await _apiService.get('/pharmacy/orders/pharmacy/list');
      final orders = ordersResponse.data['orders'] as List;
      final medicinesResponse = await _apiService.get('/pharmacy/products?pharmacyId=$pharmacyId');
      final medicines = medicinesResponse.data['medicines'] as List;
      final totalOrders = orders.length;
      final pendingOrders = orders.where((o) => o['status'] == 'pending').length;
      final completedOrders = orders.where((o) => o['status'] == 'completed').length;
      final totalProducts = medicines.length;
      final lowStock = medicines.where((m) => (m['quantity'] ?? 0) < 30).length;
      final revenue = orders.where((o) => o['status'] == 'completed').fold<double>(0, (sum, o) => sum + (o['totalAmount'] ?? 0).toDouble());
      return {
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'completedOrders': completedOrders,
        'totalProducts': totalProducts,
        'lowStock': lowStock,
        'revenue': revenue.toInt(),
      };
    } catch (_) {
      return _hub.getPharmacyStats();
    }
  }

  Future<List<dynamic>> getMedicines({String? category, String? search}) async {
    try {
      final pharmacyId = await _getPharmacyId();
      String url = '/pharmacy/products?pharmacyId=$pharmacyId';
      if (category != null && category != 'All') {
        url += '&category=${Uri.encodeComponent(category)}';
      }
      if (search != null && search.isNotEmpty) {
        url += '&q=${Uri.encodeComponent(search)}';
      }
      final response = await _apiService.get(url);
      return response.data['medicines'] as List;
    } catch (_) {
      return _hub.getMedicines(category: category, search: search);
    }
  }

  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/pharmacy/products', data);
      return response.data['medicine'];
    } catch (_) {
      return _hub.createMedicine(data);
    }
  }

  Future<Map<String, dynamic>> updateMedicine(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/pharmacy/products/$id', data);
      return response.data['medicine'];
    } catch (_) {
      return _hub.updateMedicine(id, data);
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await _apiService.delete('/pharmacy/products/$id');
    } catch (_) {
      await _hub.deleteMedicine(id);
    }
  }

  Future<List<dynamic>> getPharmacyOrders({String? status}) async {
    try {
      String url = '/pharmacy/orders/pharmacy/list';
      if (status != null && status != 'all') {
        url += '?status=$status';
      }
      final response = await _apiService.get(url);
      return response.data['orders'] as List;
    } catch (_) {
      return _hub.getPharmacyOrders(status: status);
    }
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final response = await _apiService.get('/pharmacy/orders/$orderId');
      return response.data['order'];
    } catch (_) {
      return _hub.getOrderById(orderId);
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _apiService.put('/pharmacy/orders/$orderId/status', {'status': status});
      return response.data['order'];
    } catch (_) {
      return _hub.updateOrderStatus(orderId, status);
    }
  }

  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final pharmacyId = await _getPharmacyId();
      final ordersResponse = await _apiService.get('/pharmacy/orders/pharmacy/list');
      final orders = ordersResponse.data['orders'] as List;
      final medicinesResponse = await _apiService.get('/pharmacy/products?pharmacyId=$pharmacyId');
      final medicines = medicinesResponse.data['medicines'] as List;
      final totalRevenue = orders.where((o) => o['status'] == 'completed').fold<double>(0, (sum, o) => sum + (o['totalAmount'] ?? 0).toDouble());
      final totalOrders = orders.length;
      final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;
      final topSellingProducts = medicines.take(3).map((m) => {
        'name': m['productName'],
        'sales': 100,
        'revenue': (m['price'] ?? 0) * 100,
      }).toList();
      return {
        'totalRevenue': totalRevenue.toInt(),
        'totalOrders': totalOrders,
        'averageOrderValue': averageOrderValue,
        'topSellingProducts': topSellingProducts,
      };
    } catch (_) {
      return _hub.getAnalytics();
    }
  }
}


import 'package:icare/services/api_service.dart';
import 'package:icare/services/standalone_care_hub_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> createOrderFromCart({required String pharmacyId, required String deliveryOption, String? address}) async {
    try {
      final response = await _apiService.post('/pharmacy/orders', {
        'pharmacyId': pharmacyId,
        'deliveryOption': deliveryOption,
        'address': address,
      });
      return response.data['order'];
    } catch (_) {
      return _hub.createOrderFromCart(pharmacyId: pharmacyId, deliveryOption: deliveryOption, address: address);
    }
  }

  Future<List<dynamic>> getMyOrders({String? status}) async {
    try {
      String url = '/pharmacy/orders/my';
      if (status != null && status.isNotEmpty) {
        url += '?status=$status';
      }
      final response = await _apiService.get(url);
      return response.data['orders'] as List;
    } catch (_) {
      return _hub.getMyOrders(status: status);
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

  Future<Map<String, dynamic>> cancelOrder(String orderId, String reason) async {
    try {
      final response = await _apiService.put('/pharmacy/orders/$orderId/cancel', {
        'reason': reason,
      });
      return response.data['order'];
    } catch (_) {
      return _hub.cancelOrder(orderId, reason);
    }
  }
}


import 'package:dio/dio.dart';
import 'api_service.dart';
import 'standalone_care_hub_service.dart';

class MedicalRecordService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> createMedicalRecord(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/medical-records/create', data);
      if (response.statusCode == 201) {
        return {'success': true, 'record': response.data['record']};
      }
      return {'success': false, 'message': 'Failed to create record'};
    } on DioException catch (_) {
      return _hub.createMedicalRecord(data);
    } catch (_) {
      return _hub.createMedicalRecord(data);
    }
  }

  Future<Map<String, dynamic>> getPatientRecords(String patientId) async {
    try {
      final response = await _apiService.get('/medical-records/patient/$patientId');
      if (response.statusCode == 200) {
        return {'success': true, 'records': response.data['records']};
      }
      return {'success': false, 'message': 'Failed to fetch records'};
    } on DioException catch (_) {
      return _hub.getPatientRecords(patientId);
    } catch (_) {
      return _hub.getPatientRecords(patientId);
    }
  }

  Future<Map<String, dynamic>> getDoctorRecords() async {
    try {
      final response = await _apiService.get('/medical-records/doctor');
      if (response.statusCode == 200) {
        return {'success': true, 'records': response.data['records']};
      }
      return {'success': false, 'message': 'Failed to fetch records'};
    } on DioException catch (_) {
      return _hub.getDoctorRecords();
    } catch (_) {
      return _hub.getDoctorRecords();
    }
  }

  Future<Map<String, dynamic>> getRecordById(String recordId) async {
    try {
      final response = await _apiService.get('/medical-records/$recordId');
      if (response.statusCode == 200) {
        return {'success': true, 'record': response.data['record']};
      }
      return {'success': false, 'message': 'Failed to fetch record'};
    } on DioException catch (_) {
      return _hub.getRecordById(recordId);
    } catch (_) {
      return _hub.getRecordById(recordId);
    }
  }

  Future<Map<String, dynamic>> updateMedicalRecord(String recordId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/medical-records/$recordId', data);
      if (response.statusCode == 200) {
        return {'success': true, 'record': response.data['record']};
      }
      return {'success': false, 'message': 'Failed to update record'};
    } on DioException catch (_) {
      return _hub.updateMedicalRecord(recordId, data);
    } catch (_) {
      return _hub.updateMedicalRecord(recordId, data);
    }
  }
}

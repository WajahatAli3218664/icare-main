import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/shared_pref.dart';
import '../utils/role_ui.dart';

class StandalonePhase4Service {
  StandalonePhase4Service._internal();
  static final StandalonePhase4Service _instance = StandalonePhase4Service._internal();
  factory StandalonePhase4Service() => _instance;

  static const String _dbKey = 'standalone_phase4_db';
  final SharedPref _sharedPref = SharedPref();

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<Map<String, dynamic>> _loadDb() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_dbKey);
    if (raw == null || raw.isEmpty) {
      final seeded = _seedDb();
      await prefs.setString(_dbKey, jsonEncode(seeded));
      return seeded;
    }
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _saveDb(Map<String, dynamic> db) async {
    final prefs = await _prefs();
    await prefs.setString(_dbKey, jsonEncode(db));
  }

  Future<void> ensureSeeded() async {
    await _loadDb();
  }

  List<Map<String, dynamic>> _listOfMaps(Map<String, dynamic> db, String key) {
    final list = (db[key] as List?) ?? <dynamic>[];
    return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<String, dynamic>> _currentUser() async {
    final user = await _sharedPref.getUserData();
    return {
      '_id': user?.id ?? 'seed-admin-1',
      'name': user?.name ?? 'Admin User',
      'email': user?.email ?? 'admin@icare.demo',
      'role': normalizeRoleName(user?.role ?? 'Admin'),
    };
  }

  Map<String, dynamic> _seedDb() {
    final now = DateTime.now();
    return {
      'analyticsSnapshots': [
        {
          '_id': 'snap-1',
          'date': now.toIso8601String(),
          'patients': 128,
          'activeDoctors': 26,
          'consultationsToday': 42,
          'labRequestsToday': 19,
          'pharmacyOrdersToday': 23,
          'subscriptionRevenue': 185000,
          'consultationRevenue': 96000,
          'pharmacyRevenue': 123500,
          'labRevenue': 74000,
          'avgLabTurnaroundHours': 11.2,
          'prescriptionFulfillmentRate': 91,
          'consultationCompletionRate': 88,
          'dailyLogins': 174,
          'carePlanEngagement': 67,
        }
      ],
      'securitySettings': {
        'emailVerified': false,
        'twoFactorEnabled': false,
        'biometricEnabled': false,
        'rememberMeEnabled': true,
        'trustedDevices': [
          {'name': 'Chrome on Windows', 'lastSeen': now.subtract(const Duration(hours: 3)).toIso8601String()},
          {'name': 'Android App', 'lastSeen': now.subtract(const Duration(days: 1)).toIso8601String()},
        ],
      },
      'securityEvents': [
        {
          '_id': 'sec4-1',
          'title': 'New device sign-in detected',
          'severity': 'medium',
          'details': 'A new browser session was created from Lahore, Pakistan.',
          'createdAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
        },
        {
          '_id': 'sec4-2',
          'title': 'Email verification pending',
          'severity': 'info',
          'details': 'Primary account email still needs verification.',
          'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
      ],
      'referrals': [
        {
          '_id': 'ref4-1',
          'patientName': 'Ayesha Khan',
          'fromDoctor': 'Dr. Bilal Ahmed',
          'toSpecialty': 'Cardiology',
          'reason': 'Hypertension with chest discomfort',
          'priority': 'high',
          'status': 'pending specialist review',
          'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          '_id': 'ref4-2',
          'patientName': 'Sara Ahmed',
          'fromDoctor': 'Dr. Maham Tariq',
          'toSpecialty': 'Endocrinology',
          'reason': 'Diabetes management escalation',
          'priority': 'normal',
          'status': 'accepted',
          'createdAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        },
      ],
      'chronicCarePrograms': [
        {
          '_id': 'cc-1',
          'name': 'Diabetes 90-Day Care Plan',
          'condition': 'Diabetes',
          'duration': '90 days',
          'includes': ['Medication reminders', 'Weekly sugar logs', 'Doctor follow-up', 'Health program lessons'],
          'status': 'active',
        },
        {
          '_id': 'cc-2',
          'name': 'Hypertension Control Plan',
          'condition': 'Hypertension',
          'duration': '60 days',
          'includes': ['BP tracking', 'Lab follow-up', 'Low-salt education', 'Care coordinator review'],
          'status': 'active',
        },
        {
          '_id': 'cc-3',
          'name': 'Post-Surgery Recovery Plan',
          'condition': 'Post-surgery',
          'duration': '45 days',
          'includes': ['Pain tracking', 'Rehab lessons', 'Medicine adherence', 'Progress review'],
          'status': 'draft',
        },
      ],
      'qaMetrics': [
        {'label': 'Clinical notes completeness', 'value': 84, 'target': 95},
        {'label': 'Lab SLA compliance', 'value': 79, 'target': 90},
        {'label': 'Prescription fulfillment', 'value': 91, 'target': 95},
        {'label': 'Referral closure rate', 'value': 68, 'target': 85},
      ],
      'adminQueues': [
        {
          '_id': 'queue-1',
          'type': 'Doctor approval',
          'subject': 'Dr. Hamza Salman',
          'status': 'pending',
          'submittedAt': now.subtract(const Duration(hours: 9)).toIso8601String(),
        },
        {
          '_id': 'queue-2',
          'type': 'Pharmacy verification',
          'subject': 'CareMed Pharmacy',
          'status': 'pending',
          'submittedAt': now.subtract(const Duration(hours: 15)).toIso8601String(),
        },
      ],
    };
  }

  Future<Map<String, dynamic>> getAnalyticsDashboard() async {
    final db = await _loadDb();
    final snapshot = _listOfMaps(db, 'analyticsSnapshots').first;
    final qaMetrics = _listOfMaps(db, 'qaMetrics');
    return {
      'headline': {
        'patients': snapshot['patients'] ?? 0,
        'activeDoctors': snapshot['activeDoctors'] ?? 0,
        'consultationsToday': snapshot['consultationsToday'] ?? 0,
        'labRequestsToday': snapshot['labRequestsToday'] ?? 0,
        'pharmacyOrdersToday': snapshot['pharmacyOrdersToday'] ?? 0,
      },
      'revenue': {
        'subscriptionRevenue': snapshot['subscriptionRevenue'] ?? 0,
        'consultationRevenue': snapshot['consultationRevenue'] ?? 0,
        'pharmacyRevenue': snapshot['pharmacyRevenue'] ?? 0,
        'labRevenue': snapshot['labRevenue'] ?? 0,
      },
      'quality': {
        'avgLabTurnaroundHours': snapshot['avgLabTurnaroundHours'] ?? 0,
        'prescriptionFulfillmentRate': snapshot['prescriptionFulfillmentRate'] ?? 0,
        'consultationCompletionRate': snapshot['consultationCompletionRate'] ?? 0,
        'dailyLogins': snapshot['dailyLogins'] ?? 0,
        'carePlanEngagement': snapshot['carePlanEngagement'] ?? 0,
      },
      'qaMetrics': qaMetrics,
    };
  }

  Future<Map<String, dynamic>> getSecurityCenter() async {
    final db = await _loadDb();
    return {
      'settings': Map<String, dynamic>.from(db['securitySettings'] as Map? ?? {}),
      'events': _listOfMaps(db, 'securityEvents'),
    };
  }

  Future<void> updateSecuritySetting(String key, bool value) async {
    final db = await _loadDb();
    final settings = Map<String, dynamic>.from(db['securitySettings'] as Map? ?? {});
    settings[key] = value;
    db['securitySettings'] = settings;
    final events = _listOfMaps(db, 'securityEvents');
    events.insert(0, {
      '_id': 'sec4-${DateTime.now().millisecondsSinceEpoch}',
      'title': '${key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}').trim()} updated',
      'severity': 'info',
      'details': 'Security preference changed to ${value ? 'enabled' : 'disabled'}.',
      'createdAt': DateTime.now().toIso8601String(),
    });
    db['securityEvents'] = events;
    await _saveDb(db);
  }

  Future<void> completeEmailVerification() => updateSecuritySetting('emailVerified', true);
  Future<void> toggleTwoFactor(bool enabled) => updateSecuritySetting('twoFactorEnabled', enabled);
  Future<void> toggleBiometric(bool enabled) => updateSecuritySetting('biometricEnabled', enabled);

  Future<Map<String, dynamic>> getReferralCenter() async {
    final db = await _loadDb();
    final referrals = _listOfMaps(db, 'referrals');
    final pending = referrals.where((item) => (item['status']?.toString() ?? '').toLowerCase().contains('pending')).length;
    final accepted = referrals.where((item) => (item['status']?.toString() ?? '').toLowerCase() == 'accepted').length;
    return {
      'summary': {
        'total': referrals.length,
        'pending': pending,
        'accepted': accepted,
      },
      'referrals': referrals,
    };
  }

  Future<void> updateReferralStatus(String referralId, String status) async {
    final db = await _loadDb();
    final referrals = _listOfMaps(db, 'referrals');
    for (final item in referrals) {
      if (item['_id'] == referralId) {
        item['status'] = status;
      }
    }
    db['referrals'] = referrals;
    await _saveDb(db);
  }

  Future<Map<String, dynamic>> getChronicCareCenter() async {
    final db = await _loadDb();
    final programs = _listOfMaps(db, 'chronicCarePrograms');
    final active = programs.where((item) => item['status'] == 'active').length;
    return {
      'summary': {'totalPrograms': programs.length, 'activePrograms': active},
      'programs': programs,
    };
  }

  Future<Map<String, dynamic>> getQaCommandCenter() async {
    final db = await _loadDb();
    final metrics = _listOfMaps(db, 'qaMetrics');
    final belowTarget = metrics.where((item) => ((item['value'] as num?)?.toInt() ?? 0) < ((item['target'] as num?)?.toInt() ?? 0)).length;
    return {
      'belowTarget': belowTarget,
      'metrics': metrics,
      'adminQueues': _listOfMaps(db, 'adminQueues'),
    };
  }

  Future<Map<String, dynamic>> getPhase4BackofficeOverview() async {
    final analytics = await getAnalyticsDashboard();
    final qa = await getQaCommandCenter();
    final user = await _currentUser();
    return {
      'user': user,
      'analytics': analytics,
      'qa': qa,
    };
  }
}

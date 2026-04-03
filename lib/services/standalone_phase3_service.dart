import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/shared_pref.dart';
import '../utils/role_ui.dart';

class StandalonePhase3Service {
  StandalonePhase3Service._internal();
  static final StandalonePhase3Service _instance = StandalonePhase3Service._internal();
  factory StandalonePhase3Service() => _instance;

  static const String _dbKey = 'standalone_phase3_db';
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

  Future<Map<String, dynamic>> _currentUser() async {
    final user = await _sharedPref.getUserData();
    return {
      '_id': user?.id ?? 'seed-patient-1',
      'name': user?.name ?? 'Patient User',
      'email': user?.email ?? 'patient1@icare.demo',
      'role': normalizeRoleName(user?.role ?? 'Patient'),
    };
  }

  Future<void> ensureSeeded() async {
    await _loadDb();
  }

  List<Map<String, dynamic>> _listOfMaps(Map<String, dynamic> db, String key) {
    final list = (db[key] as List?) ?? <dynamic>[];
    return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Map<String, dynamic> _seedDb() {
    final now = DateTime.now();
    return {
      'lifestyleEntries': [
        {
          '_id': 'life-1',
          'userId': 'seed-patient-1',
          'patientName': 'Ayesha Khan',
          'metric': 'Blood Pressure',
          'value': '120/80',
          'unit': 'mmHg',
          'trend': 'stable',
          'note': 'Morning reading',
          'createdAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
        },
        {
          '_id': 'life-2',
          'userId': 'seed-patient-1',
          'patientName': 'Ayesha Khan',
          'metric': 'Blood Sugar',
          'value': '102',
          'unit': 'mg/dL',
          'trend': 'improving',
          'note': 'Before breakfast',
          'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          '_id': 'life-3',
          'userId': 'seed-patient-2',
          'patientName': 'Ali Raza',
          'metric': 'Weight',
          'value': '81',
          'unit': 'kg',
          'trend': 'improving',
          'note': 'Weekly check-in',
          'createdAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        },
        {
          '_id': 'life-4',
          'userId': 'seed-patient-3',
          'patientName': 'Sara Ahmed',
          'metric': 'Sleep',
          'value': '7.5',
          'unit': 'hrs',
          'trend': 'stable',
          'note': 'Tracked automatically',
          'createdAt': now.subtract(const Duration(days: 1, hours: 4)).toIso8601String(),
        },
      ],
      'habits': [
        {
          '_id': 'habit-1',
          'title': 'Take medication on time',
          'category': 'Medication',
          'target': '2 times daily',
          'points': 20,
          'streak': 4,
          'lastCompletedDate': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          '_id': 'habit-2',
          'title': 'Upload daily health reading',
          'category': 'Monitoring',
          'target': '1 reading daily',
          'points': 15,
          'streak': 3,
          'lastCompletedDate': now.subtract(const Duration(days: 2)).toIso8601String(),
        },
        {
          '_id': 'habit-3',
          'title': 'Complete care program lesson',
          'category': 'Learning',
          'target': '3 lessons weekly',
          'points': 25,
          'streak': 2,
          'lastCompletedDate': null,
        },
      ],
      'badges': [
        {'_id': 'badge-1', 'title': 'Care Plan Starter', 'description': 'Completed your first assigned health program', 'earned': true},
        {'_id': 'badge-2', 'title': 'Medication Hero', 'description': 'Maintained a 7-day medicine streak', 'earned': false},
        {'_id': 'badge-3', 'title': 'Healthy Habits Champion', 'description': 'Logged 15 lifestyle updates', 'earned': false},
      ],
      'languageSettings': {
        'selectedLanguage': 'English',
        'supportedLanguages': ['English', 'Urdu', 'Arabic'],
        'voiceInputEnabled': true,
        'textToSpeechEnabled': false,
      },
      'voiceNotes': [
        {
          '_id': 'voice-1',
          'userId': 'seed-patient-1',
          'title': 'Follow-up summary',
          'transcript': 'Reminder to continue hypertension care plan and complete labs before follow-up.',
          'language': 'English',
          'durationSeconds': 38,
          'createdAt': now.subtract(const Duration(hours: 5)).toIso8601String(),
        }
      ],
      'approvalQueue': [
        {
          '_id': 'approval-1',
          'type': 'Doctor onboarding',
          'name': 'Dr. Hamza Salman',
          'details': 'Cardiology specialist waiting for approval and license verification',
          'status': 'pending',
          'priority': 'high',
          'submittedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          '_id': 'approval-2',
          'type': 'Laboratory partner',
          'name': 'Lahore Diagnostics',
          'details': 'Lab partner awaiting onboarding review and SLA confirmation',
          'status': 'pending',
          'priority': 'medium',
          'submittedAt': now.subtract(const Duration(hours: 18)).toIso8601String(),
        },
        {
          '_id': 'approval-3',
          'type': 'Pharmacy partner',
          'name': 'CareMed Pharmacy',
          'details': 'Pharmacy onboarding pending controlled-user approval',
          'status': 'pending',
          'priority': 'medium',
          'submittedAt': now.subtract(const Duration(hours: 10)).toIso8601String(),
        },
      ],
      'securityEvents': [
        {
          '_id': 'sec-1',
          'title': 'Two-factor sign-in enabled',
          'severity': 'info',
          'details': 'Patient portal has enabled two-factor verification in settings.',
          'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          '_id': 'sec-2',
          'title': 'New partner approval pending',
          'severity': 'medium',
          'details': 'A controlled pharmacy account is waiting for verification.',
          'createdAt': now.subtract(const Duration(hours: 8)).toIso8601String(),
        },
      ],
    };
  }

  Future<Map<String, dynamic>> getLifestyleDashboard() async {
    final db = await _loadDb();
    final user = await _currentUser();
    final role = normalizeRoleName(user['role']?.toString());
    final allEntries = _listOfMaps(db, 'lifestyleEntries');
    final userEntries = isDoctorRole(role) || isAdminRole(role) || isSuperAdminRole(role) || isSecurityRole(role)
        ? allEntries
        : allEntries.where((item) => item['userId'] == user['_id']).toList();
    final recent = List<Map<String, dynamic>>.from(userEntries)
      ..sort((a, b) => (b['createdAt']?.toString() ?? '').compareTo(a['createdAt']?.toString() ?? ''));
    final metricsTracked = recent.map((entry) => entry['metric']?.toString() ?? '').where((value) => value.isNotEmpty).toSet().length;
    return {
      'role': role,
      'entries': recent,
      'summary': {
        'metricsTracked': metricsTracked,
        'activePatients': recent.map((entry) => entry['userId']).toSet().length,
        'latestUpdate': recent.isEmpty ? null : recent.first['createdAt'],
      },
    };
  }

  Future<Map<String, dynamic>> addLifestyleEntry({
    required String metric,
    required String value,
    required String unit,
    String note = '',
  }) async {
    final db = await _loadDb();
    final user = await _currentUser();
    final entries = _listOfMaps(db, 'lifestyleEntries');
    final entry = {
      '_id': 'life-${DateTime.now().millisecondsSinceEpoch}',
      'userId': user['_id'],
      'patientName': user['name'],
      'metric': metric,
      'value': value,
      'unit': unit,
      'trend': 'updated',
      'note': note,
      'createdAt': DateTime.now().toIso8601String(),
    };
    entries.insert(0, entry);
    db['lifestyleEntries'] = entries;
    await _saveDb(db);
    return entry;
  }

  Future<Map<String, dynamic>> getGamificationDashboard() async {
    final db = await _loadDb();
    final habits = _listOfMaps(db, 'habits');
    final badges = _listOfMaps(db, 'badges');
    final totalPoints = habits.fold<int>(0, (sum, item) => sum + ((item['points'] as num?)?.toInt() ?? 0) + (((item['streak'] as num?)?.toInt() ?? 0) * 5));
    final longestStreak = habits.fold<int>(0, (best, item) {
      final streak = (item['streak'] as num?)?.toInt() ?? 0;
      return streak > best ? streak : best;
    });
    final earnedBadges = badges.where((badge) => badge['earned'] == true).length;
    return {
      'totalPoints': totalPoints,
      'longestStreak': longestStreak,
      'earnedBadges': earnedBadges,
      'habits': habits,
      'badges': badges,
    };
  }

  Future<void> completeHabit(String habitId) async {
    final db = await _loadDb();
    final habits = _listOfMaps(db, 'habits');
    final today = DateTime.now();
    for (final habit in habits) {
      if (habit['_id'] == habitId) {
        final last = DateTime.tryParse(habit['lastCompletedDate']?.toString() ?? '');
        if (last == null || last.year != today.year || last.month != today.month || last.day != today.day) {
          habit['streak'] = ((habit['streak'] as num?)?.toInt() ?? 0) + 1;
          habit['lastCompletedDate'] = today.toIso8601String();
        }
      }
    }
    final badges = _listOfMaps(db, 'badges');
    for (final badge in badges) {
      if (badge['_id'] == 'badge-2') {
        final medicationHabit = habits.firstWhere((habit) => habit['_id'] == 'habit-1', orElse: () => <String, dynamic>{});
        if (((medicationHabit['streak'] as num?)?.toInt() ?? 0) >= 7) {
          badge['earned'] = true;
        }
      }
      if (badge['_id'] == 'badge-3') {
        final entries = _listOfMaps(db, 'lifestyleEntries');
        if (entries.length >= 15) {
          badge['earned'] = true;
        }
      }
    }
    db['habits'] = habits;
    db['badges'] = badges;
    await _saveDb(db);
  }

  Future<Map<String, dynamic>> getLanguageSettings() async {
    final db = await _loadDb();
    return Map<String, dynamic>.from(db['languageSettings'] as Map? ?? <String, dynamic>{});
  }

  Future<void> updateLanguageSettings({
    required String selectedLanguage,
    required bool voiceInputEnabled,
    required bool textToSpeechEnabled,
  }) async {
    final db = await _loadDb();
    final current = Map<String, dynamic>.from(db['languageSettings'] as Map? ?? <String, dynamic>{});
    current['selectedLanguage'] = selectedLanguage;
    current['voiceInputEnabled'] = voiceInputEnabled;
    current['textToSpeechEnabled'] = textToSpeechEnabled;
    db['languageSettings'] = current;
    final events = _listOfMaps(db, 'securityEvents');
    events.insert(0, {
      '_id': 'sec-${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Language settings updated',
      'severity': 'info',
      'details': 'Language changed to $selectedLanguage. Voice input: $voiceInputEnabled, TTS: $textToSpeechEnabled.',
      'createdAt': DateTime.now().toIso8601String(),
    });
    db['securityEvents'] = events;
    await _saveDb(db);
  }

  Future<List<Map<String, dynamic>>> getVoiceNotes() async {
    final db = await _loadDb();
    final user = await _currentUser();
    final role = normalizeRoleName(user['role']?.toString());
    var notes = _listOfMaps(db, 'voiceNotes');
    if (!(isDoctorRole(role) || isAdminRole(role) || isSuperAdminRole(role) || isSecurityRole(role))) {
      notes = notes.where((item) => item['userId'] == user['_id']).toList();
    }
    notes.sort((a, b) => (b['createdAt']?.toString() ?? '').compareTo(a['createdAt']?.toString() ?? ''));
    return notes;
  }

  Future<void> addVoiceNote({
    required String title,
    required String transcript,
    required String language,
    int durationSeconds = 30,
  }) async {
    final db = await _loadDb();
    final user = await _currentUser();
    final notes = _listOfMaps(db, 'voiceNotes');
    notes.insert(0, {
      '_id': 'voice-${DateTime.now().millisecondsSinceEpoch}',
      'userId': user['_id'],
      'title': title,
      'transcript': transcript,
      'language': language,
      'durationSeconds': durationSeconds,
      'createdAt': DateTime.now().toIso8601String(),
    });
    db['voiceNotes'] = notes;
    await _saveDb(db);
  }

  Future<List<Map<String, dynamic>>> getApprovalQueue({String status = 'all'}) async {
    final db = await _loadDb();
    var items = _listOfMaps(db, 'approvalQueue');
    if (status != 'all') {
      items = items.where((item) => item['status'] == status).toList();
    }
    items.sort((a, b) => (b['submittedAt']?.toString() ?? '').compareTo(a['submittedAt']?.toString() ?? ''));
    return items;
  }

  Future<void> updateApprovalStatus(String itemId, String status) async {
    final db = await _loadDb();
    final items = _listOfMaps(db, 'approvalQueue');
    for (final item in items) {
      if (item['_id'] == itemId) {
        item['status'] = status;
        item['reviewedAt'] = DateTime.now().toIso8601String();
      }
    }
    db['approvalQueue'] = items;
    final events = _listOfMaps(db, 'securityEvents');
    events.insert(0, {
      '_id': 'sec-${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Controlled-user approval updated',
      'severity': status == 'rejected' ? 'high' : 'medium',
      'details': 'Approval queue item $itemId moved to $status.',
      'createdAt': DateTime.now().toIso8601String(),
    });
    db['securityEvents'] = events;
    await _saveDb(db);
  }

  Future<List<Map<String, dynamic>>> getSecurityEvents() async {
    final db = await _loadDb();
    final items = _listOfMaps(db, 'securityEvents');
    items.sort((a, b) => (b['createdAt']?.toString() ?? '').compareTo(a['createdAt']?.toString() ?? ''));
    return items;
  }
}

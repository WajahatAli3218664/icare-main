import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/standalone_phase3_service.dart';
import '../utils/theme.dart';
import '../widgets/back_button.dart';

class Phase3LanguageVoiceScreen extends StatefulWidget {
  const Phase3LanguageVoiceScreen({super.key});

  @override
  State<Phase3LanguageVoiceScreen> createState() => _Phase3LanguageVoiceScreenState();
}

class _Phase3LanguageVoiceScreenState extends State<Phase3LanguageVoiceScreen> {
  final StandalonePhase3Service _service = StandalonePhase3Service();
  bool _loading = true;
  Map<String, dynamic> _settings = {};
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _service.ensureSeeded();
    final settings = await _service.getLanguageSettings();
    final notes = await _service.getVoiceNotes();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _notes = notes;
      _loading = false;
    });
  }

  Future<void> _saveSettings() async {
    await _service.updateLanguageSettings(
      selectedLanguage: _settings['selectedLanguage']?.toString() ?? 'English',
      voiceInputEnabled: _settings['voiceInputEnabled'] == true,
      textToSpeechEnabled: _settings['textToSpeechEnabled'] == true,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Language and voice settings saved')));
    await _load();
  }

  Future<void> _addVoiceNote() async {
    final titleController = TextEditingController();
    final transcriptController = TextEditingController();
    final durationController = TextEditingController(text: '30');
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add voice note transcript'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: transcriptController, decoration: const InputDecoration(labelText: 'Transcript'), maxLines: 4),
              TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration in seconds'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );
    if (added == true && titleController.text.trim().isNotEmpty && transcriptController.text.trim().isNotEmpty) {
      await _service.addVoiceNote(
        title: titleController.text.trim(),
        transcript: transcriptController.text.trim(),
        language: _settings['selectedLanguage']?.toString() ?? 'English',
        durationSeconds: int.tryParse(durationController.text.trim()) ?? 30,
      );
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final supported = (_settings['supportedLanguages'] as List?)?.cast<String>() ?? <String>[];
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Language & Voice', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVoiceNote,
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.mic_none_rounded),
        label: const Text('Add Voice Note'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Accessibility & language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _settings['selectedLanguage']?.toString(),
                        decoration: const InputDecoration(labelText: 'Display language'),
                        items: supported.map((language) => DropdownMenuItem(value: language, child: Text(language))).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _settings['selectedLanguage'] = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Voice input ready'),
                        subtitle: const Text('Enable transcript-based voice note flow for patients and care teams'),
                        value: _settings['voiceInputEnabled'] == true,
                        onChanged: (value) => setState(() => _settings['voiceInputEnabled'] = value),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Text to speech ready'),
                        subtitle: const Text('Prepare the app for spoken reminders and care instructions'),
                        value: _settings['textToSpeechEnabled'] == true,
                        onChanged: (value) => setState(() => _settings['textToSpeechEnabled'] = value),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _saveSettings,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save Settings'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Voice note transcripts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                const SizedBox(height: 12),
                if (_notes.isEmpty)
                  const Text('No voice notes yet')
                else
                  ..._notes.map((note) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFFE0F2FE),
                                  child: Icon(Icons.mic_rounded, color: AppColors.primaryColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(note['title']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                      const SizedBox(height: 2),
                                      Text('${note['language'] ?? 'English'} • ${(note['durationSeconds'] ?? 0)} sec', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(note['transcript']?.toString() ?? '-', style: const TextStyle(color: Color(0xFF334155))),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.tryParse(note['createdAt']?.toString() ?? '') ?? DateTime.now()),
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                            ),
                          ],
                        ),
                      )),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:icare/services/instructor_service.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text_input.dart';

class InstructorCreateCourseScreen extends StatefulWidget {
  final Map<String, dynamic>? course;
  
  const InstructorCreateCourseScreen({super.key, this.course});

  @override
  State<InstructorCreateCourseScreen> createState() => _InstructorCreateCourseScreenState();
}

class _InstructorCreateCourseScreenState extends State<InstructorCreateCourseScreen> {
  final InstructorService _instructorService = InstructorService();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _videoTitleController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  
  String _visibility = 'public';
  List<Map<String, String>> _videos = [];
  bool _isLoading = false;
  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.course!['title'] ?? '';
      _captionController.text = widget.course!['caption'] ?? '';
      _visibility = widget.course!['visibility'] ?? 'public';
      _videos = List<Map<String, String>>.from(
        (widget.course!['videos'] as List?)?.map((v) => {
          'title': v['title']?.toString() ?? '',
          'url': v['url']?.toString() ?? '',
        }) ?? [],
      );
    }
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'title': _titleController.text,
        'caption': _captionController.text,
        'visibility': _visibility,
        'videos': _videos,
      };

      if (_isEditing) {
        await _instructorService.updateCourse(widget.course!['_id'], data);
      } else {
        await _instructorService.createCourse(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course ${_isEditing ? 'updated' : 'created'} successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addVideo() {
    if (_videoTitleController.text.isNotEmpty && _videoUrlController.text.isNotEmpty) {
      setState(() {
        _videos.add({
          'title': _videoTitleController.text,
          'url': _videoUrlController.text,
        });
        _videoTitleController.clear();
        _videoUrlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: const CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEditing ? 'Edit Course' : 'Create New Course',
          style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                controller: _titleController,
                hintText: 'Course Title',
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _captionController,
                hintText: 'Course Description',
                maxLines: 3,
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _visibility,
                decoration: const InputDecoration(
                  labelText: 'Visibility',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Public')),
                  DropdownMenuItem(value: 'students', child: Text('Students Only')),
                  DropdownMenuItem(value: 'private', child: Text('Private')),
                ],
                onChanged: (val) => setState(() => _visibility = val!),
              ),
              const SizedBox(height: 24),
              const Text(
                'Course Videos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _videoTitleController,
                hintText: 'Video Title',
              ),
              const SizedBox(height: 12),
              CustomInputField(
                controller: _videoUrlController,
                hintText: 'Video URL',
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _addVideo,
                icon: const Icon(Icons.add),
                label: const Text('Add Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ..._videos.asMap().entries.map((entry) {
                final i = entry.key;
                final video = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: Text(video['title']!),
                    subtitle: Text(video['url']!, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _videos.removeAt(i)),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              CustomButton(
                label: _isLoading ? 'Saving...' : (_isEditing ? 'Update Course' : 'Create Course'),
                onPressed: _isLoading ? null : _saveCourse,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    _videoTitleController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }
}

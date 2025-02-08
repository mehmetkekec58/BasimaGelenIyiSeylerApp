import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../data/models/experience_model.dart';
import '../../localization/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../widgets/image_picker_widget.dart';

class AddExperiencePage extends StatefulWidget {
  final Experience? experience;
  final bool isEditing;

  const AddExperiencePage({
    super.key,
    this.experience,
    this.isEditing = false,
  });

  @override
  _AddExperiencePageState createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController tagsController;
  late final TextEditingController locationController;
  final _formKey = GlobalKey<FormState>();
  
  late List<String> _tags;
  late List<XFile> _selectedImages;
  late double _significance;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if in edit mode
    titleController = TextEditingController(text: widget.experience?.title);
    descriptionController = TextEditingController(text: widget.experience?.description);
    tagsController = TextEditingController();
    locationController = TextEditingController(text: widget.experience?.location);
    
    // Initialize other fields
    _tags = widget.experience?.tags ?? [];
    _selectedImages = widget.experience?.imagePaths != null 
      ? widget.experience!.imagePaths!.map((path) => XFile(path)).toList()
      : [];
    _significance = widget.experience?.significance.toDouble() ?? 3.0;
    _selectedDate = widget.experience?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _addTag() {
    if (tagsController.text.isNotEmpty) {
      setState(() {
        _tags.add(tagsController.text.trim());
        tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  String _getSignificanceLabel(double significance) {
    final localizations = AppLocalizations.of(context);
    if (significance == 1) return localizations.get('low_importance');
    if (significance == 2) return localizations.get('medium_importance');
    if (significance == 3) return localizations.get('important');
    if (significance == 4) return localizations.get('very_important');
    return localizations.get('critical');
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.white, // Background color of the picker
              onSurface: Colors.black, // Text color of the picker
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Update the decoration for TextFormFields and TextFields
  InputDecoration _blackFocusedInputDecoration({
    required String labelText, 
    IconData? prefixIcon,
    required bool isDark,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey),
      prefixIcon: prefixIcon != null 
        ? Icon(prefixIcon, color: isDark ? Colors.grey.shade400 : Colors.grey) 
        : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDark ? Colors.white : Colors.black, width: 2),
      ),
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        title: Text(
          widget.isEditing 
            ? localizations.get('edit_experience')
            : localizations.get('add_experience'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  localizations.get('what_good_today'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ImagePickerWidget(
                  selectedImages: _selectedImages,
                  onPickImages: _pickImages,
                  onRemoveImage: _removeImage,
                  isDark: isDark,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _blackFocusedInputDecoration(
                    labelText: localizations.get('title_label'),
                    prefixIcon: Icons.title,
                    isDark: isDark,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.get('title_required_message');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: _blackFocusedInputDecoration(
                    labelText: localizations.get('description_label'),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.get('moment_importance'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Slider(
                  value: _significance,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: isDark ? Colors.white : Colors.black,
                  inactiveColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  onChanged: (value) {
                    setState(() {
                      _significance = value;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getSignificanceLabel(_significance),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tagsController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        decoration: _blackFocusedInputDecoration(
                          labelText: localizations.get('add_tag_label'),
                          prefixIcon: Icons.tag,
                          isDark: isDark,
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle, 
                        color: isDark ? Colors.grey.shade400 : Colors.grey,
                      ),
                      onPressed: _addTag,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _tags.map((tag) => Chip(
                    label: Text(
                      tag, 
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.black,
                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white),
                    onDeleted: () => _removeTag(tag),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: locationController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _blackFocusedInputDecoration(
                    labelText: localizations.get('location_label'),
                    prefixIcon: Icons.location_on,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15),
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today, 
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          localizations.get('date_format')
                            .replaceAll('{day}', _selectedDate.day.toString())
                            .replaceAll('{month}', _selectedDate.month.toString())
                            .replaceAll('{year}', _selectedDate.year.toString()),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final experience = Experience(
                        id: widget.isEditing ? widget.experience!.id : null,
                        title: titleController.text,
                        description: descriptionController.text.isNotEmpty 
                          ? descriptionController.text 
                          : null,
                        tags: _tags,
                        imagePaths: _selectedImages.isNotEmpty 
                          ? _selectedImages.map((image) => image.path).toList() 
                          : null,
                        location: locationController.text.isNotEmpty 
                          ? locationController.text 
                          : null,
                        significance: _significance.round(),
                        date: _selectedDate,
                      );
                      Navigator.of(context).pop(experience);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    widget.isEditing 
                      ? localizations.get('update')
                      : localizations.get('save'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
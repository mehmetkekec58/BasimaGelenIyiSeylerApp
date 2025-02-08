import 'package:intl/intl.dart';

class Experience {
  final String title;
  final String description;
  final String? imagePath;
  final String? location;
  final List<String> tags;
  final DateTime date;

  Experience({
    required this.title,
    required this.description,
    this.imagePath,
    this.location,
    required this.tags,
    required this.date,
  });

  String get formattedDate => DateFormat('dd.MM.yyyy').format(date);

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String?,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'location': location,
      'tags': tags,
      'date': date.toIso8601String(),
    };
  }
} 
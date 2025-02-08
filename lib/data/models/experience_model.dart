class Experience {
  final String id;
  final String title;
  final String? description;
  final List<String> tags;
  final List<String>? imagePaths;
  final String? location;
  final int significance;
  final DateTime date;

  Experience({
    String? id,
    required this.title,
    this.description,
    List<String>? tags,
    this.imagePaths,
    this.location,
    required this.significance,
    DateTime? date,
  }) : 
    id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    date = date ?? DateTime.now(),
    tags = tags ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'tags': tags,
    'imagePaths': imagePaths,
    'location': location,
    'significance': significance,
    'date': date.toIso8601String(),
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    tags: json['tags'] != null 
      ? List<String>.from(json['tags']) 
      : [],
    imagePaths: json['imagePaths'] != null 
      ? List<String>.from(json['imagePaths']) 
      : null,
    location: json['location'],
    significance: json['significance'] ?? 5,
    date: json['date'] != null 
      ? DateTime.parse(json['date']) 
      : DateTime.now(),
  );
} 
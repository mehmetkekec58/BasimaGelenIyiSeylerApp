class BackupPlanFeature {
  final String name;
  final bool isIncluded;

  BackupPlanFeature({
    required this.name,
    required this.isIncluded,
  });

  factory BackupPlanFeature.fromJson(Map<String, dynamic> json) {
    return BackupPlanFeature(
      name: json['name'] as String,
      isIncluded: json['isIncluded'] as bool,
    );
  }
}

class BackupPlan {
  final String id;
  final String name;
  final String description;
  final List<BackupPlanFeature> features;
  final String price;
  final bool isCurrentPlan;
  final bool isDisabled;

  BackupPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
    required this.price,
    this.isCurrentPlan = false,
    this.isDisabled = false,
  });

  factory BackupPlan.fromJson(Map<String, dynamic> json) {
    return BackupPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => BackupPlanFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as String,
      isCurrentPlan: json['isCurrentPlan'] as bool? ?? false,
      isDisabled: json['isDisabled'] as bool? ?? false,
    );
  }
} 
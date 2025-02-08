import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String id;
  final String title;
  final String description;
  final int maxExperiences;
  final int maxImages;
  final double price;
  final String currency;
  final String interval;
  final bool isPopular;
  final double? savePercent;
  final Color accentColor;
  final bool isDisabled;

  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.maxExperiences,
    required this.maxImages,
    required this.price,
    required this.currency,
    required this.interval,
    required this.accentColor,
    this.isPopular = false,
    this.savePercent,
    this.isDisabled = false,
  });

  String get formattedPrice => '$currency${price.toStringAsFixed(2)}/$interval';
  String get formattedExperiences => maxExperiences == -1 ? 'Unlimited experiences' : '$maxExperiences experiences';
  String get formattedImages => maxImages == -1 ? 'Unlimited images' : '$maxImages images';
  String formattedSaveText(String languageCode) => savePercent == null ? '' : '${savePercent!.toStringAsFixed(0)}% ${languageCode == 'tr' ? 'tasarruf' : 'save'}';
} 
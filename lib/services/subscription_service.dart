import 'package:flutter/material.dart';
import '../models/subscription_plan.dart';

class SubscriptionService {
  Future<List<SubscriptionPlan>> getPlans(String languageCode) async {
    // API çağrısını simüle etmek için 1 saniye bekliyoruz
    await Future.delayed(const Duration(seconds: 1));

    final currency = languageCode == 'tr' ? '₺' : '\$';
    final priceMultiplier = languageCode == 'tr' ? 1.0 : 1/15;

    return [
      SubscriptionPlan(
        id: 'monthly',
        title: languageCode == 'tr' ? 'Aylık Plan' : 'Monthly Plan',
        description: languageCode == 'tr' ? 'Sınırsız yedekleme' : 'Unlimited backup',
        maxExperiences: 200, // -1 sınırsız anlamına geliyor
        maxImages: 35,
        price: double.parse((29.99 * priceMultiplier).toStringAsFixed(2)),
        currency: currency,
        interval: languageCode == 'tr' ? 'ay' : 'month',
        accentColor: Color(0xFF2196F3), // Material Blue
        isDisabled: true,
      ),
      SubscriptionPlan(
        id: 'yearly',
        title: languageCode == 'tr' ? 'Yıllık Plan' : 'Yearly Plan',
        description: languageCode == 'tr' ? 'En iyi değer' : 'Best value',
        maxExperiences: -1,
        maxImages: 1000,
        price: double.parse((399.99 * priceMultiplier).toStringAsFixed(2)),
        currency: currency,
        interval: languageCode == 'tr' ? 'yıl' : 'year',
        isPopular: true,
        savePercent: 17,
        accentColor: Color(0xFF9C27B0), // Material Purple
        isDisabled: true,
      ),
    ];
  }

  Future<SubscriptionPlan?> getCurrentPlan() async {
    // API çağrısını simüle etmek için 1 saniye bekliyoruz
    await Future.delayed(const Duration(seconds: 1));
    
    // Şu an için sabit olarak monthly planı döndürüyoruz
    return null; // Aktif plan yok
  }
} 
import 'package:flutter/material.dart';

class PriceProvider extends ChangeNotifier {
  final Map<String, double> _prices = {
    'monthly': 29.99,
    'yearly': 299.99,
  };

  final Map<String, String> _currencies = {
    'tr': '₺',
    'en': '\$',
  };

  double getPrice(String plan) => _prices[plan] ?? 0.0;
  
  String getCurrency(String languageCode) => _currencies[languageCode] ?? '₺';

  String getFormattedPrice(String plan, String languageCode) {
    final price = _prices[plan] ?? 0.0;
    final currency = _currencies[languageCode] ?? '₺';
    final suffix = plan == 'monthly' ? '/ay' : '/yıl';
    final localizedSuffix = languageCode == 'en' ? (plan == 'monthly' ? '/month' : '/year') : suffix;
    
    if (languageCode == 'en') {
      return '$currency${(price / 15).toStringAsFixed(2)}$localizedSuffix';  // TL'den USD'ye çevirme (yaklaşık kur)
    }
    return '$price$currency$localizedSuffix';
  }

  double getDiscount() {
    final monthlyYearTotal = _prices['monthly']! * 12;
    final yearlyPrice = _prices['yearly']!;
    return ((monthlyYearTotal - yearlyPrice) / monthlyYearTotal * 100).round().toDouble();
  }
} 
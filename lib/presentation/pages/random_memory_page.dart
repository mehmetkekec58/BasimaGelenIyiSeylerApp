import 'package:flutter/material.dart';
import '../../data/repositories/experience_repository.dart';
import '../../data/models/experience_model.dart';
import 'experience_detail_page.dart';
import '../../localization/app_localizations.dart';

enum MemoryPeriod {
  lastMonth,
  lastYear,
  lastFiveYears,
}

class RandomMemoryPage extends StatefulWidget {
  final MemoryPeriod period;

  const RandomMemoryPage({
    super.key,
    required this.period,
  });

  @override
  State<RandomMemoryPage> createState() => _RandomMemoryPageState();
}

class _RandomMemoryPageState extends State<RandomMemoryPage> {
  final ExperienceRepository _repository = ExperienceRepository();
  bool _isLoading = false;

  String get _periodTitle {
    final localizations = AppLocalizations.of(context);
    switch (widget.period) {
      case MemoryPeriod.lastMonth:
        return localizations.get('last_month');
      case MemoryPeriod.lastYear:
        return localizations.get('last_year');
      case MemoryPeriod.lastFiveYears:
        return localizations.get('last_five_years');
    }
  }

  String get _periodDescription {
    final localizations = AppLocalizations.of(context);
    switch (widget.period) {
      case MemoryPeriod.lastMonth:
      case MemoryPeriod.lastYear:
      case MemoryPeriod.lastFiveYears:
        return localizations.get('suggest_random_memory').replaceAll('{period}', _periodTitle.toLowerCase());
    }
  }

  DateTime get _startDate {
    switch (widget.period) {
      case MemoryPeriod.lastMonth:
        return DateTime.now().subtract(const Duration(days: 30));
      case MemoryPeriod.lastYear:
        return DateTime.now().subtract(const Duration(days: 365));
      case MemoryPeriod.lastFiveYears:
        return DateTime.now().subtract(const Duration(days: 1825)); // 5 * 365
    }
  }

  Future<void> _suggestRandomExperience() async {
    setState(() {
      _isLoading = true;
    });

    // Get all experiences from the selected period
    final allExperiences = await _repository.getExperiences();
    final periodExperiences = allExperiences.where((exp) => 
      exp.date.isAfter(_startDate) || exp.date.isAtSameMomentAs(_startDate)
    ).toList();

    setState(() {
      _isLoading = false;
    });

    if (periodExperiences.isEmpty) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.get('no_experiences_in_period').replaceAll('{period}', _periodTitle.toLowerCase()),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Select a random experience
    periodExperiences.shuffle();
    final randomExperience = periodExperiences.first;

    if (mounted) {
      // Navigate to the detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExperienceDetailPage(experience: randomExperience),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        title: Text(
          _periodTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _periodDescription,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _suggestRandomExperience,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: isDark ? Colors.black : Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    localizations.get('suggest_random'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 
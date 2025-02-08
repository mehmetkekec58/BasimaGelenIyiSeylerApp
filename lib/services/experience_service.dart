import 'package:shared_preferences/shared_preferences.dart';
import '../models/experience.dart';
import 'dart:convert';

class ExperienceService {
  static const String _experiencesKey = 'experiences';

  Future<List<Experience>> getExperiences() async {
    final prefs = await SharedPreferences.getInstance();
    final experiencesJson = prefs.getStringList(_experiencesKey) ?? [];

    return experiencesJson
        .map((json) => Experience.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveExperience(Experience experience) async {
    final prefs = await SharedPreferences.getInstance();
    final experiencesJson = prefs.getStringList(_experiencesKey) ?? [];
    
    experiencesJson.add(jsonEncode(experience.toJson()));
    await prefs.setStringList(_experiencesKey, experiencesJson);
  }

  Future<void> deleteExperience(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final experiencesJson = prefs.getStringList(_experiencesKey) ?? [];
    
    if (index >= 0 && index < experiencesJson.length) {
      experiencesJson.removeAt(index);
      await prefs.setStringList(_experiencesKey, experiencesJson);
    }
  }
} 
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/experience_model.dart';

class LocalStorageService {
  static const String _experiencesKey = 'experiences';

  static Future<List<Experience>> loadExperiences() async {
    final prefs = await SharedPreferences.getInstance();
    final experiencesJson = prefs.getStringList(_experiencesKey) ?? [];
    return experiencesJson
        .map((json) => Experience.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveExperiences(List<Experience> experiences) async {
    final prefs = await SharedPreferences.getInstance();
    final experiencesJson = experiences
        .map((exp) => jsonEncode(exp.toJson()))
        .toList();
    await prefs.setStringList(_experiencesKey, experiencesJson);
  }
} 
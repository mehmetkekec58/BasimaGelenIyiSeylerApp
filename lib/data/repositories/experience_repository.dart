import '../../services/local_storage_service.dart';
import '../models/experience_model.dart';

class ExperienceRepository {
  Future<List<Experience>> getExperiences() async {
    return await LocalStorageService.loadExperiences();
  }

  Future<void> addExperience(Experience experience) async {
    final experiences = await getExperiences();
    experiences.insert(0, experience);
    await LocalStorageService.saveExperiences(experiences);
  }

  Future<void> updateExperience(Experience updatedExperience) async {
    final experiences = await getExperiences();
    final index = experiences.indexWhere((exp) => exp.id == updatedExperience.id);
    
    if (index != -1) {
      experiences[index] = updatedExperience;
      await LocalStorageService.saveExperiences(experiences);
    }
  }

  Future<void> deleteExperience(int index) async {
    final experiences = await getExperiences();
    if (index >= 0 && index < experiences.length) {
      experiences.removeAt(index);
    await LocalStorageService.saveExperiences(experiences);
    }
  }
} 
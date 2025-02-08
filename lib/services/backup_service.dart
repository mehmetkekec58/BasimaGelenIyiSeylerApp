import 'package:flutter/material.dart';
import '../data/models/backup_plan_model.dart';

class BackupService {
  Future<List<BackupPlan>> getBackupPlans() async {
    return [
      BackupPlan(
        id: 'monthly',
        name: 'Monthly Plan',
        description: 'Best',
        features: [
          BackupPlanFeature(name: '700 Experiences', isIncluded: true),
          BackupPlanFeature(name: '100 Images', isIncluded: true),
          BackupPlanFeature(name: 'Auto Backup', isIncluded: false),
          BackupPlanFeature(name: 'Encrypted storage', isIncluded: false),
        ],
        price: '2.99\$/Month',
        isCurrentPlan: false,
        isDisabled: true,
      ),
      BackupPlan(
        id: 'yearly',
        name: 'Yearly Plan',
        description: 'Best',
        features: [
          BackupPlanFeature(name: '1500 experiences', isIncluded: true),
          BackupPlanFeature(name: '500 images', isIncluded: true),
          BackupPlanFeature(name: 'Auto backup', isIncluded: true),
          BackupPlanFeature(name: 'Encrypted storage', isIncluded: true),
        ],
        price: '32.99\$/Year',
        isCurrentPlan: false,
        isDisabled: true,
      ),
    ];
  }
} 
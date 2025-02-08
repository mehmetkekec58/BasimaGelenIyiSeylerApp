import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/backup_plan_model.dart';
import '../../services/backup_service.dart';
import '../../localization/app_localizations.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final BackupService _backupService = BackupService();
  List<BackupPlan> _plans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
    });

    final plans = await _backupService.getBackupPlans();
    
    setState(() {
      _plans = plans;
      _isLoading = false;
    });
  }

  Widget _buildFeatureItem(BuildContext context, BackupPlanFeature feature, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            feature.isIncluded ? Icons.check_circle : Icons.cancel,
            color: feature.isIncluded 
              ? (isDark ? Colors.green.shade400 : Colors.green)
              : (isDark ? Colors.red.shade400 : Colors.red),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature.name,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, BackupPlan plan, bool isDark) {
    return Opacity(
      opacity: plan.isDisabled ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        color: isDark ? Colors.grey.shade900 : Colors.white,
        child: Stack(
          children: [
            if (plan.isDisabled)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context).get('coming_soon_label'),
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...plan.features.map((feature) => _buildFeatureItem(context, feature, isDark)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        plan.price,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: plan.isDisabled ? null : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          plan.isCurrentPlan 
                            ? AppLocalizations.of(context).get('current_plan')
                            : AppLocalizations.of(context).get('select_plan'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          localizations.get('backup_page_title'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _plans.isEmpty
          ? Center(
              child: Text(
                localizations.get('coming_soon_label'),
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: _plans.map((plan) => _buildPlanCard(context, plan, isDark)).toList(),
            ),
    );
  }
} 
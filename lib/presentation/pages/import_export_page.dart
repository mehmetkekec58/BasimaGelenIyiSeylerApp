import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/pdf_service.dart';
import '../../models/experience.dart';
import '../../services/experience_service.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  Future<void> _exportToPdf(BuildContext context) async {
    final localizations = AppLocalizations.of(context, listen: false);
    final pdfService = PdfService();
    final experienceService = ExperienceService();

    try {
      // Tüm deneyimleri getir
      final experiences = await experienceService.getExperiences();

      await pdfService.exportExperiences(
        title: localizations.get('app_name'),
        experiences: experiences,
        languageCode: localizations.languageCode,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.languageCode == 'tr' 
                ? 'PDF dışa aktarılırken bir hata oluştu' 
                : 'An error occurred while exporting PDF'
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildExportCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    required VoidCallback onTap,
    required String comingSoonMessage,
    bool isDisabled = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      color: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: isDisabled ? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(comingSoonMessage),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.black,
            ),
          );
        } : onTap,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          localizations.get('import_export_title'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.get('import_export_description'),
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildExportCard(
                context: context,
                icon: Icons.picture_as_pdf,
                title: localizations.get('export_pdf'),
                description: localizations.get('export_pdf_description'),
                iconColor: Colors.red.shade400,
                onTap: () {},
                comingSoonMessage: localizations.get('coming_soon_pdf'),
                isDisabled: true,
              ),
              const SizedBox(height: 16),
              _buildExportCard(
                context: context,
                icon: Icons.table_chart,
                title: localizations.get('export_excel'),
                description: localizations.get('export_excel_description'),
                iconColor: Colors.green.shade600,
                onTap: () {},
                comingSoonMessage: localizations.get('coming_soon_excel'),
                isDisabled: true,
              ),
              const SizedBox(height: 16),
              _buildExportCard(
                context: context,
                icon: Icons.backup,
                title: localizations.get('backup'),
                description: localizations.get('backup_experiences'),
                iconColor: Colors.purple.shade400,
                onTap: () {},
                comingSoonMessage: localizations.get('coming_soon'),
                isDisabled: true,
              ),
              const SizedBox(height: 16),
              _buildExportCard(
                context: context,
                icon: Icons.restore,
                title: localizations.get('import_experiences'),
                description: localizations.get('import_experiences_description'),
                iconColor: Colors.blue.shade400,
                onTap: () {},
                comingSoonMessage: localizations.get('coming_soon_restore'),
                isDisabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../localization/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  Widget _buildLanguageOption(BuildContext context, String languageCode, String flag, String name, bool isDark, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? (isDark ? Colors.white38 : Colors.black38) : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
          languageProvider.setLanguage(languageCode);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: isDark ? Colors.green.shade200 : Colors.green.shade400,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          l10n.get('settings'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: ListView(
        children: [
          // Dark Mode Switch
          ListTile(
            leading: Icon(
              Icons.dark_mode,
              color: isDark ? Colors.purple.shade200 : Colors.purple.shade400,
            ),
            title: Text(
              l10n.get('dark_mode'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          Divider(color: isDark ? Colors.white24 : Colors.black12),

          // Notifications Switch
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.orange.shade200 : Colors.orange.shade400,
            ),
            title: Text(
              l10n.get('notifications'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              l10n.get('enable_daily_reminders'),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          Divider(color: isDark ? Colors.white24 : Colors.black12),

          // Language Selection
          ListTile(
            leading: Icon(
              Icons.language,
              color: isDark ? Colors.blue.shade200 : Colors.blue.shade400,
            ),
            title: Text(
              l10n.get('language'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildLanguageOption(
                  context,
                  'tr',
                  '🇹🇷',
                  'Türkçe',
                  isDark,
                  languageProvider.currentLanguage == 'tr',
                ),
                _buildLanguageOption(
                  context,
                  'en',
                  '🇬🇧',
                  'English',
                  isDark,
                  languageProvider.currentLanguage == 'en',
                ),
              ],
            ),
          ),
          Divider(color: isDark ? Colors.white24 : Colors.black12),

          // About Section
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: isDark ? Colors.green.shade200 : Colors.green.shade400,
            ),
            title: Text(
              l10n.get('about_app'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              l10n.get('version'),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.get('app_name'),
                applicationVersion: '1.0.0',
                applicationIcon: Icon(
                  Icons.sentiment_satisfied_alt,
                  size: 50,
                  color: isDark ? Colors.green.shade200 : Colors.green.shade400,
                ),
                children: [
                  Text(l10n.get('app_description')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
} 
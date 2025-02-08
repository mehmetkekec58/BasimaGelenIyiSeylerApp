import 'package:flutter/material.dart';
import 'random_memory_page.dart';
import '../../localization/app_localizations.dart';

class RememberMePage extends StatefulWidget {
  const RememberMePage({super.key});

  @override
  State<RememberMePage> createState() => _RememberMePageState();
}

class _RememberMePageState extends State<RememberMePage> {
  Widget _buildMemoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: _getIconColor(title),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                flex: 2,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(String title) {
    final localizations = AppLocalizations.of(context, listen: false);
    if (title == localizations.get('last_month')) {
      return Colors.green.shade400;
    } else if (title == localizations.get('last_year')) {
      return Colors.blue.shade400;
    } else if (title == localizations.get('last_five_years')) {
      return Colors.purple.shade400;
    } else if (title == localizations.get('filtered_suggestions')) {
      return Colors.orange.shade400;
    }
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          localizations.get('remember_me'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildMemoryCard(
              icon: Icons.calendar_month,
              title: localizations.get('last_month'),
              subtitle: localizations.get('last_month_description'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RandomMemoryPage(period: MemoryPeriod.lastMonth),
                ),
              ),
            ),
            _buildMemoryCard(
              icon: Icons.calendar_today,
              title: localizations.get('last_year'),
              subtitle: localizations.get('last_year_description'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RandomMemoryPage(period: MemoryPeriod.lastYear),
                ),
              ),
            ),
            _buildMemoryCard(
              icon: Icons.history,
              title: localizations.get('last_five_years'),
              subtitle: localizations.get('last_five_years_description'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RandomMemoryPage(period: MemoryPeriod.lastFiveYears),
                ),
              ),
            ),
            _buildMemoryCard(
              icon: Icons.filter_list,
              title: localizations.get('filtered_suggestions'),
              subtitle: localizations.get('filtered_suggestions_description'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.get('coming_soon'))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 
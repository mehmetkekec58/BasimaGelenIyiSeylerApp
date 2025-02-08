import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experience_list_page.dart';
import 'add_experience_page.dart';
import 'remember_me_page.dart';
import 'settings_page.dart';
import 'import_export_page.dart';
import 'backup_page.dart';
import '../../data/repositories/experience_repository.dart';
import '../../data/models/experience_model.dart';
import '../../localization/app_localizations.dart';
import '../../providers/theme_provider.dart';

class RandomExperiencesPage extends StatefulWidget {
  const RandomExperiencesPage({super.key});

  @override
  _RandomExperiencesPageState createState() => _RandomExperiencesPageState();
}

class _RandomExperiencesPageState extends State<RandomExperiencesPage> {
  final ExperienceRepository _repository = ExperienceRepository();
  List<Experience> _randomExperiences = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomExperiences();
  }

  Future<void> _fetchRandomExperiences() async {
    setState(() {
      _isLoading = true;
    });

    final allExperiences = await _repository.getExperiences();
    
    // Shuffle and take up to 5 random experiences
    allExperiences.shuffle();
    final randomExperiences = allExperiences.take(5).toList();

    setState(() {
      _randomExperiences = randomExperiences;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hatırla Beni',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRandomExperiences,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : _randomExperiences.isEmpty
              ? Center(
                  child: Text(
                    'Henüz hiç deneyim eklemediniz.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _randomExperiences.length,
                  itemBuilder: (context, index) {
                    final experience = _randomExperiences[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          experience.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${experience.date.day}.${experience.date.month}.${experience.date.year}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.memory,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class MoreMenuPage extends StatelessWidget {
  const MoreMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          localizations.get('more'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.import_export, color: Colors.red.shade400),
            title: Text(
              localizations.get('import_export'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              localizations.get('import_export_data'),
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImportExportPage()),
            ),
          ),
          Divider(color: isDark ? Colors.white24 : Colors.black12),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: Colors.grey.shade600),
            title: Text(
              localizations.get('settings'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              localizations.get('customize_app'),
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ExperienceListPage(showBackButton: false),
    const RememberMePage(),
    const BackupPage(),
    const MoreMenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        indicatorColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list),
            label: localizations.get('experiences'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.memory),
            label: localizations.get('remember_me'),
          ),
          NavigationDestination(
            icon: Icon(Icons.backup_outlined),
            label: localizations.get('backup'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz),
            label: localizations.get('more'),
          ),
        ],
      ),
    );
  }
} 
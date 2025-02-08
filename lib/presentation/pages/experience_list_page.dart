import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../data/models/experience_model.dart';
import '../../data/repositories/experience_repository.dart';
import '../../localization/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../widgets/experience_filter_bar.dart';
import '../widgets/experience_card.dart';
import 'add_experience_page.dart';
import 'experience_detail_page.dart';

class ExperienceListPage extends StatefulWidget {
  final bool showBackButton;
  
  const ExperienceListPage({
    super.key,
    this.showBackButton = false,
  });

  @override
  _ExperienceListPageState createState() => _ExperienceListPageState();
}

class _ExperienceListPageState extends State<ExperienceListPage> {
  final ExperienceRepository _repository = ExperienceRepository();
  List<Experience> _experiences = [];
  List<Experience> _filteredExperiences = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  int? _selectedSignificance;
  DateTimeRange? _selectedDateRange;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  static const int _itemsPerPage = 10;
  bool _hasMoreItems = true;
  bool _isFilterVisible = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreItems) {
      _loadMoreExperiences();
    }

    final currentScrollPosition = _scrollController.position.pixels;
    if (currentScrollPosition > _lastScrollPosition && currentScrollPosition > 100 && _isFilterVisible) {
      setState(() {
        _isFilterVisible = false;
      });
    } else if (currentScrollPosition < _lastScrollPosition && !_isFilterVisible) {
      setState(() {
        _isFilterVisible = true;
      });
    }
    _lastScrollPosition = currentScrollPosition;
  }

  Future<void> _loadMoreExperiences() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final startIndex = (_currentPage + 1) * _itemsPerPage;
    if (startIndex >= _experiences.length) {
      setState(() {
        _hasMoreItems = false;
        _isLoadingMore = false;
      });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500)); // Add a small delay for better UX

    final endIndex = (startIndex + _itemsPerPage <= _experiences.length)
        ? startIndex + _itemsPerPage
        : _experiences.length;

    setState(() {
      _currentPage++;
      _filteredExperiences.addAll(_experiences.getRange(startIndex, endIndex));
      _isLoadingMore = false;
    });
  }

  Future<void> _loadExperiences() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _hasMoreItems = true;
    });

    final experiences = await _repository.getExperiences();
    setState(() {
      _experiences = experiences;
      _filterExperiences(_searchController.text); // Apply any existing filters
      _isLoading = false;
    });
  }

  void _filterExperiences(String query) {
    setState(() {
      _currentPage = 0;
      final lowercaseQuery = query.toLowerCase();
      final filteredList = _experiences.where((experience) {
        // Text search
        final titleMatch = experience.title.toLowerCase().contains(lowercaseQuery);
        final descriptionMatch = experience.description?.toLowerCase().contains(lowercaseQuery) ?? false;
        final locationMatch = experience.location?.toLowerCase().contains(lowercaseQuery) ?? false;
        final tagsMatch = experience.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
        final textMatch = titleMatch || descriptionMatch || locationMatch || tagsMatch;

        // Significance filter
        final significanceMatch = _selectedSignificance == null || experience.significance == _selectedSignificance;

        // Date range filter
        bool dateMatch = true;
        if (_selectedDateRange != null) {
          final startDate = DateTime(
            _selectedDateRange!.start.year,
            _selectedDateRange!.start.month,
            _selectedDateRange!.start.day,
          );
          final endDate = DateTime(
            _selectedDateRange!.end.year,
            _selectedDateRange!.end.month,
            _selectedDateRange!.end.day,
          );
          final experienceDate = DateTime(
            experience.date.year,
            experience.date.month,
            experience.date.day,
          );
          dateMatch = experienceDate.isAtSameMomentAs(startDate) ||
                     experienceDate.isAtSameMomentAs(endDate) ||
                     (experienceDate.isAfter(startDate) && experienceDate.isBefore(endDate));
        }

        return textMatch && significanceMatch && dateMatch;
      }).toList();

      _filteredExperiences = filteredList.take(_itemsPerPage).toList();
      _hasMoreItems = filteredList.length > _itemsPerPage;
    });
  }

  Future<void> _addExperience(Experience experience) async {
    setState(() {
      _isLoading = true;
    });
    await _repository.addExperience(experience);
    await _loadExperiences();
  }

  Future<void> _updateExperience(Experience experience) async {
    setState(() {
      _isLoading = true;
    });
    await _repository.updateExperience(experience);
    await _loadExperiences();
  }

  Future<void> _deleteExperience(int index) async {
    await _repository.deleteExperience(index);
    await _loadExperiences();
  }

  Future<bool> _showDeleteConfirmationDialog(int index) async {
    // Get localizations outside of the dialog builder
    final localizations = AppLocalizations.of(context, listen: false);
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            localizations.get('delete_experience'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            localizations.get('delete_experience_confirm'),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                localizations.get('cancel'),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                localizations.get('delete'),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
              ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (result == true) {
      await _deleteExperience(index);
      return true;
    }
    return false;
  }

  void _navigateToAddExperiencePage() async {
    final newExperience = await Navigator.push<Experience>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExperiencePage(),
      ),
    );

    if (newExperience != null) {
      await _addExperience(newExperience);
    }
  }

  Widget _buildEmptyState() {
    final localizations = AppLocalizations.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_satisfied_alt,
            size: 100,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            localizations.get('no_experiences_yet'),
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            localizations.get('add_something_good_today'),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getSignificanceLabel(int significance) {
    final localizations = AppLocalizations.of(context);
    if (significance == 1) return localizations.get('low_importance');
    if (significance == 2) return localizations.get('medium_importance');
    if (significance == 3) return localizations.get('important');
    if (significance == 4) return localizations.get('very_important');
    return localizations.get('critical');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        leading: widget.showBackButton ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ) : null,
        title: Text(
          localizations.get('app_name'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
                onPressed: _navigateToAddExperiencePage,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isFilterVisible ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isFilterVisible ? 1.0 : 0.0,
              child: ExperienceFilterBar(
                searchController: _searchController,
                selectedSignificance: _selectedSignificance,
                selectedDateRange: _selectedDateRange,
                onSearchChanged: _filterExperiences,
                onSignificanceChanged: (value) {
                  setState(() {
                    _selectedSignificance = value;
                    _filterExperiences(_searchController.text);
                  });
                },
                onSelectDateRange: _selectDateRange,
                onClearDateRange: () {
                  setState(() {
                    _selectedDateRange = null;
                    _filterExperiences(_searchController.text);
                  });
                },
                getSignificanceLabel: _getSignificanceLabel,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                )
              : _filteredExperiences.isEmpty 
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredExperiences.length + (_hasMoreItems ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _filteredExperiences.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      }
                      return ExperienceCard(
                        experience: _filteredExperiences[index],
                        onTap: () async {
                          final updatedExperience = await Navigator.push<Experience>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExperienceDetailPage(
                                experience: _filteredExperiences[index],
                              ),
                            ),
                          );

                          if (updatedExperience != null) {
                            await _updateExperience(updatedExperience);
                          }
                        },
                        onDismiss: (direction) async {
                          return await _showDeleteConfirmationDialog(index);
                        },
                        isDark: isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark 
              ? const ColorScheme.dark(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  surface: Color(0xFF202020),
                  onSurface: Colors.white,
                )
              : const ColorScheme.light(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
            dialogBackgroundColor: isDark ? const Color(0xFF202020) : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filterExperiences(_searchController.text);
      });
    }
  }
} 
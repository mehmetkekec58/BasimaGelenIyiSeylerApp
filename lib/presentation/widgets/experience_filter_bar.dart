import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/app_localizations.dart';
import '../../providers/theme_provider.dart';

class ExperienceFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final int? selectedSignificance;
  final DateTimeRange? selectedDateRange;
  final Function(String) onSearchChanged;
  final Function(int?) onSignificanceChanged;
  final Function() onSelectDateRange;
  final Function() onClearDateRange;
  final String Function(int) getSignificanceLabel;

  const ExperienceFilterBar({
    super.key,
    required this.searchController,
    required this.selectedSignificance,
    required this.selectedDateRange,
    required this.onSearchChanged,
    required this.onSignificanceChanged,
    required this.onSelectDateRange,
    required this.onClearDateRange,
    required this.getSignificanceLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: localizations.get('search_title_desc_tag_location'),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                  )
                : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: isDark ? Colors.white : Colors.black,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey.shade900 : Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    ),
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedSignificance,
                      icon: Icon(
                        Icons.star_outline,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      hint: Text(
                        localizations.get('importance_level'),
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                      dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            localizations.get('all_importance_levels'),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        ...List.generate(5, (index) {
                          final value = index + 1;
                          return DropdownMenuItem(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    getSignificanceLabel(value),
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      onChanged: onSignificanceChanged,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: onSelectDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      ),
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedDateRange != null
                              ? '${selectedDateRange!.start.day}.${selectedDateRange!.start.month}.${selectedDateRange!.start.year} - '
                                '${selectedDateRange!.end.day}.${selectedDateRange!.end.month}.${selectedDateRange!.end.year}'
                              : localizations.get('date_range'),
                            style: TextStyle(
                              color: selectedDateRange != null 
                                ? (isDark ? Colors.white : Colors.black)
                                : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (selectedDateRange != null)
                          GestureDetector(
                            onTap: onClearDateRange,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
} 
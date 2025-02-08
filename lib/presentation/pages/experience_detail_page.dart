import 'package:flutter/material.dart';
import '../../data/models/experience_model.dart';
import '../../localization/app_localizations.dart';
import '../widgets/image_viewer_widget.dart';
import 'add_experience_page.dart';

class ExperienceDetailPage extends StatefulWidget {
  final Experience experience;

  const ExperienceDetailPage({
    Key? key,
    required this.experience,
  }) : super(key: key);

  @override
  State<ExperienceDetailPage> createState() => _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends State<ExperienceDetailPage> {
  int _currentPage = 0;

  String _getSignificanceLabel(int significance) {
    final localizations = AppLocalizations.of(context, listen: false);
    if (significance == 1) return localizations.get('low_importance');
    if (significance == 2) return localizations.get('medium_importance');
    if (significance == 3) return localizations.get('important');
    if (significance == 4) return localizations.get('very_important');
    return localizations.get('critical');
  }

  String _getMonthName(int month) {
    final localizations = AppLocalizations.of(context, listen: false);
    final monthKey = 'month_$month';
    return localizations.get(monthKey);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: widget.experience.imagePaths != null && widget.experience.imagePaths!.isNotEmpty 
              ? MediaQuery.of(context).size.height * 0.6 
              : 0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: isDark ? Colors.black : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: widget.experience.imagePaths != null && widget.experience.imagePaths!.isNotEmpty
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    localizations.get('update'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final updatedExperience = await Navigator.push<Experience>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExperiencePage(
                          experience: widget.experience,
                          isEditing: true,
                        ),
                      ),
                    );

                    if (updatedExperience != null) {
                      Navigator.pop(context, updatedExperience);
                    }
                  },
                ),
              ),
            ],
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.experience.imagePaths != null && widget.experience.imagePaths!.isNotEmpty
                ? ImageViewerWidget(
                    imagePaths: widget.experience.imagePaths!,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    currentPage: _currentPage,
                  )
                : null,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  top: widget.experience.imagePaths != null && widget.experience.imagePaths!.isNotEmpty ? 24 : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.experience.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.experience.date.day} ${_getMonthName(widget.experience.date.month)} ${widget.experience.date.year}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.experience.description != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.experience.description!,
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getSignificanceLabel(widget.experience.significance),
                                style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.experience.tags.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        localizations.get('tags'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.experience.tags.asMap().entries.map((entry) {
                          final colors = [
                            Colors.blue,
                            Colors.green,
                            Colors.purple,
                            Colors.orange,
                            Colors.teal,
                            Colors.pink,
                          ];
                          final color = colors[entry.key % colors.length];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? color.shade800.withOpacity(0.2) : color.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tag,
                                  size: 16,
                                  color: isDark ? color.shade200 : color.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? color.shade200 : color.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (widget.experience.location != null && widget.experience.location!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        localizations.get('location_label'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.experience.location!,
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
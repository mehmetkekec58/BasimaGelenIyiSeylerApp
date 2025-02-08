import 'package:flutter/material.dart';
import 'dart:io';
import '../../data/models/experience_model.dart';
import '../../localization/app_localizations.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback onTap;
  final Future<bool?> Function(DismissDirection) onDismiss;
  final bool isDark;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.onTap,
    required this.onDismiss,
    required this.isDark,
  });

  String _getShortMonthName(BuildContext context, int month) {
    final localizations = AppLocalizations.of(context);
    return localizations.get('month_short_$month');
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(experience.date.toString()),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: isDark ? Colors.black : Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: onDismiss,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 200,
                  child: Stack(
                    children: [
                      if (experience.imagePaths != null && experience.imagePaths!.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: experience.imagePaths!.map((imagePath) => 
                              Container(
                                width: MediaQuery.of(context).size.width - 32, // Card width minus margins
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(imagePath)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ).toList(),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.grey.shade300,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                isDark ? Colors.grey.shade800 : Colors.grey.shade400,
                                isDark ? Colors.grey.shade900 : Colors.grey.shade300,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.photo,
                              size: 50,
                              color: isDark ? Colors.grey.shade700 : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      if (experience.imagePaths != null && experience.imagePaths!.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      if (experience.location != null && experience.location!.isNotEmpty)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade900 : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  experience.location!,
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (experience.imagePaths != null && experience.imagePaths!.length > 1)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${experience.imagePaths!.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              experience.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  experience.significance.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${experience.date.day} ${_getShortMonthName(context, experience.date.month)} ${experience.date.year}',
                                  style: const TextStyle(
                                    color: Colors.white70,
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
              ),
              if (experience.description != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    experience.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (experience.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: experience.tags.map((tag) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tag,
                              size: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 
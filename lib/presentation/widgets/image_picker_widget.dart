import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:io';

import '../../localization/app_localizations.dart';

class ImagePickerWidget extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function() onPickImages;
  final Function(int) onRemoveImage;
  final bool isDark;

  const ImagePickerWidget({
    super.key,
    required this.selectedImages,
    required this.onPickImages,
    required this.onRemoveImage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onPickImages,
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        child: selectedImages.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library,
                  size: 80, 
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  localizations.get('tap_to_select_images'),
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.get('multiple_images_allowed'),
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                selectedImages.length == 1
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(selectedImages[0].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close, 
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => onRemoveImage(0),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          selectedImages.length,
                          (index) => Stack(
                            children: [
                              Container(
                                width: 200,
                                height: 250,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: FileImage(File(selectedImages[index].path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 18,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close, 
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () => onRemoveImage(index),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate, size: 20),
                    label: Text(localizations.get('add_more_images')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onPickImages,
                  ),
                ),
              ],
            ),
      ),
    );
  }
} 
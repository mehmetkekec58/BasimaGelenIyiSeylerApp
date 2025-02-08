import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewerWidget extends StatefulWidget {
  final List<String> imagePaths;
  final Function(int) onPageChanged;
  final int currentPage;

  const ImageViewerWidget({
    Key? key,
    required this.imagePaths,
    required this.onPageChanged,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<ImageViewerWidget> createState() => _ImageViewerWidgetState();
}

class _ImageViewerWidgetState extends State<ImageViewerWidget> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.imagePaths.length,
          onPageChanged: widget.onPageChanged,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      body: Center(
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          child: Image.file(
                            File(widget.imagePaths[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Image.file(
                File(widget.imagePaths[index]),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        if (widget.imagePaths.length > 1)
          Positioned(
            bottom: 16,
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
                    '${widget.currentPage + 1}/${widget.imagePaths.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
} 
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_network_image.dart';

class ImageGallerySlider extends StatefulWidget {
  final List<String> images;
  final String heroTag;

  const ImageGallerySlider({
    super.key,
    required this.images,
    required this.heroTag,
  });

  @override
  State<ImageGallerySlider> createState() => _ImageGallerySliderState();
}

class _ImageGallerySliderState extends State<ImageGallerySlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 320,
        color: const Color(0xFFF1F5F9),
        child: const Center(
          child: Icon(Icons.broken_image_outlined, size: 48, color: AppTheme.textSecondaryLight),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final imageUrl = widget.images[index];
              final imageWidget = CustomNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 320,
              );

              if (index == 0) {
                return Hero(
                  tag: widget.heroTag,
                  child: imageWidget,
                );
              }
              return imageWidget;
            },
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final isSelected = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isSelected ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

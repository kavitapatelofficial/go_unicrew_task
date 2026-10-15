import 'package:flutter/material.dart';

class LoadingShimmerGrid extends StatefulWidget {
  final int itemCount;

  const LoadingShimmerGrid({
    super.key,
    this.itemCount = 6,
  });

  @override
  State<LoadingShimmerGrid> createState() => _LoadingShimmerGridState();
}

class _LoadingShimmerGridState extends State<LoadingShimmerGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final opacity = _animation.value;
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Skeleton
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 232, 240, opacity),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag skeleton
                        Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(226, 232, 240, opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Title skeleton line 1
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(226, 232, 240, opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Title skeleton line 2
                        Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(226, 232, 240, opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Price skeleton
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(226, 232, 240, opacity),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(226, 232, 240, opacity),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

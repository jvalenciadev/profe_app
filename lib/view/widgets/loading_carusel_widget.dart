import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LoadingCarouselPlaceholder extends StatelessWidget {
  const LoadingCarouselPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulamos 3 "eventos" vacíos
    final placeholders = List.filled(3, null);

    return Column(
      children: [
        CarouselSlider(
          items: placeholders.map((_) => _buildLoadingCard()).toList(),
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            aspectRatio: 16 / 9,
          ),
        ),
        const SizedBox(height: 5),
        _buildIndicator(placeholders.length),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

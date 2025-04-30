import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingPage extends StatelessWidget {
  const ShimmerLoadingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildShimmerBottomNavigation(),
              const SizedBox(height: 20),
              _buildShimmerBox(height: size.height / 2.5),
              const SizedBox(height: 20),
              _buildShimmerBox(height: 20, width: 150),
              const SizedBox(height: 10),
              _buildShimmerBox(height: 20, width: 250),
              const SizedBox(height: 30),
              _buildShimmerCategories(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildShimmerBottomNavigation(),
    );
  }

  // Create shimmer effect for a box (used in different places)
  Widget _buildShimmerBox(
      {required double height, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  // Create shimmer circles for categories
  Widget _buildShimmerCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) => _buildShimmerCircle()),
    );
  }

  // Create shimmer effect for a circle (used in categories)
  Widget _buildShimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 90,
        width: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Shimmer effect for the BottomNavigationBar
  Widget _buildShimmerBottomNavigation() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: List.generate(4, (index) {
          return const BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: '',
          );
        }),
      ),
    );
  }
}

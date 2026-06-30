import 'package:flutter/material.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/banner/banner.jpg', // sesuaikan dengan nama file banner kamu
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Zodiac Dashboard')),
    ),);
  }
}
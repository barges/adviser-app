import 'package:flutter/material.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Zodiac Articles')),
    ),);
  }
}
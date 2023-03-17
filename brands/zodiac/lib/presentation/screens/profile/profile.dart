import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;

  const ProfileScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: GestureDetector(
          onTap: context.router.pop,
          child: Text('Zodiac Profile   $name'))),
    ),);
  }
}
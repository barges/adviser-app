import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/infrastructure/routing/route_paths.dart';
import 'package:zodiac/presentation/screens/profile/profile.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Zodiac Account'),
          ElevatedButton(onPressed: () {
           zodiacGetIt.get<AppRouter>().push(context: context, route: ZodiacProfile(name: 'MAX'));
          }, child: Icon(Icons.ac_unit)),

        ],
      ),
    ),);
  }
}
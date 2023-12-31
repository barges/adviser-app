import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Notifications',
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text('Notifications'),
        ),
      ),
    );
  }
}

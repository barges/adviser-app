import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).hello),),
      body: Center(
        child: Text(S.of(context).hello),
      ),
    );
  }
}

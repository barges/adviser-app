
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';

class FortunicaBrandScreen extends StatelessWidget {
  const FortunicaBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(_) => fortunicaGetIt.get<FortunicaMainCubit>(),
      child: Builder(
        builder: (context) {
          return const AutoRouter();
        }
      ),
    );
  }
}
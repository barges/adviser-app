import 'package:shared_advisor_interface/global.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/zodiac_main_cubit.dart';


class ZodiacBrandScreen extends StatelessWidget {
  const ZodiacBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(_) => zodiacGetIt.get<ZodiacMainCubit>(),
      child: const AutoRouter(),
    );
  }
}
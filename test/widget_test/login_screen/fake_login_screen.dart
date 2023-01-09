import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_screen.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';

class FakeLoginScreen extends StatelessWidget {
  final AuthRepository authRepository;
  final CachingManager cachingManager;
  final DynamicLinkService dynamicLinkService;
  final Dio dio;

  const FakeLoginScreen({
    Key? key,
    required this.authRepository,
    required this.cachingManager,
    required this.dynamicLinkService,
    required this.dio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();
    return BlocProvider(
      create: (_) => LoginCubit(
        authRepository,
        cachingManager,
        mainCubit,
        dynamicLinkService,
        dio,
      ),
      child: Builder(builder: (context) {
        return const LoginContentWidget();
      }),
    );
  }
}

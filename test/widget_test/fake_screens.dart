import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_screen.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

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
        return const LoginWidget();
      }),
    );
  }
}

class FakeHomeScreen extends StatelessWidget {
  final CachingManager cachingManager;
  final ConnectivityService connectivityService;
  final UserRepository userRepository;
  final PushNotificationManager pushNotificationManager;
  final ChatsRepository chatsRepository;

  const FakeHomeScreen(
      {Key? key,
      required this.cachingManager,
      required this.connectivityService,
      required this.userRepository,
      required this.pushNotificationManager,
      required this.chatsRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        cachingManager,
        connectivityService,
        userRepository,
        pushNotificationManager,
      ),
      child: HomeWidget(
        cacheManager: cachingManager,
        connectivityService: connectivityService,
        userRepository: userRepository,
        chatsRepository: chatsRepository,
      ),
    );
  }
}

class FakeForgotPasswordScreen extends StatelessWidget {
  final AuthRepository authRepository;
  final DynamicLinkService dynamicLinkService;

  const FakeForgotPasswordScreen({
    Key? key,
    required this.authRepository,
    required this.dynamicLinkService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();
    return BlocProvider(
      create: (_) =>
          ForgotPasswordCubit(authRepository, dynamicLinkService, mainCubit),
      child: const ForgotPasswordWidget(),
    );
  }
}

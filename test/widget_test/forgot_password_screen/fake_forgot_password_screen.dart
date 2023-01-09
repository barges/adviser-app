import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';

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
      child: const ForgotPasswordContentWidget(),
    );
  }
}

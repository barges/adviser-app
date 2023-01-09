import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

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
      child: HomeContentWidget(
        cacheManager: cachingManager,
        connectivityService: connectivityService,
        userRepository: userRepository,
        chatsRepository: chatsRepository,
      ),
    );
  }
}

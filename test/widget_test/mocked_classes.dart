@GenerateMocks([
  DynamicLinkService,
  PushNotificationManager,
  UserRepository,
], customMocks: [
  MockSpec<DataCachingManager>(
    as: #MockDataCachingManager,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  // MockSpec<AuthRepository>(
  //   as: #MockAuthRepository,
  //   onMissingStub: OnMissingStub.returnDefault,
  // ),
  MockSpec<ChatsRepository>(
    as: #MockChatsRepository,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<ConnectivityService>(
    as: #MockConnectivityService,
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

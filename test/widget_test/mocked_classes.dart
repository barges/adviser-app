@GenerateMocks([
  DynamicLinkService,
  PushNotificationManager,
], customMocks: [
  MockSpec<DataCachingManager>(
    as: #MockDataCachingManager,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  // MockSpec<AuthRepositoryImpl>(
  //   as: #MockAuthRepositoryImpl,
  //   onMissingStub: OnMissingStub.returnDefault,
  // ),
  MockSpec<UserRepositoryImpl>(
    as: #MockUserRepositoryImpl,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<ChatsRepositoryImpl>(
    as: #MockChatsRepositoryImpl,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<ConnectivityService>(
    as: #MockConnectivityService,
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
import 'package:mockito/annotations.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/user_repository_impl.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

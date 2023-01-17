@GenerateMocks([
  DynamicLinkService,
  PushNotificationManagerImpl,
  UserRepositoryImpl,
], customMocks: [
  MockSpec<DataCachingManager>(
    as: #MockDataCachingManager,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<ChatsRepositoryImpl>(
    as: #MockChatsRepository,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<ConnectivityService>(
    as: #MockConnectivityService,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<CustomerRepositoryImpl>(
    as: #MockCustomerRepository,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<DefaultCacheManager>(
    as: #MockDefaultCacheManager,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<SoundRecordServiceImp>(
    as: #MockSoundRecordService,
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/user_repository_impl.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager_impl.dart';
import 'package:shared_advisor_interface/presentation/services/sound/sound_record_service.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/cache/global_caching_manager.dart' as _i8;
import '../../data/cache/global_caching_manager_impl.dart' as _i9;
import '../../data/cache/secure_storage_manager.dart' as _i12;
import '../../data/cache/secure_storage_manager_impl.dart' as _i13;
import '../../main_cubit.dart' as _i17;
import '../../services/audio/audio_player_service.dart' as _i3;
import '../../services/audio/audio_recorder_service.dart' as _i4;
import '../../services/check_permission_service.dart' as _i16;
import '../../services/connectivity_service.dart' as _i5;
import '../../services/dynamic_link_service.dart' as _i6;
import '../../services/fresh_chat_service.dart' as _i7;
import '../../services/push_notification/push_notification_manager.dart'
    as _i10;
import '../../services/push_notification/push_notification_manager_impl.dart'
    as _i11;
import '../../services/sound_mode_service.dart' as _i14;
import 'brand_manager.dart' as _i15;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.AudioPlayerService>(() => _i3.AudioPlayerServiceImpl());
  gh.factory<_i4.AudioRecorderService>(() => _i4.AudioRecorderServiceImp());
  gh.singleton<_i5.ConnectivityService>(_i5.ConnectivityService());
  gh.singleton<_i6.DynamicLinkService>(_i6.DynamicLinkService());
  gh.singleton<_i7.FreshChatService>(_i7.FreshChatServiceImpl());
  gh.singleton<_i8.GlobalCachingManager>(_i9.GlobalCachingManagerImpl());
  gh.singleton<_i10.PushNotificationManager>(
      _i11.PushNotificationManagerImpl());
  gh.singleton<_i12.SecureStorageManager>(_i13.SecureStorageManagerImpl());
  gh.singleton<_i14.SoundModeService>(_i14.SoundModeService());
  gh.singleton<_i15.BrandManager>(
      _i15.BrandManager(gh<_i8.GlobalCachingManager>()));
  gh.singleton<_i16.CheckPermissionService>(
      _i16.CheckPermissionService(gh<_i8.GlobalCachingManager>()));
  gh.singleton<_i17.MainCubit>(_i17.MainCubit(
    gh<_i8.GlobalCachingManager>(),
    gh<_i15.BrandManager>(),
    gh<_i5.ConnectivityService>(),
  ));
  return getIt;
}

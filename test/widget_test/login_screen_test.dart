import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_screen.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([
  DynamicLinkService
], customMocks: [
  MockSpec<DataCachingManager>(
    as: #MockDataCachingManager,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late MockDataCachingManager mockDataCachingManager;

  setUpAll(() async {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

    mockDataCachingManager = MockDataCachingManager();

    when(mockDataCachingManager.getUnauthorizedBrands())
        .thenReturn([Brand.fortunica]);

    await GetStorage.init();
    getIt.registerSingleton<CachingManager>(mockDataCachingManager);
    getIt.registerSingleton(MainCubit(
      getIt.get<CachingManager>(),
      ConnectivityService(),
    ));
    getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(AuthApi(Dio())));
    getIt.registerSingleton<DynamicLinkService>(MockDynamicLinkService());
  });
  testWidgets(
    "test description",
    (WidgetTester tester) async {
      Key key = Key('');
      await tester.pumpWidget(
        BlocProvider(
          create: (_) => getIt.get<MainCubit>(),
          child: GetMaterialApp(
            home: LoginScreen(),
            initialRoute: AppRoutes.login,
            getPages: AppRoutes.getPages,
            navigatorKey: navigatorKey,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byWidgetPredicate((widget) => widget is PasswordTextField),
          findsOneWidget);
    },
  );
}

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/user_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:shared_advisor_interface/presentation/di/dio_interceptors/app_interceptor.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/login/widgets/forgot_password_button_widget.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

import 'fake_screens.dart';
import 'login_screen_test.mocks.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<void> pumpLoginScreen({
  required WidgetTester tester,
  required AuthRepository authRepository,
  required CachingManager cachingManager,
  required MainCubit mainCubit,
  required DynamicLinkService dynamicLinkService,
  required Dio dio,
  ConnectivityService? connectivityService,
  PushNotificationManager? pushNotificationManager,
  UserRepository? userRepository,
  ChatsRepository? chatsRepository,
}) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => mainCubit,
      child: GetMaterialApp(
        initialRoute: AppRoutes.login,
        getPages: [
          GetPage(
            name: AppRoutes.login,
            page: () => FakeLoginScreen(
              authRepository: authRepository,
              cachingManager: cachingManager,
              dynamicLinkService: dynamicLinkService,
              dio: dio,
            ),
          ),
          GetPage(
            name: AppRoutes.home,
            page: () => FakeHomeScreen(
              cachingManager: cachingManager,
              connectivityService:
                  connectivityService ?? MockConnectivityService(),
              pushNotificationManager:
                  pushNotificationManager ?? MockPushNotificationManager(),
              userRepository: userRepository ?? MockUserRepositoryImpl(),
              chatsRepository: chatsRepository ?? MockChatsRepositoryImpl(),
            ),
          ),
          GetPage(
              name: AppRoutes.forgotPassword,
              page: () => FakeForgotPasswordScreen(
                  authRepository: authRepository,
                  dynamicLinkService: dynamicLinkService)),
        ],
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
}

@GenerateMocks([
  DynamicLinkService,
  PushNotificationManager,
], customMocks: [
  MockSpec<DataCachingManager>(
    as: #MockDataCachingManager,
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<AuthRepositoryImpl>(
    as: #MockAuthRepositoryImpl,
    onMissingStub: OnMissingStub.returnDefault,
  ),
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
void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late DataCachingManager mockDataCachingManager;
  late AuthRepositoryImpl mockAuthRepositoryImpl;
  late ConnectivityService mockConnectivityService;
  late UserRepositoryImpl mockUserRepositoryImpl;
  late DynamicLinkService mockDynamicLinkService;
  late PushNotificationManager mockPushNotificationManager;
  late ChatsRepositoryImpl mockChatsRepositoryImpl;
  late MainCubit mainCubit;

  setupFirebaseMocks();

  setUp(() async {
    await Firebase.initializeApp();
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

    mockDataCachingManager = MockDataCachingManager();
    mockAuthRepositoryImpl = MockAuthRepositoryImpl();
    mockConnectivityService = MockConnectivityService();
    mockUserRepositoryImpl = MockUserRepositoryImpl();
    mockDynamicLinkService = MockDynamicLinkService();
    mockPushNotificationManager = MockPushNotificationManager();
    mockChatsRepositoryImpl = MockChatsRepositoryImpl();

    when(mockDataCachingManager.getUnauthorizedBrands())
        .thenReturn([Brand.fortunica]);
    when(mockConnectivityService.checkConnection())
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockConnectivityService.connectivityStream)
        .thenAnswer((realInvocation) => Stream.value(true));
    when(mockUserRepositoryImpl.getUserInfo())
        .thenAnswer((realInvocation) => Future.value(const UserInfo()));
    when(mockDynamicLinkService.dynamicLinksStream)
        .thenAnswer((realInvocation) => PublishSubject());
    when(mockAuthRepositoryImpl.login()).thenAnswer((realInvocation) =>
        Future.value(LoginResponse('someRandomAccessToken')));

    mainCubit = MainCubit(mockDataCachingManager, mockConnectivityService);

    dio.interceptors.add(AppInterceptor(mainCubit, mockDataCachingManager));
  });

  tearDown(() {
    mainCubit.close();
  });

  testWidgets(
    'On LoginScreen'
    ' should be email and password textfields with hintTexts and login button',
    (WidgetTester tester) async {
      await pumpLoginScreen(
        tester: tester,
        authRepository: mockAuthRepositoryImpl,
        cachingManager: mockDataCachingManager,
        mainCubit: mainCubit,
        dynamicLinkService: mockDynamicLinkService,
        dio: dio,
      );

      expect(find.widgetWithText(AppTextField, S.current.enterYourEmail),
          findsOneWidget);

      expect(
          find.widgetWithText(PasswordTextField, S.current.enterYourPassword),
          findsOneWidget);

      expect(
          find.byWidgetPredicate((widget) =>
              widget is AppElevatedButton && widget.title == S.current.login),
          findsOneWidget);
    },
  );

  group('Login button', () {
    testWidgets(
      'should be disabled if email and password field is empty',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        expect(
            find.byWidgetPredicate((widget) =>
                widget is AppElevatedButton && widget.onPressed == null),
            findsOneWidget);
      },
    );

    testWidgets(
      'should be disabled if email field is filled, but password field is empty',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        await tester.enterText(
            find.byType(AppTextField), 'someEmail@gmail.com');

        await tester.pumpAndSettle();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is AppElevatedButton && widget.onPressed == null),
            findsOneWidget);
      },
    );

    testWidgets(
      'should be disabled if password field is filled, but email field is empty',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        await tester.enterText(find.byType(PasswordTextField), '123456');

        await tester.pumpAndSettle();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is AppElevatedButton && widget.onPressed == null),
            findsOneWidget);
      },
    );

    testWidgets(
      'should be enabled if password and email fields are filled',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        await tester.enterText(
            find.byType(AppTextField), 'someEmail@gmail.com');
        await tester.enterText(find.byType(PasswordTextField), '123456');
        await tester.pumpAndSettle();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is AppElevatedButton && widget.onPressed != null),
            findsOneWidget);
      },
    );

    testWidgets(
      'should redirect user to HomeScreen'
      ' if email and password fields filled and valid',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          pushNotificationManager: mockPushNotificationManager,
          userRepository: mockUserRepositoryImpl,
          chatsRepository: mockChatsRepositoryImpl,
        );

        await tester.enterText(
            find.byType(AppTextField), 'someEmail@gmail.com');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(PasswordTextField), '123456');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should not redirect user to HomeScreen and textfield error should appears'
      ' if email field filled, but with invalid value',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        await tester.enterText(find.byType(AppTextField), 'someEmailgmailcom');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(PasswordTextField), '123456');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppElevatedButton));
        await tester.pumpAndSettle();

        expect(
            find.widgetWithText(
                AppTextField, S.current.pleaseInsertCorrectEmail),
            findsOneWidget);
      },
    );

    testWidgets(
      'should not redirect user to HomeScreen and textfield error should appears'
      ' if password field filled, but its length less than 6',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        await tester.enterText(
            find.byType(AppTextField), 'someEmail@gmail.com');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(PasswordTextField), '1234');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppElevatedButton));
        await tester.pumpAndSettle();

        expect(
            find.widgetWithText(
                PasswordTextField, S.current.pleaseEnterAtLeast6Characters),
            findsOneWidget);
      },
    );
  });

  testWidgets(
    'NoConnectionWidget appears'
    ' if ConnectivityService connectivityStream returns false',
    (WidgetTester tester) async {
      when(mockConnectivityService.connectivityStream)
          .thenAnswer((realInvocation) => Stream.value(false));

      mainCubit = MainCubit(mockDataCachingManager, mockConnectivityService);

      await pumpLoginScreen(
        tester: tester,
        authRepository: mockAuthRepositoryImpl,
        cachingManager: mockDataCachingManager,
        mainCubit: mainCubit,
        dynamicLinkService: mockDynamicLinkService,
        dio: dio,
      );

      expect(find.byType(NoConnectionWidget), findsOneWidget);
    },
  );

  group(
    'Change localization button',
    () {
      testWidgets(
        'should be displayed on the Login screen',
        (WidgetTester tester) async {
          await pumpLoginScreen(
            tester: tester,
            authRepository: mockAuthRepositoryImpl,
            cachingManager: mockDataCachingManager,
            mainCubit: mainCubit,
            dynamicLinkService: mockDynamicLinkService,
            dio: dio,
          );

          expect(find.byType(ChangeLocaleButton), findsOneWidget);
        },
      );

      testWidgets(
        'should open language picker popup',
        (WidgetTester tester) async {
          await pumpLoginScreen(
            tester: tester,
            authRepository: mockAuthRepositoryImpl,
            cachingManager: mockDataCachingManager,
            mainCubit: mainCubit,
            dynamicLinkService: mockDynamicLinkService,
            dio: dio,
          );

          await tester.tap(find.byType(ChangeLocaleButton));
          await tester.pump();

          expect(find.byType(CupertinoPicker), findsOneWidget);
        },
      );
    },
  );

  // testWidgets(
  //   'AppErrorWidget appears'
  //   ' if the user entered the wrong email or password and clicked on Login button',
  //   (WidgetTester tester) async {
  //     dioAdapter.onPost(
  //       '/experts/login/app',
  //       (server) => server.reply(
  //         401,
  //         {'status': 'Unauthorized'},
  //       ),
  //     );

  //     mockAuthRepositoryImpl = AuthRepositoryImpl(AuthApi(dio));

  //     await pumpLoginScreen(
  //       tester: tester,
  //       authRepository: mockAuthRepositoryImpl,
  //       cachingManager: mockDataCachingManager,
  //       mainCubit: mainCubit,
  //       dynamicLinkService: mockDynamicLinkService,
  //       dio: dio,
  //     );

  //     await tester.enterText(
  //         find.byWidgetPredicate((widget) => widget is AppTextField),
  //         'someEmail@gmail.com');
  //     await tester.pumpAndSettle();

  //     await tester.enterText(
  //         find.byWidgetPredicate((widget) => widget is PasswordTextField),
  //         '123456');
  //     await tester.pumpAndSettle();

  //     await tester
  //         .tap(find.byWidgetPredicate((widget) => widget is AppElevatedButton));
  //     await tester.pumpAndSettle();

  //     logger.d(mainCubit.state.appError);

  //     expect(
  //       find.widgetWithText(
  //           AppErrorWidget, S.current.wrongUsernameAndOrPassword),
  //       findsOneWidget,
  //     );
  //   },
  // );

  group('Forgot password button', () {
    testWidgets(
      'should be displayed on Login screen',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        expect(
          find.byType(ForgotPasswordButtonWidget),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'should redirect user to Forgot password screen',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepositoryImpl,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
        );

        await tester.tap(find.byType(ForgotPasswordButtonWidget));
        await tester.pumpAndSettle();

        expect(
          find.byType(ForgotPasswordWidget),
          findsOneWidget,
        );
      },
    );
  });
}

extension PumpAndSettleWithTimeout on WidgetTester {
  Future<void> pumpNtimes({int times = 3}) async {
    return await Future.forEach(
        Iterable.generate(times), (_) async => await pump());
  }
}

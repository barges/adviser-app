import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
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

import '../forgot_password_screen/fake_forgot_password_screen.dart';
import '../home_screen/fake_home_screen.dart';
import '../mocked_classes.mocks.dart';
import 'fake_login_screen.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setupFirebaseCoreMocks();
}

Future<void> pumpLoginScreen({
  required WidgetTester tester,
  required AuthRepository authRepository,
  required CachingManager cachingManager,
  required MainCubit mainCubit,
  required DynamicLinkService dynamicLinkService,
  required Dio dio,
  required ConnectivityService connectivityService,
  required UserRepository userRepository,
  PushNotificationManager? pushNotificationManager,
  ChatsRepository? chatsRepository,
}) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: mainCubit,
      child: Builder(builder: (context) {
        return GetMaterialApp(
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
                connectivityService: connectivityService,
                pushNotificationManager: pushNotificationManager ??
                    MockPushNotificationManagerImpl(),
                userRepository: userRepository,
                chatsRepository: chatsRepository ?? MockChatsRepository(),
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
        );
      }),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late DataCachingManager mockDataCachingManager;
  late AuthRepository mockAuthRepository;
  late ConnectivityService mockConnectivityService;
  late UserRepository mockUserRepository;
  late DynamicLinkService mockDynamicLinkService;
  late PushNotificationManager mockPushNotificationManager;
  late ChatsRepository mockChatsRepository;
  late MainCubit mainCubit;

  setupFirebaseMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

    mockUserRepository = MockUserRepositoryImpl();
    when(mockUserRepository.getUserInfo())
        .thenAnswer((realInvocation) => Future.value(const UserInfo()));
  });

  setUp(() async {
    mockDataCachingManager = MockDataCachingManager();
    mockAuthRepository = AuthRepositoryImpl(AuthApi(dio));
    mockConnectivityService = MockConnectivityService();
    mockDynamicLinkService = MockDynamicLinkService();
    mockPushNotificationManager = MockPushNotificationManagerImpl();
    mockChatsRepository = MockChatsRepository();

    when(mockDataCachingManager.getUnauthorizedBrands())
        .thenReturn([Brand.fortunica]);
    when(mockConnectivityService.checkConnection())
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockConnectivityService.connectivityStream)
        .thenAnswer((realInvocation) => Stream.value(true));
    when(mockDynamicLinkService.dynamicLinksStream)
        .thenAnswer((realInvocation) => PublishSubject());

    mainCubit = MainCubit(mockDataCachingManager, mockConnectivityService);

    dio.interceptors.add(AppInterceptor(mainCubit, mockDataCachingManager));
  });

  testWidgets(
    'On LoginScreen'
    ' should be email and password textfields with hintTexts and login button',
    (WidgetTester tester) async {
      await pumpLoginScreen(
        tester: tester,
        authRepository: mockAuthRepository,
        cachingManager: mockDataCachingManager,
        mainCubit: mainCubit,
        dynamicLinkService: mockDynamicLinkService,
        dio: dio,
        connectivityService: mockConnectivityService,
        userRepository: mockUserRepository,
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
    setUpAll(() {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          {'accessToken': 'someRandomAcessToken'},
        ),
      );
    });
    testWidgets(
      'should be disabled if email and password field is empty',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          pushNotificationManager: mockPushNotificationManager,
          userRepository: mockUserRepository,
          chatsRepository: mockChatsRepository,
        );

        await tester.enterText(
            find.byType(AppTextField), 'someEmail@gmail.com');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(PasswordTextField), '123456');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeContentWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should not redirect user to HomeScreen and textfield error should appears'
      ' if email field filled, but with invalid value',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
        authRepository: mockAuthRepository,
        cachingManager: mockDataCachingManager,
        mainCubit: mainCubit,
        dynamicLinkService: mockDynamicLinkService,
        dio: dio,
        connectivityService: mockConnectivityService,
        userRepository: mockUserRepository,
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
            authRepository: mockAuthRepository,
            cachingManager: mockDataCachingManager,
            mainCubit: mainCubit,
            dynamicLinkService: mockDynamicLinkService,
            dio: dio,
            connectivityService: mockConnectivityService,
            userRepository: mockUserRepository,
          );

          expect(find.byType(ChangeLocaleButton), findsOneWidget);
        },
      );

      testWidgets(
        'should open language picker popup',
        (WidgetTester tester) async {
          await pumpLoginScreen(
            tester: tester,
            authRepository: mockAuthRepository,
            cachingManager: mockDataCachingManager,
            mainCubit: mainCubit,
            dynamicLinkService: mockDynamicLinkService,
            dio: dio,
            connectivityService: mockConnectivityService,
            userRepository: mockUserRepository,
          );

          await tester.tap(find.byType(ChangeLocaleButton));
          await tester.pump();

          expect(find.byType(CupertinoPicker), findsOneWidget);
        },
      );
    },
  );

  group('AppErrorWidget', () {
    testWidgets(
      'appears if the user entered the wrong email or password and clicked on Login button'
      'and disappears after 10 seconds',
      (WidgetTester tester) async {
        dioAdapter.onPost(
          '/experts/login/app',
          (server) => server.throws(
            401,
            DioError(
              requestOptions: RequestOptions(path: '/experts/login/app'),
              type: DioErrorType.response,
              response: Response(
                  requestOptions: RequestOptions(path: '/experts/login/app'),
                  statusCode: 401,
                  data: {'status': 'Unauthorized'}),
            ),
          ),
        );

        await pumpLoginScreen(
          tester: tester,
          authRepository: AuthRepositoryImpl(AuthApi(dio)),
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
        );

        await tester.enterText(
            find.byType(AppTextField), 'someEmail@gmail.com');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(PasswordTextField), '123456');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppElevatedButton));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(
              AppErrorWidget, S.current.wrongUsernameAndOrPassword),
          findsOneWidget,
        );

        await tester.pumpAndSettle(const Duration(seconds: 11));

        expect(
          find.widgetWithText(
              AppErrorWidget, S.current.wrongUsernameAndOrPassword),
          findsNothing,
        );
      },
    );
  });

  group('Forgot password button', () {
    testWidgets(
      'should be displayed on Login screen',
      (WidgetTester tester) async {
        await pumpLoginScreen(
          tester: tester,
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
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
          authRepository: mockAuthRepository,
          cachingManager: mockDataCachingManager,
          mainCubit: mainCubit,
          dynamicLinkService: mockDynamicLinkService,
          dio: dio,
          connectivityService: mockConnectivityService,
          userRepository: mockUserRepository,
        );

        await tester.tap(find.byType(ForgotPasswordButtonWidget));
        await tester.pumpAndSettle();

        expect(
          find.byType(ForgotPasswordContentWidget),
          findsOneWidget,
        );
      },
    );
  });
}

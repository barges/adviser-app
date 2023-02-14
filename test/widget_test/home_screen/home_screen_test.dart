import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/resources_page/widgets/chart_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/widgets/month_statistic_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/widgets/personal_information_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_of_questions.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/search/search_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/status_not_live_widget.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';
import 'package:shared_advisor_interface/extensions.dart';

import '../../common_methods.dart';
import '../../common_variables.dart';
import '../mocked_classes/mocked_classes.mocks.dart';
import 'home_screen_test_constants.dart';
import 'home_screen_test_responses.dart';

Future<void> pumpHomeScreen({
  required WidgetTester tester,
}) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: testGetIt.get<MainCubit>(),
      child: Builder(builder: (context) {
        return GetMaterialApp(
          initialRoute: AppRoutes.home,
          theme: AppThemes.themeLight(context),
          getPages: [
            GetPage(
              name: AppRoutes.home,
              page: () => const HomeScreen(),
            ),
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
}

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late MockDataCachingManager mockCachingManager;
  late ConnectivityService mockConnectivityService;
  late UserRepository mockUserRepository;
  late ChatsRepository mockChatsRepository;
  late PushNotificationManager mockPushNotificationManager;
  late CheckPermissionService mockCheckPermissionService;

  setupFirebaseMocks();
  testGetIt.allowReassignment = true;

  setUpAll(() async {
    await Firebase.initializeApp();

    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    mockCachingManager = MockDataCachingManager();
    mockConnectivityService = MockConnectivityService();
    mockUserRepository = MockUserRepositoryImpl();
    mockChatsRepository = ChatsRepositoryImpl(ChatsApi(dio));
    mockPushNotificationManager = MockPushNotificationManagerImpl();
    mockCheckPermissionService = MockCheckPermissionService();

    when(mockConnectivityService.checkConnection())
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockConnectivityService.connectivityStream)
        .thenAnswer((realInvocation) => Stream.value(true));

    when(mockUserRepository.getUserInfo()).thenAnswer(
        (realInvocation) => Future.value(HomeScreenTestConstants.userInfo));
    when(mockUserRepository.getUserReports()).thenAnswer((realInvocation) =>
        Future.value(HomeScreenTestConstants.reportsResponse));

    when(mockCachingManager.listenUserProfile(argThat(anything)))
        .thenAnswer((realInvocation) {
      Function(UserProfile) callback = realInvocation.positionalArguments[0];
      callback(HomeScreenTestConstants.userInfo.profile!);
      return () {};
    });
    when(mockCachingManager.listenUserId(argThat(anything)))
        .thenAnswer((realInvocation) {
      Function(String?) callback = realInvocation.positionalArguments[0];
      callback(HomeScreenTestConstants.userInfo.id);
      return () {};
    });

    testGetIt.registerSingleton<ConnectivityService>(mockConnectivityService);
    testGetIt.registerSingleton<UserRepository>(mockUserRepository);
    testGetIt
        .registerSingleton<CheckPermissionService>(mockCheckPermissionService);
    testGetIt.registerSingleton<PushNotificationManager>(
        mockPushNotificationManager);
  });

  setUp(() {
    dioAdapter.onGet('/experts/questions/public?limit=20', (server) {
      server.reply(200, HomeScreenTestResponses.publicSessionsListResponse);
    });
    dioAdapter.onGet('/experts/conversations?limit=20', (server) {
      server.reply(200, HomeScreenTestResponses.privateSessionsListResponse);
    });

    when(mockCachingManager.getUserStatus())
        .thenReturn(const UserStatus(status: FortunicaUserStatus.live));

    testGetIt.registerSingleton<ChatsRepository>(mockChatsRepository);
    testGetIt.registerSingleton<CachingManager>(mockCachingManager);
    testGetIt.registerSingleton<MainCubit>(
        MainCubit(mockCachingManager, mockConnectivityService));
  });

  group('BottomNavigationBar', () {
    testWidgets('should have Dashboard, Sessions and Account options',
        (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      expect(find.widgetWithText(BottomNavigationBar, 'Dashboard'),
          findsOneWidget);
      expect(
          find.widgetWithText(BottomNavigationBar, 'Sessions'), findsOneWidget);
      expect(
          find.widgetWithText(BottomNavigationBar, 'Account'), findsOneWidget);
    });

    testWidgets('should have options with specific icons', (tester) async {
      await tester.runAsync(() async {
        await pumpHomeScreen(tester: tester);
        await tester.pumpAndSettle();

        List<Element> elements = tester
            .elementList(find.descendant(
                of: find.byType(BottomNavigationBar),
                matching: find.byType(SvgPicture)))
            .toList();

        for (Element element in elements) {
          SvgPicture image = element.widget as SvgPicture;
          await precachePicture(image.pictureProvider, element);
        }
      });

      expectLater(find.byType(BottomNavigationBar),
          matchesGoldenFile('goldens/bottom_navigation_bar_icons.png'));
    });

    testWidgets(
        'should show Dashboard tab'
        ' if selected option is Dashboard', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Dashboard'));
      await tester.pump();

      expect(find.byType(DashboardV1Screen), findsOneWidget);
    });

    testWidgets(
        'should show Sessions tab'
        ' if selected option is Sessions', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      expect(find.byType(SessionsScreen), findsOneWidget);
    });

    testWidgets(
        'should show Account tab'
        ' if selected option is Account', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(find.byType(AccountScreen), findsOneWidget);
    });
  });

  group('Dashboard tab', () {
    testWidgets(
        'should be displayed with PersonalInformationWidget'
        ' that contains UserAvatar and user name', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Dashboard'));
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(PersonalInformationWidget),
              matching: find.byType(UserAvatar)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(PersonalInformationWidget),
              matching: find.text(
                  HomeScreenTestConstants.userInfo.profile?.profileName ?? '')),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with MonthStatisticWidget'
        ' that contains monthly income and ChartWidget', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Dashboard'));
      await tester.pump();

      ReportsStatistics? statistics = HomeScreenTestConstants
          .reportsResponse.dateRange?.first.months?.first.statistics;
      final String? monthAmount =
          statistics?.total?.marketTotal?.amount?.parseValueToCurrencyFormat;
      final String? currencySymbol =
          statistics?.meta?.currency?.currencySymbolByName;
      expect(
          find.descendant(
              of: find.byType(MonthStatisticWidget),
              matching: find.byType(ChartWidget)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(MonthStatisticWidget),
              matching: find.text('$currencySymbol $monthAmount')),
          findsOneWidget);
    });
  });

  group('Sessions tab', () {
    testWidgets(
        'should be displayed with ChooseOptionWidget and ListOfQuestions widget',
        (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      expect(find.byType(SessionsScreen), findsOneWidget);
      expect(find.byType(ChooseOptionWidget), findsOneWidget);
      expect(find.byType(ListOfQuestions), findsOneWidget);
    });

    testWidgets(
        'should be displayed with NotLiveStatusWidget'
        ' if user status is not live', (tester) async {
      when(mockCachingManager.getUserStatus())
          .thenReturn(const UserStatus(status: FortunicaUserStatus.offline));

      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      expect(find.byType(NotLiveStatusWidget), findsOneWidget);
    });

    testWidgets(
        'should be displayed with NotLiveStatusWidget and specific text'
        ' if user status is offline', (tester) async {
      when(mockCachingManager.getUserStatus())
          .thenReturn(const UserStatus(status: FortunicaUserStatus.offline));

      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      expect(
          find.widgetWithText(NotLiveStatusWidget, 'You\'re currently offline'),
          findsOneWidget);
      expect(
          find.widgetWithText(NotLiveStatusWidget,
              'Change your status in your profile to make yourself visible to users.'),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with NotLiveStatusWidget and specific text'
        ' if user status is legal block', (tester) async {
      when(mockCachingManager.getUserStatus())
          .thenReturn(const UserStatus(status: FortunicaUserStatus.legalBlock));

      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      expect(
          find.widgetWithText(
              NotLiveStatusWidget, 'You need to accept the advisor contract'),
          findsOneWidget);
      expect(
          find.widgetWithText(NotLiveStatusWidget,
              'Please login to the web version of your account.'),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with NotLiveStatusWidget and specific text'
        ' if user status is incomplete', (tester) async {
      when(mockCachingManager.getUserStatus())
          .thenReturn(const UserStatus(status: FortunicaUserStatus.incomplete));

      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      expect(
          find.widgetWithText(
              NotLiveStatusWidget, 'You\'re not live on the platform'),
          findsOneWidget);
      expect(
          find.widgetWithText(NotLiveStatusWidget,
              'Please ensure your profile is completed for all languages. Need help? Contact your manager.'),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with SearchListWidget'
        ' if user clicks on search button', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Sessions'));
      await tester.pump();

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is AppIconButton &&
          widget.icon == Assets.vectors.search.path));
      await tester.pumpAndSettle();

      expect(find.byType(SearchListWidget), findsOneWidget);
    });
  });

  group('Account tab', () {
    testWidgets('should be displayed with UserAvatar, user name'
    ' and five tile widgets: "I\'m available now", ', (tester) async {});
  });
}

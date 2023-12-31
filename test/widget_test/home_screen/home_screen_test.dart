import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/widgets/bottom_section.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/widgets/brand_item.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/tile_widget.dart';
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
            GetPage(
              name: AppRoutes.advisorPreview,
              page: () => const AdvisorPreviewScreen(),
            ),
            GetPage(
              name: AppRoutes.balanceAndTransactions,
              page: () => const BalanceAndTransactionsScreen(),
            ),
            GetPage(
              name: AppRoutes.editProfile,
              page: () => const EditProfileScreen(),
            )
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
  late MockAuthRepositoryImpl mockAuthRepository;

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
    mockAuthRepository = MockAuthRepositoryImpl();

    when(mockConnectivityService.checkConnection())
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockConnectivityService.connectivityStream)
        .thenAnswer((realInvocation) => Stream.value(true));

    when(mockUserRepository.getUserInfo()).thenAnswer(
        (realInvocation) => Future.value(HomeScreenTestConstants.userInfo));
    when(mockUserRepository.getUserReports()).thenAnswer((realInvocation) =>
        Future.value(HomeScreenTestConstants.reportsResponse));

    testGetIt.registerSingleton<ConnectivityService>(mockConnectivityService);
    testGetIt.registerSingleton<UserRepository>(mockUserRepository);
    testGetIt
        .registerSingleton<CheckPermissionService>(mockCheckPermissionService);
    testGetIt.registerSingleton<PushNotificationManager>(
        mockPushNotificationManager);
    testGetIt.registerSingleton<AuthRepository>(mockAuthRepository);
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
    when(mockCachingManager.getAuthorizedBrands())
        .thenReturn([Brand.fortunica]);
    when(mockCachingManager.getUnauthorizedBrands())
        .thenReturn([Brand.zodiacPsychics]);
    when(mockCachingManager.getUserProfile())
        .thenReturn(HomeScreenTestConstants.userInfo.profile);

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
    testWidgets(
        'should be displayed with UserAvatar, user name'
        ' and five tile widgets', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(
          find.descendant(
              of: find.byType(AccountScreen),
              matching: find.byType(UserAvatar)),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(AccountScreen),
              matching: find.text(
                  HomeScreenTestConstants.userInfo.profile!.profileName!)),
          findsOneWidget);
      expect(find.byType(TileWidget), findsNWidgets(5));
    });

    testWidgets(
        'should be displayed with "I\'m available now" tile widget'
        ' that contains switcher', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(find.widgetWithText(TileWidget, 'I\'m available now'),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.widgetWithText(TileWidget, 'I\'m available now'),
              matching: find.byType(CupertinoSwitch)),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with "Notifications" tile widget'
        ' that contains switcher', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(find.widgetWithText(TileWidget, 'Notifications'), findsOneWidget);
      expect(
          find.descendant(
              of: find.widgetWithText(TileWidget, 'Notifications'),
              matching: find.byType(CupertinoSwitch)),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with "Preview account" tile widget'
        ' that contains arrow button', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(
          find.widgetWithText(TileWidget, 'Preview account'), findsOneWidget);
      expect(
          find.descendant(
              of: find.widgetWithText(TileWidget, 'Preview account'),
              matching: find.byKey(const Key('arrow_right_button'))),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with "Balance & Transactions" tile widget'
        ' that contains arrow button', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(find.widgetWithText(TileWidget, 'Balance & Transactions'),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.widgetWithText(TileWidget, 'Balance & Transactions'),
              matching: find.byKey(const Key('arrow_right_button'))),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with "Settings" tile widget'
        ' that contains arrow button', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(find.widgetWithText(TileWidget, 'Settings'), findsOneWidget);
      expect(
          find.descendant(
              of: find.widgetWithText(TileWidget, 'Settings'),
              matching: find.byKey(const Key('arrow_right_button'))),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed "Your Username text"'
        ' if advisor profile name is null', (tester) async {
      when(mockCachingManager.listenUserProfile(argThat(anything)))
          .thenAnswer((realInvocation) {
        Function(UserProfile) callback = realInvocation.positionalArguments[0];
        callback(HomeScreenTestConstants.userInfo.profile!
            .copyWith(profileName: null));
        return () {};
      });
      when(mockCachingManager.getUserProfile()).thenReturn(
          HomeScreenTestConstants.userInfo.profile!
              .copyWith(profileName: null));
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(BottomNavigationBar, 'Account'));
      await tester.pump();

      expect(find.text('Your Username'), findsOneWidget);
    });

    testWidgets(
        'should redirect to Preview account screen'
        ' if user clicks on "Preview account" tile', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Account')));
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(TileWidget), matching: find.text('Preview account')));
      await tester.pumpAndSettle();

      expect(find.byType(AdvisorPreviewScreen), findsOneWidget);
    });

    testWidgets(
        'should redirect to Balance & Transactions screen'
        ' if user clicks on "Balance & Transactions" tile', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Account')));
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(TileWidget),
          matching: find.text('Balance & Transactions')));
      await tester.pumpAndSettle();

      expect(find.byType(BalanceAndTransactionsScreen), findsOneWidget);
    });

    testWidgets(
        'should redirect to Edit profile screen'
        ' if user clicks on UserAvatar', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text('Account')));
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(AccountScreen), matching: find.byType(UserAvatar)));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
    });
  });

  group('Sidebar', () {
    testWidgets('should not be displayed by default', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      expect(find.byType(AppDrawer), findsNothing);
    });

    testWidgets(
        'should be displayed'
        ' if user clicks on text on AppBar', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(DashboardV1Screen),
          matching: find.descendant(
              of: find.byType(HomeAppBar), matching: find.byType(Text))));
      await tester.pump();

      expect(find.byType(AppDrawer), findsOneWidget);
    });

    testWidgets('should be displayed with BrandItem widgets', (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(DashboardV1Screen),
          matching: find.descendant(
              of: find.byType(HomeAppBar), matching: find.byType(Text))));
      await tester.pump();

      expect(find.byType(BrandItem), findsWidgets);
    });

    testWidgets('should be displayed with BottomSection widget',
        (tester) async {
      await pumpHomeScreen(tester: tester);
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
          of: find.byType(DashboardV1Screen),
          matching: find.descendant(
              of: find.byType(HomeAppBar), matching: find.byType(Text))));
      await tester.pump();

      expect(find.byType(BottomSection), findsOneWidget);
    });
  });
}

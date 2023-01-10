import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

import '../mocked_classes.mocks.dart';
import 'fake_chat_screen.dart';

Future<void> pumpChatScreen({
  required WidgetTester tester,
  required MainCubit mainCubit,
  required ChatsRepository chatsRepository,
  required ConnectivityService connectivityService,
  required ChatScreenArguments chatScreenArguments,
}) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: mainCubit,
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            onGenerateRoute: (_) => GetPageRoute(
                page: () => FakeChatScreen(
                      chatsRepository: chatsRepository,
                      connectivityService: connectivityService,
                    ),
                settings: RouteSettings(arguments: chatScreenArguments)),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  late ChatsRepository mockChatsRepository;
  late MockConnectivityService mockConnectivityService;
  late MockDataCachingManager mockCacheManager;
  late MainCubit mainCubit;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

    dioAdapter.onGet('/v2/clients/63bbab1b793423001e28722e', (server) {
      server.reply(200, {
        "_id": "63bbab1b793423001e28722e",
        "firstName": "Anabel",
        "lastName": "Rau",
        "zodiac": "capricorn",
        "birthdate": "1989-01-09T00:00:00.000Z",
        "gender": "female",
        "country": "IE",
        "isProfileCompleted": false,
        "questionsSubscription": {"active": false},
        "safeToSendEmail": false,
        "id": "63bbab1b793423001e28722e",
        "countryFullName": "Ireland",
        "totalMessages": 0,
        "advisorMatch": {}
      });
    });

    dioAdapter.onGet(
      '/notes',
      data: {'clientID': '63bbab1b793423001e28722e'},
      (server) {
        server.reply(200, {"content": ""});
      },
    );

    getIt.registerLazySingleton<CustomerRepository>(
        () => CustomerRepositoryImpl(CustomerApi(dio)));
  });

  setUp(() {
    mockChatsRepository = ChatsRepositoryImpl(ChatsApi(dio));
    mockConnectivityService = MockConnectivityService();
    mockCacheManager = MockDataCachingManager();

    mainCubit = MainCubit(mockCacheManager, mockConnectivityService);
  });

  group('ChooseOptionWidget', () {
    testWidgets(
      'should be displayed on Chat screen',
      (WidgetTester tester) async {
        await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments());

        expect(find.byType(ChooseOptionWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should have 2 options and HistoryWidget should be displayed'
      ' if there are any question ids in ChatScreenArguments',
      (WidgetTester tester) async {
        await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
                clientIdFromPush: '63bbab1b793423001e28722e'));

        await tester.pump(const Duration(seconds: 5));
        ChooseOptionWidget chooseOptionWidget =
            tester.firstWidget(find.byType(ChooseOptionWidget));

        expect(chooseOptionWidget.options.length, 2);

        expect(find.byType(HistoryWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should have 3 options and ActiveChatWidget should be displayed'
      ' if ChatScreenArguments have'
      ' publicQuestionId or privateQuestionId or ritualID,',
      (WidgetTester tester) async {
        dioAdapter.onGet('/questions/single/63bbab87ea0df2001dce8630',
            (server) {
          server.reply(200, {
            "clientInformation": {
              "birthdate": "1989-01-09T00:00:00.000Z",
              "zodiac": "capricorn",
              "gender": "female",
              "country": "IE",
              "firstName": "Anabel",
              "lastName": "Rau"
            },
            "takenDate": null,
            "startAnswerDate": null,
            "readByAdvisor": true,
            "_id": "63bbab87ea0df2001dce8630",
            "clientID": "63bbab1b793423001e28722e",
            "language": "en",
            "type": "PUBLIC",
            "content": "We need to override the auxiliary PCI monitor!",
            "attachments": [],
            "clientName": "Anabel Rau",
            "status": "OPEN",
            "likes": [],
            "createdAt": "2023-01-09T05:52:07.143Z",
            "updatedAt": "2023-01-09T07:47:03.220Z",
            "expertID": null
          });
        });

        await pumpChatScreen(
          tester: tester,
          mainCubit: mainCubit,
          chatsRepository: mockChatsRepository,
          connectivityService: mockConnectivityService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
          ),
        );

        ChooseOptionWidget chooseOptionWidget =
            tester.firstWidget(find.byType(ChooseOptionWidget));

        expect(chooseOptionWidget.options.length, 3);

        expect(find.byType(ActiveChatWidget), findsOneWidget);
      },
    );
  });
}

import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/gender.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/ritual_info_card_widget.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

import '../mocked_classes.mocks.dart';
import 'fake_chat_screen.dart';

ChatItem publicQuestion = ChatItem(
    type: ChatItemType.public,
    questionType: null,
    ritualIdentifier: null,
    status: ChatItemStatusType.open,
    clientName: 'Anabel Rau',
    takenDate: null,
    createdAt: DateTime.parse('2023-01-09 05:52:07.143Z'),
    updatedAt: DateTime.parse('2023-01-10 07:05:46.529Z'),
    startAnswerDate: null,
    content: 'We need to override the auxiliary PCI monitor!',
    id: '63bbab87ea0df2001dce8630',
    clientInformation: ClientInformation(
        birthdate: DateTime.parse('1989-01-09 00:00:00.000Z'),
        zodiac: ZodiacSign.capricorn,
        gender: Gender.female,
        country: 'IE'),
    attachments: [],
    unansweredTypes: null,
    clientID: '63bbab1b793423001e28722e',
    ritualID: null,
    lastQuestionId: null,
    unansweredCount: null,
    storyID: null,
    isActive: false,
    isAnswer: false,
    isSent: true);

ChatItem ritualQuestion = ChatItem(
    type: ChatItemType.ritual,
    questionType: null,
    ritualIdentifier: SessionsTypes.lovecrushreading,
    status: null,
    clientName: 'Hope Fortunikovna',
    takenDate: null,
    createdAt: DateTime.parse('2022-07-25 08:52:45.695Z'),
    updatedAt: DateTime.parse('2023-01-03 15:53:46.134Z'),
    startAnswerDate: null,
    content: 'Test',
    id: '62de59dd510689001ddb8094',
    clientInformation: ClientInformation(
        birthdate: DateTime.parse('1989-02-07 00:00:00.000Z'),
        zodiac: ZodiacSign.aquarius,
        gender: Gender.nonGender,
        country: 'BR'),
    attachments: [],
    unansweredTypes: null,
    clientID: '5f5224f45a1f7c001c99763c',
    ritualID: '62de59dd510689001ddb8090',
    lastQuestionId: null,
    unansweredCount: null,
    storyID: '62de59dd510689001ddb8092',
    isActive: true,
    isAnswer: false,
    isSent: true);

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
  tester.takeException();
  await tester.pumpAndSettle();
}

void main() {
  late ChatsRepository mockChatsRepository;
  late MockConnectivityService mockConnectivityService;
  late MockDataCachingManager mockCacheManager;
  late MainCubit mainCubit;
  late Dio dio;
  late DioAdapter dioAdapter;

  LiveTestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel('com.ryanheise.audio_session')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getConfiguration') {
      AudioSessionConfiguration audioSessionConfiguration =
          AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      );

      return audioSessionConfiguration
          .toJson(); // set initial values here if desired
    }
    return null;
  });
  const MethodChannel('com.dooboolab.flutter_sound_recorder')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'resetPlugin') {
      return Future.delayed(const Duration(milliseconds: 20));
    }
    return null;
  });

  setUpAll(() {
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

    dioAdapter.onGet('/questions/single/63bbab87ea0df2001dce8630', (server) {
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

    dioAdapter.onGet('/v2/clients/5f5224f45a1f7c001c99763c', (server) {
      server.reply(200, {
        "questionsSubscription": {"status": 3, "active": true},
        "_id": "5f5224f45a1f7c001c99763c",
        "zodiac": "aquarius",
        "country": "BR",
        "birthdate": "1989-02-07T00:00:00.000Z",
        "firstName": "Hope",
        "gender": "non_gender",
        "lastName": "Fortunikovna",
        "isProfileCompleted": false,
        "safeToSendEmail": false,
        "id": "5f5224f45a1f7c001c99763c",
        "countryFullName": "Brazil",
        "totalMessages": 551,
        "advisorMatch": {
          "offer": "Purpose and Destiny",
          "advisorType": "Keep it real"
        }
      });
    });

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
        await tester.runAsync(() async => await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
                clientIdFromPush: '63bbab1b793423001e28722e')));

        ChooseOptionWidget chooseOptionWidget =
            tester.firstWidget(find.byType(ChooseOptionWidget));

        await tester.pumpAndSettle();

        expect(chooseOptionWidget.options.length, 2);

        expect(find.byType(HistoryWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should have 3 options and ActiveChatWidget should be displayed'
      ' if ChatScreenArguments have'
      ' publicQuestionId or privateQuestionId or ritualID,',
      (WidgetTester tester) async {
        await pumpChatScreen(
          tester: tester,
          mainCubit: mainCubit,
          chatsRepository: mockChatsRepository,
          connectivityService: mockConnectivityService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
            question: publicQuestion,
          ),
        );

        ChooseOptionWidget chooseOptionWidget =
            tester.firstWidget(find.byType(ChooseOptionWidget));

        expect(chooseOptionWidget.options.length, 3);

        expect(find.byType(ActiveChatWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should redirect to History tab'
      ' if user ActiveChat tab is displayed and user tap on second option',
      (WidgetTester tester) async {
        await pumpChatScreen(
          tester: tester,
          mainCubit: mainCubit,
          chatsRepository: mockChatsRepository,
          connectivityService: mockConnectivityService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
            question: publicQuestion,
          ),
        );

        expect(find.byType(ActiveChatWidget), findsOneWidget);

        ChooseOptionWidget chooseOptionWidget =
            tester.firstWidget(find.byType(ChooseOptionWidget));

        String secondOptionText = chooseOptionWidget.options[1];

        await tester.tap(find.text(secondOptionText));
        await tester.pump();

        expect(find.byType(HistoryWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should redirect to CustomerProfile tab'
      ' if user ActiveChat tab is displayed and user tap on third option',
      (WidgetTester tester) async {
        await pumpChatScreen(
          tester: tester,
          mainCubit: mainCubit,
          chatsRepository: mockChatsRepository,
          connectivityService: mockConnectivityService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
            question: publicQuestion,
          ),
        );

        expect(find.byType(ActiveChatWidget), findsOneWidget);

        ChooseOptionWidget chooseOptionWidget =
            tester.firstWidget(find.byType(ChooseOptionWidget));

        String secondOptionText = chooseOptionWidget.options[2];

        await tester.tap(find.text(secondOptionText));
        await tester.pump();

        expect(find.byType(CustomerProfileWidget), findsOneWidget);
      },
    );
  });

  group(
    'Take question button',
    () {
      testWidgets(
        'should be displayed on ActiveChat tab'
        ' if the user has opened a public question'
        ' that has not yet been taken by him',
        (WidgetTester tester) async {
          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: publicQuestion,
            ),
          );

          expect(find.byType(AppElevatedButton), findsOneWidget);
        },
      );

      testWidgets(
        'should disappear when user click on it and the input field should appear'
        ' if public question that user want to take is not taken by anyone else',
        (WidgetTester tester) async {
          dioAdapter.onPost(
            '/questions/take',
            (server) {
              server.reply(200, {
                "clientInformation": {
                  "birthdate": "1989-01-09T00:00:00.000Z",
                  "zodiac": "capricorn",
                  "gender": "female",
                  "country": "IE"
                },
                "deleted": false,
                "takenDate": "2023-01-10T11:21:31.519Z",
                "startAnswerDate": null,
                "readByAdvisor": true,
                "_id": "63bbab87ea0df2001dce8630",
                "clientID": "63bbab1b793423001e28722e",
                "language": "en",
                "type": "PUBLIC",
                "content": "We need to override the auxiliary PCI monitor!",
                "attachments": [],
                "clientName": "Anabel Rau",
                "storyID": "63bbab83793423001e28724b",
                "deviceOS": "ios",
                "status": "TAKEN",
                "purchaseID": "63bbab87ea0df2001dce8623",
                "likes": [],
                "createdAt": "2023-01-09T05:52:07.143Z",
                "updatedAt": "2023-01-10T11:21:31.520Z",
                "__v": 0,
                "expertID":
                    "39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b"
              });
            },
          );

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: publicQuestion,
            ),
          );

          await tester.tap(find.byType(AppElevatedButton));
          await tester.pump();

          expect(find.byType(ActiveChatInputFieldWidget), findsOneWidget);
        },
      );

      testWidgets(
        'should open error dialog box'
        ' if user click on it, but public question was already taken',
        (WidgetTester tester) async {
          dioAdapter.onPost(
            '/questions/take',
            (server) {
              server.reply(409, {
                "status": "The question was already taken",
                "payload": {
                  "questionID": "63bbab87ea0df2001dce8630",
                  "questionToTake": {
                    "clientInformation": {
                      "birthdate": "1989-01-09T00:00:00.000Z",
                      "zodiac": "capricorn",
                      "gender": "female",
                      "country": "IE"
                    },
                    "deleted": false,
                    "takenDate": "2023-01-10T11:37:11.248Z",
                    "startAnswerDate": null,
                    "readByAdvisor": true,
                    "_id": "63bbab87ea0df2001dce8630",
                    "clientID": "63bbab1b793423001e28722e",
                    "language": "en",
                    "type": "PUBLIC",
                    "content": "We need to override the auxiliary PCI monitor!",
                    "attachments": [],
                    "clientName": "Anabel Rau",
                    "storyID": "63bbab83793423001e28724b",
                    "deviceOS": "ios",
                    "status": "TAKEN",
                    "purchaseID": "63bbab87ea0df2001dce8623",
                    "likes": [],
                    "createdAt": "2023-01-09T05:52:07.143Z",
                    "updatedAt": "2023-01-10T11:37:11.249Z",
                    "__v": 0,
                    "expertID":
                        "0ba684917ad77d2b7578d7f8b54797ca92c329e80898ff0fb7ea480d32bcb090"
                  },
                  "advisorId":
                      "39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b"
                }
              });
            },
          );

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: publicQuestion,
            ),
          );

          await tester.tap(find.byType(AppElevatedButton));
          await tester.pump();

          expect(
              find.byWidgetPredicate((widget) =>
                  widget is CupertinoAlertDialog || widget is Dialog),
              findsOneWidget);
        },
      );

      testWidgets(
        'should open error dialog box'
        ' if user click on it, but backend returns unknown error',
        (WidgetTester tester) async {
          dioAdapter.onPost(
            '/questions/take',
            (server) {
              server.reply(440, {});
            },
          );

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: publicQuestion,
            ),
          );

          await tester.tap(find.byType(AppElevatedButton));
          await tester.pump();

          expect(
              find.byWidgetPredicate((widget) =>
                  widget is CupertinoAlertDialog || widget is Dialog),
              findsOneWidget);
        },
      );
    },
  );

  group(
    'RitualInfoCardWidget',
    () {
      testWidgets(
        'should be displayed if active question on Chat screen is ritual',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de59dd510689001ddb8090',
              (server) {
            server.reply(200, {
              "totalQuestions": 1,
              "leftQuestions": 0,
              "_id": "62de59dd510689001ddb8090",
              "status": "FAILED",
              "identifier": "lovecrushreading",
              "clientName": "Maryna Test",
              "language": "en",
              "inputFieldsData": [
                {
                  "_id": "62de59dd510689001ddb8098",
                  "inputField": {
                    "version": 1,
                    "_id": "5a37df8618b38e2069ee8657",
                    "optional": false,
                    "placeholderImage":
                        "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+6.png",
                    "placeholderText": "First Name",
                    "subType": "firstName",
                    "type": "text",
                    "id": "5a37df8618b38e2069ee8657"
                  },
                  "value": "Test",
                  "__v": 0,
                  "id": "62de59dd510689001ddb8098"
                },
                {
                  "_id": "62de59dd510689001ddb8099",
                  "inputField": {
                    "version": 1,
                    "_id": "5a37dfa018b38e2069ee8658",
                    "optional": false,
                    "placeholderImage":
                        "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+6.png",
                    "placeholderText": "Last Name",
                    "subType": "lastName",
                    "type": "text",
                    "id": "5a37dfa018b38e2069ee8658"
                  },
                  "value": "Test",
                  "__v": 0,
                  "id": "62de59dd510689001ddb8099"
                },
                {
                  "_id": "62de59dd510689001ddb809a",
                  "inputField": {
                    "version": 1,
                    "_id": "5a37e00918b38e2069ee8659",
                    "optional": false,
                    "placeholderImage":
                        "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/cake.png",
                    "placeholderText": "Date of Birth",
                    "subType": "birthdate",
                    "type": "date",
                    "id": "5a37e00918b38e2069ee8659"
                  },
                  "value": "2004-07-01",
                  "__v": 0,
                  "id": "62de59dd510689001ddb809a"
                },
                {
                  "_id": "62de59dd510689001ddb809b",
                  "inputField": {
                    "version": 1,
                    "_id": "5a37e03018b38e2069ee865a",
                    "optional": false,
                    "placeholderImage":
                        "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+5.png",
                    "placeholderText": "Gender",
                    "subType": "gender",
                    "type": "dropdown",
                    "id": "5a37e03018b38e2069ee865a"
                  },
                  "value": "female",
                  "__v": 0,
                  "id": "62de59dd510689001ddb809b"
                }
              ],
              "createdAt": "2022-07-25T08:52:45.642Z",
              "sortDate": "2022-07-25T08:52:45.695Z",
              "isDeleted": false,
              "isOpen": false,
              "isInitialized": false,
              "canBeDeleted": false,
              "id": "62de59dd510689001ddb8090",
              "story": {
                "questions": [
                  {
                    "clientInformation": {
                      "birthdate": "1989-01-07T00:00:00.000Z",
                      "zodiac": "capricorn",
                      "gender": "female",
                      "country": "DE"
                    },
                    "startAnswerDate": "2023-01-03T15:53:46.129Z",
                    "_id": "62de59dd510689001ddb8094",
                    "type": "RITUAL",
                    "content": "Test",
                    "attachments": [],
                    "status": "OPEN",
                    "createdAt": "2022-07-25T08:52:45.695Z",
                    "updatedAt": "2023-01-03T15:53:46.134Z"
                  }
                ],
                "answers": []
              },
              "updatedAt": "2022-07-25T08:52:45.705Z",
              "clientInformation": {
                "birthdate": "1989-02-07T00:00:00.000Z",
                "zodiac": "aquarius",
                "gender": "non_gender",
                "country": "BR",
                "firstName": "Hope",
                "lastName": "Fortunikovna"
              },
              "clientID": "5f5224f45a1f7c001c99763c"
            });
          });

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de59dd510689001ddb8090',
              question: ritualQuestion,
            ),
          );

          expect(find.byType(RitualInfoCardWidget), findsOneWidget);
        },
      );
    },
  );
}

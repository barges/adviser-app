import 'package:dio/dio.dart';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_messages_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/ritual_info_card_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/gallery/gallery_pictures_screen.dart';
import 'package:shared_advisor_interface/presentation/services/audio_player_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/sound/sound_record_service.dart';

import '../../widget_tester_extension.dart';
import '../mocked_classes/mocked_classes.mocks.dart';
import 'chat_screen_test_chat_items.dart';
import 'chat_screen_test_responses.dart';
import 'fake_chat_screen.dart';

Future<void> pumpChatScreen({
  required WidgetTester tester,
  required MainCubit mainCubit,
  required ChatsRepository chatsRepository,
  required ConnectivityService connectivityService,
  required ChatScreenArguments chatScreenArguments,
  required SoundRecordService soundRecordService,
  required AudioPlayerService audioPlayerService,
}) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: mainCubit,
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == AppRoutes.galleryPictures) {
                return GetPageRoute(
                    page: () => const GalleryPicturesScreen(),
                    settings: settings);
              }
              return GetPageRoute(
                  page: () => FakeChatScreen(
                        chatsRepository: chatsRepository,
                        connectivityService: connectivityService,
                        soundRecordService: soundRecordService,
                        audioPlayerService: audioPlayerService,
                      ),
                  settings: RouteSettings(arguments: chatScreenArguments));
            },
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
}

void main() {
  late ChatsRepository mockChatsRepository;
  late MockConnectivityService mockConnectivityService;
  late MockDataCachingManager mockCacheManager;
  late MockSoundRecordService mockSoundRecordService;
  late MockDefaultCacheManager mockDefaultCacheManager;
  late MockAudioPlayerService mockAudioPlayerService;
  late MainCubit mainCubit;
  late Dio dio;
  late DioAdapter dioAdapter;

  LiveTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  setUpAll(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    mockSoundRecordService = MockSoundRecordService();
    mockAudioPlayerService = MockAudioPlayerService();
    mockDefaultCacheManager = MockDefaultCacheManager();

    when(mockDefaultCacheManager.getFileStream(argThat(anything)))
        .thenAnswer((realInvocation) {
      const LocalFileSystem fileSystem = LocalFileSystem();
      const String fileName = './test/assets/test_placeholder.png';

      final file = fileSystem.file(fileName);
      logger.d(realInvocation.positionalArguments[0]);

      return Stream.value(FileInfo(
        file, // Path to the asset
        FileSource.Cache, // Simulate a cache hit
        DateTime(2050), // Very long validity
        realInvocation.positionalArguments[0], // Source url
      ));
    });

    dioAdapter.onGet('/v2/clients/63bbab1b793423001e28722e', (server) {
      server.reply(200, ChatScreenTestResponses.publicQuestionClient);
    });

    dioAdapter.onGet(
      '/notes',
      data: {'clientID': '63bbab1b793423001e28722e'},
      (server) {
        server.reply(200, ChatScreenTestResponses.emptyClientNote);
      },
    );

    dioAdapter.onGet('/questions/single/63bbab87ea0df2001dce8630', (server) {
      server.reply(200, ChatScreenTestResponses.publicQuestion);
    });

    dioAdapter.onGet('/v2/clients/5f5224f45a1f7c001c99763c', (server) {
      server.reply(200, ChatScreenTestResponses.ritualQuestionClient);
    });

    getIt.registerLazySingleton<CustomerRepository>(
        () => CustomerRepositoryImpl(CustomerApi(dio)));

    getIt.registerSingleton<BaseCacheManager>(mockDefaultCacheManager);
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
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments());

        await tester.pumpAndSettle();

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
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
                clientIdFromPush: '63bbab1b793423001e28722e')));

        await tester.pumpAndSettle();

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
          soundRecordService: mockSoundRecordService,
          audioPlayerService: mockAudioPlayerService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
            question: ChatScreenTestChatItems.publicQuestion,
          ),
        );

        await tester.pumpAndSettle();

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
          soundRecordService: mockSoundRecordService,
          audioPlayerService: mockAudioPlayerService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
            question: ChatScreenTestChatItems.publicQuestion,
          ),
        );

        await tester.pumpAndSettle();

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
          soundRecordService: mockSoundRecordService,
          audioPlayerService: mockAudioPlayerService,
          chatScreenArguments: ChatScreenArguments(
            publicQuestionId: '63bbab87ea0df2001dce8630',
            question: ChatScreenTestChatItems.publicQuestion,
          ),
        );

        await tester.pumpAndSettle();

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
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: ChatScreenTestChatItems.publicQuestion,
            ),
          );

          await tester.pumpAndSettle();

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
              server.reply(200, ChatScreenTestResponses.successTakenQuestion);
            },
          );

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: ChatScreenTestChatItems.publicQuestion,
            ),
          );

          await tester.pumpAndSettle();

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
              server.reply(
                409,
                ChatScreenTestResponses.questionWasAlreadyTaken,
              );
            },
          );

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: ChatScreenTestChatItems.publicQuestion,
            ),
          );

          await tester.pumpAndSettle();

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
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: ChatScreenTestChatItems.publicQuestion,
            ),
          );

          await tester.pumpAndSettle();

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
        'should be displayed without images'
        ' if active question on Chat screen is love crush reading ritual',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de59dd510689001ddb8090',
              (server) {
            server.reply(
              200,
              ChatScreenTestResponses.ritualLoveCrushReadingQuestion,
            );
          });

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de59dd510689001ddb8090',
              question: ChatScreenTestChatItems.ritualLoveCrushReadingQuestion,
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(RitualInfoCardWidget), findsOneWidget);
          expect(
              find.descendant(
                of: find.byType(RitualInfoCardWidget),
                matching: find.byType(AppImageWidget),
              ),
              findsNothing);
        },
      );

      testWidgets(
        'should be displayed with images'
        ' if active question on Chat screen is aura reading ritual',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de35bcb584e9001e590d7d',
              (server) {
            server.reply(
              200,
              ChatScreenTestResponses.ritualAuraReadingQuestion,
            );
          });

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de35bcb584e9001e590d7d',
              question: ChatScreenTestChatItems.ritualAuraReadingQuestion,
            ),
          );

          await tester.pumpNtimes(times: 100);

          expect(find.byType(RitualInfoCardWidget), findsOneWidget);
          expect(find.byType(AppImageWidget), findsNWidgets(2));
        },
      );

      testWidgets(
        'should open picture in full-screen'
        ' if user clicks on image',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de35bcb584e9001e590d7d',
              (server) {
            server.reply(
              200,
              ChatScreenTestResponses.ritualAuraReadingQuestion,
            );
          });

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de35bcb584e9001e590d7d',
              question: ChatScreenTestChatItems.ritualAuraReadingQuestion,
            ),
          );
          await tester.pumpNtimes(times: 100);

          final Finder firstRitualInfoCardImage = find
              .descendant(
                  of: find.byType(RitualInfoCardWidget),
                  matching: find.byType(AppImageWidget),
                  skipOffstage: false)
              .first;

          expect(firstRitualInfoCardImage.hitTestable(), findsOneWidget);

          await tester.ensureVisible(firstRitualInfoCardImage);
          await tester.pumpNtimes(times: 50);
          await tester.tap(firstRitualInfoCardImage);
          await tester.pumpNtimes(times: 100);

          expect(find.byType(GalleryPicturesScreen), findsOneWidget);
        },
      );
    },
  );

  group(
    'ChatTextInputWidget',
    () {
      testWidgets(
        'should have input text field, attach picture button and send button'
        ' when user opens active chat',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de59dd510689001ddb8090',
              (server) {
            server.reply(
              200,
              ChatScreenTestChatItems.ritualLoveCrushReadingQuestion,
            );
          });

          await pumpChatScreen(
            tester: tester,
            mainCubit: mainCubit,
            chatsRepository: mockChatsRepository,
            connectivityService: mockConnectivityService,
            soundRecordService: mockSoundRecordService,
            audioPlayerService: mockAudioPlayerService,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de59dd510689001ddb8090',
              question: ChatScreenTestChatItems.ritualLoveCrushReadingQuestion,
            ),
          );

          await tester.pumpAndSettle();

          expect(
              find.descendant(
                  of: find.byType(ChatTextInputWidget),
                  matching: find.byType(SvgPicture)),
              findsNWidgets(2));

          expect(
              find.descendant(
                  of: find.byType(ChatTextInputWidget),
                  matching: find.byType(TextField)),
              findsOneWidget);

          expect(
              find.descendant(
                  of: find.byType(ChatTextInputWidget),
                  matching: find.byType(AppIconGradientButton)),
              findsOneWidget);
        },
      );
    },
  );
}
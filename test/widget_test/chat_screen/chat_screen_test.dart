import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/network/api/sessions_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/repositories/zodiac_sessions_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/zodiac_sessions_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/widgets/notes_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/widgets/question_properties_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/audio_players/chat_recorded_player_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/audio_recorder/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/empty_history_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/sliver_history_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/ritual_info_card_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/gallery/gallery_pictures_screen.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_player_service.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_recorder_service.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

import '../../common_variables.dart';
import '../../widget_tester_extension.dart';
import '../mocked_classes/mocked_classes.mocks.dart';
import 'chat_screen_test_chat_items.dart';
import 'chat_screen_test_responses.dart';
import 'fake_chat_screen.dart';

Future<void> pumpChatScreen({
  required WidgetTester tester,
  required ChatScreenArguments chatScreenArguments,
}) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: testGetIt.get<MainCubit>(),
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
                  page: () => const FakeChatScreen(),
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
  late MockAudioRecorderService mockAudioRecorderService;
  late MockAudioPlayerService mockAudioPlayerService;
  late MockCheckPermissionService mockCheckPermissionService;
  late MainCubit mainCubit;
  late Dio dio;
  late DioAdapter dioAdapter;

  LiveTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  const MethodChannel('storage_space')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getFreeSpace') {
      return Future.value(4989227008);
    }
    if (methodCall.method == 'getTotalSpace') {
      return Future.value(6240665600);
    }
    return null;
  });

  const MethodChannel('flutter.baseflow.com/permissions/methods')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'checkPermissionStatus') {
      return 1;
    }
    return null;
  });

  const MethodChannel('flutter_media_metadata')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'MetadataRetriever') {
      return {
        'metadata': {
          'albumName': null,
          'trackNumber': null,
          'year': '20230203T140429.000Z',
          'trackArtistNames': null,
          'albumArtistName': null,
          'bitrate': 16000,
          'trackName': null,
          'mimeType': 'audio/mp4',
          'albumLength': null,
          'writerName': null,
          'discNumber': null,
          'authorName': null,
          'genre': null,
          'trackDuration': 16192
        },
        'albumArt': null,
        'filePath':
            '/data/user/0/com.questico.fortunica.readerapp/cache/dd3aa41e-bfe1-4734-aecd-02c6854d1d48.m4a'
      };
    }
    return null;
  });

  const MethodChannel('flutter_keyboard_visibility')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'listen') {
      return false;
    }
    return null;
  });

  setUpAll(() {
    GetIt.instance.allowReassignment = true;
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    mockAudioRecorderService = MockAudioRecorderService();
    mockAudioPlayerService = MockAudioPlayerService();

    when(mockAudioRecorderService.stopRecorder()).thenAnswer(
        (realInvocation) => Future.value('test/assets/test_audio1.mp3'));

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

    dioAdapter.onGet('/experts/validation/answer', (server) {
      server.reply(200, {});
    });

    testGetIt.registerLazySingleton<CustomerRepository>(
        () => CustomerRepositoryImpl(CustomerApi(dio)));

    testGetIt.registerLazySingleton<AudioRecorderService>(
        () => mockAudioRecorderService);
    testGetIt.registerLazySingleton<AudioPlayerService>(
        () => mockAudioPlayerService);
  });

  setUp(() {
    dioAdapter.onPost(
      '/questions/take',
      (server) {
        server.reply(200, ChatScreenTestResponses.successTakenQuestion);
      },
    );

    dioAdapter.onGet('/v2/clients/63bbab1b793423001e28722e', (server) {
      server.reply(
          200,
          ChatScreenTestResponses
              .publicQuestionClientWithoutQuestionProperties);
    });

    mockChatsRepository = ChatsRepositoryImpl(ChatsApi(dio));
    mockConnectivityService = MockConnectivityService();
    mockCacheManager = MockDataCachingManager();
    mockCheckPermissionService = MockCheckPermissionService();

    mainCubit = MainCubit(mockCacheManager, mockConnectivityService);

    when(mockConnectivityService.checkConnection())
        .thenAnswer((realInvocation) => Future.value(true));

    testGetIt.registerLazySingleton<CheckPermissionService>(
        () => mockCheckPermissionService);
    testGetIt.registerLazySingleton<ChatsRepository>(() => mockChatsRepository);
    testGetIt.registerLazySingleton<ConnectivityService>(
        () => mockConnectivityService);
    testGetIt.registerLazySingleton<CachingManager>(() => mockCacheManager);
    testGetIt.registerLazySingleton<MainCubit>(() => mainCubit);

    when(mockAudioRecorderService.isRecording).thenReturn(false);
    when(mockAudioRecorderService.stateStream).thenAnswer((_) =>
        Stream.value(RecorderServiceState(SoundRecorderState.isStopped)));
  });

  group('ChooseOptionWidget', () {
    testWidgets(
      'should be displayed on Chat screen',
      (WidgetTester tester) async {
        await pumpChatScreen(
            tester: tester,
            chatScreenArguments: ChatScreenArguments(
                clientIdFromPush: '63bbab1b793423001e28722e'));

        await tester.pumpAndSettle();

        expect(find.byType(ChooseOptionWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should have 2 options and HistoryWidget should be displayed'
      ' if there are any question ids in ChatScreenArguments',
      (WidgetTester tester) async {
        await pumpChatScreen(
            tester: tester,
            chatScreenArguments: ChatScreenArguments(
                clientIdFromPush: '63bbab1b793423001e28722e'));

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
          await pumpChatScreen(
            tester: tester,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: ChatScreenTestChatItems.publicQuestion,
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(AppElevatedButton));
          await tester.pumpAndSettle();

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
          final Finder ritualInfoCardImageGesture = find.descendant(
              of: firstRitualInfoCardImage,
              matching: find.byType(GestureDetector));

          expect(ritualInfoCardImageGesture.hitTestable(), findsOneWidget);

          await tester.tap(ritualInfoCardImageGesture);
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
              ChatScreenTestResponses.ritualLoveCrushReadingQuestion,
            );
          });

          await pumpChatScreen(
            tester: tester,
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
                  matching:
                      find.byWidgetPredicate((widget) => widget is TextField)),
              findsOneWidget);

          expect(
              find.descendant(
                  of: find.byType(ChatTextInputWidget),
                  matching: find.byType(AppIconGradientButton)),
              findsOneWidget);
        },
      );

      testWidgets(
        'should have AppIconGradientButton with microphone icon'
        ' if question that advisor should answer is not public',
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
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de59dd510689001ddb8090',
              question: ChatScreenTestChatItems.ritualLoveCrushReadingQuestion,
            ),
          );

          await tester.pumpAndSettle();

          await tester.pumpNtimes(times: 50);
          Finder appIconGradientButton = find.descendant(
              of: find.byType(ChatTextInputWidget),
              matching: find.byType(AppIconGradientButton));

          String buttonIcon = (appIconGradientButton.evaluate().single.widget
                  as AppIconGradientButton)
              .icon;

          expect(appIconGradientButton, findsOneWidget);
          expect(buttonIcon, Assets.vectors.microphone.path);
        },
      );

      testWidgets(
        'should have AppIconGradientButton with send icon'
        ' if question that advisor should answer is public',
        (WidgetTester tester) async {
          await pumpChatScreen(
            tester: tester,
            chatScreenArguments: ChatScreenArguments(
              publicQuestionId: '63bbab87ea0df2001dce8630',
              question: ChatScreenTestChatItems.publicQuestion,
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(AppElevatedButton));
          await tester.pump();

          Finder appIconGradientButton = find.descendant(
              of: find.byType(ChatTextInputWidget),
              matching: find.byType(AppIconGradientButton));

          String buttonIcon = (appIconGradientButton.evaluate().single.widget
                  as AppIconGradientButton)
              .icon;

          expect(appIconGradientButton, findsOneWidget);
          expect(buttonIcon, Assets.vectors.send.path);
        },
      );

      testWidgets(
        'should have ChatRecordingWidget'
        ' if user is recording audio',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de59dd510689001ddb8090',
              (server) {
            server.reply(
              200,
              ChatScreenTestResponses.ritualLoveCrushReadingQuestion,
            );
          });

          when(mockAudioRecorderService.isRecording).thenReturn(true);
          when(mockAudioRecorderService.stateStream).thenAnswer((_) =>
              Stream.value(
                  RecorderServiceState(SoundRecorderState.isRecording)));

          await pumpChatScreen(
            tester: tester,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de59dd510689001ddb8090',
              question: ChatScreenTestChatItems.ritualLoveCrushReadingQuestion,
            ),
          );

          await tester.pumpAndSettle();

          await tester.pumpNtimes(times: 50);
          /*Finder appIconGradientButton = find.descendant(
              of: find.byType(ChatTextInputWidget),
              matching: find.byType(AppIconGradientButton));

          await tester.tap(appIconGradientButton);
          await tester.pump();*/

          expect(find.byType(ChatRecordingWidget), findsOneWidget);
        },
      );

      testWidgets(
        'should be replaced with ChatRecordedWidget'
        ' if user taps on microphone button'
        ' and then stopped recording audio',
        (WidgetTester tester) async {
          dioAdapter.onGet('/rituals/single/62de59dd510689001ddb8090',
              (server) {
            server.reply(
              200,
              ChatScreenTestResponses.ritualLoveCrushReadingQuestion,
            );
          });

          when(mockAudioRecorderService.isRecording).thenReturn(true);
          when(mockAudioRecorderService.stateStream).thenAnswer((_) =>
              Stream.value(
                  RecorderServiceState(SoundRecorderState.isRecording)));

          File audioFile = File('test/assets/test_audio.mp3');
          audioFile.copy('test/assets/test_audio1.mp3');

          await pumpChatScreen(
            tester: tester,
            chatScreenArguments: ChatScreenArguments(
              ritualID: '62de59dd510689001ddb8090',
              question: ChatScreenTestChatItems.ritualLoveCrushReadingQuestion,
            ),
          );

          await tester.pumpAndSettle();
          await tester.pumpNtimes(times: 50);

          Finder stopRecordingButton =
              find.byKey(const Key('stopRecordingButton'));

          expect(stopRecordingButton, findsOneWidget);

          await tester.tap(stopRecordingButton);
          await tester.pumpNtimes(times: 100);

          expect(find.byType(ChatRecordedPlayerWidget), findsOneWidget);
        },
      );
    },
  );

  group('Send button', () {
    testWidgets(
        'should be inactive '
        'if user try to answer public question with less then 250 characters',
        (tester) async {
      await pumpChatScreen(
        tester: tester,
        chatScreenArguments: ChatScreenArguments(
          publicQuestionId: '63bbab87ea0df2001dce8630',
          question: ChatScreenTestChatItems.publicQuestion,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byWidgetPredicate((widget) => widget is TextField),
          'answer with less then 250 characters');
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Opacity &&
              widget.opacity == 0.4 &&
              widget.child is AppIconGradientButton,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'should become active '
        'if user types 250 or more symbols in textfield', (tester) async {
      await pumpChatScreen(
        tester: tester,
        chatScreenArguments: ChatScreenArguments(
          publicQuestionId: '63bbab87ea0df2001dce8630',
          question: ChatScreenTestChatItems.publicQuestion,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      String enteredText = '';
      for (int i = 0; i < 250; i++) {
        enteredText += 'a';
      }
      await tester.enterText(
          find.byWidgetPredicate((widget) => widget is TextField), enteredText);
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Opacity &&
              widget.opacity == 1.0 &&
              widget.child is AppIconGradientButton,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'should show dialog '
        'if user clicks on active button', (tester) async {
      await pumpChatScreen(
        tester: tester,
        chatScreenArguments: ChatScreenArguments(
          publicQuestionId: '63bbab87ea0df2001dce8630',
          question: ChatScreenTestChatItems.publicQuestion,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      String enteredText = '';
      for (int i = 0; i < 250; i++) {
        enteredText += 'a';
      }
      await tester.enterText(
          find.byWidgetPredicate((widget) => widget is TextField), enteredText);
      await tester.pump();

      await tester.tap(find.byType(AppIconGradientButton));
      await tester.pump();

      expect(
          find.text(
            S.current.pleaseConfirmThatYourAnswerIsReadyToBeSent,
          ),
          findsOneWidget);
    });

    testWidgets(
        'should not send message and text field should be displayed on screen'
        'if user clicks on active button,'
        ' but on opened dialog user clicks on cancel button', (tester) async {
      await pumpChatScreen(
        tester: tester,
        chatScreenArguments: ChatScreenArguments(
          publicQuestionId: '63bbab87ea0df2001dce8630',
          question: ChatScreenTestChatItems.publicQuestion,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      String enteredText = '';
      for (int i = 0; i < 250; i++) {
        enteredText += 'a';
      }
      await tester.enterText(
          find.byWidgetPredicate((widget) => widget is TextField), enteredText);
      await tester.pump();

      await tester.tap(find.byType(AppIconGradientButton));
      await tester.pump();

      expect(
          find.byWidgetPredicate(
              (widget) => widget is CupertinoAlertDialog || widget is Dialog),
          findsOneWidget);

      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data?.toLowerCase() == S.current.cancel.toLowerCase(),
        ),
      );
      await tester.pump();

      expect(
          find.byWidgetPredicate(
              (widget) => widget is CupertinoAlertDialog || widget is Dialog),
          findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is TextField),
          findsOneWidget);
    });

    testWidgets(
        'should send message and text field should not be displayed on screen,'
        ' but sended message should be displayed on a screen as a new ChatItemWidget'
        ' if user clicks on active button,'
        ' and on opened dialog user clicks on "confirm send" button',
        (tester) async {
      String enteredText = '';
      for (int i = 0; i < 250; i++) {
        enteredText += 'a';
      }
      dioAdapter.onPost('/answers', (server) {
        server.reply(
            200,
            ChatScreenTestChatItems.publicAnswer
                .copyWith(content: enteredText));
      });

      await pumpChatScreen(
        tester: tester,
        chatScreenArguments: ChatScreenArguments(
          publicQuestionId: '63bbab87ea0df2001dce8630',
          question: ChatScreenTestChatItems.publicQuestion,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppElevatedButton));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byWidgetPredicate((widget) => widget is TextField), enteredText);
      await tester.pump();

      await tester.tap(find.byType(AppIconGradientButton));
      await tester.pump();

      expect(
          find.byWidgetPredicate(
              (widget) => widget is CupertinoAlertDialog || widget is Dialog),
          findsOneWidget);

      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data?.toLowerCase() == S.current.confirm.toLowerCase(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
              (widget) => widget is CupertinoAlertDialog || widget is Dialog),
          findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is TextField),
          findsNothing);
      expect(find.widgetWithText(ChatItemWidget, enteredText), findsOneWidget);
    });
  });

  group('HistoryTab', () {
    testWidgets(
        'should be displayed'
        ' if current tab in ChooseOptionWidget is "History"', (tester) async {
      await pumpChatScreen(
          tester: tester,
          chatScreenArguments: ChatScreenArguments(
              clientIdFromPush: '63bbab1b793423001e28722e'));
      await tester.pumpAndSettle();

      expect(find.text('History'), findsOneWidget);

      await tester.tap(find.widgetWithText(GestureDetector, 'History'));
      await tester.pump();

      expect(find.byType(HistoryWidget), findsOneWidget);
    });

    testWidgets(
        'should be displayed with EmptyHistoryListWidget'
        ' if History list is empty', (tester) async {
      dioAdapter.onGet('/experts/conversations/history', (server) {
        server.reply(200, ChatScreenTestResponses.emptyHistoryResponse);
      }, queryParameters: {
        'clientId': '63bbab1b793423001e28722e',
        'limit': 15
      });

      await pumpChatScreen(
          tester: tester,
          chatScreenArguments: ChatScreenArguments(
              clientIdFromPush: '63bbab1b793423001e28722e'));
      await tester.pumpNtimes(times: 100);

      expect(find.byType(EmptyHistoryListWidget), findsOneWidget);
    });

    testWidgets(
        'should be displayed with SliverHistoryListWidget'
        ' if History list is not empty', (tester) async {
      dioAdapter.onGet('/experts/conversations/history', (server) {
        server.reply(200, ChatScreenTestResponses.historyResponse);
      }, queryParameters: {
        'clientId': '63bbab1b793423001e28722e',
        'limit': 15
      });

      await pumpChatScreen(
          tester: tester,
          chatScreenArguments: ChatScreenArguments(
              clientIdFromPush: '63bbab1b793423001e28722e'));
      await tester.pumpNtimes(times: 100);

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('CustomerProfileWidget', () {
    testWidgets('should be displayed with UserAvatar and NotesWidget',
        (tester) async {
      await pumpChatScreen(
          tester: tester,
          chatScreenArguments: ChatScreenArguments(
              clientIdFromPush: '63bbab1b793423001e28722e'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GestureDetector, 'Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(UserAvatar), findsOneWidget);
      expect(find.byType(NotesWidget), findsOneWidget);
    });

    testWidgets(
        'should be displayed without QuestionPropertiesWidget'
        ' if CustomerInfo advisorMatch is empty', (tester) async {
      dioAdapter.onGet('/v2/clients/63bbab1b793423001e28722e', (server) {
        server.reply(
            200,
            ChatScreenTestResponses
                .publicQuestionClientWithoutQuestionProperties);
      });

      await pumpChatScreen(
          tester: tester,
          chatScreenArguments: ChatScreenArguments(
              clientIdFromPush: '63bbab1b793423001e28722e'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GestureDetector, 'Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(QuestionPropertiesWidget), findsNothing);
    });

    testWidgets(
        'should be displayed with QuestionPropertiesWidget'
        ' if CustomerInfo advisorMatch is not empty', (tester) async {
      dioAdapter.onGet('/v2/clients/63bbab1b793423001e28722e', (server) {
        server.reply(200,
            ChatScreenTestResponses.publicQuestionClientWithQuestionProperties);
      });

      await pumpChatScreen(
          tester: tester,
          chatScreenArguments: ChatScreenArguments(
              clientIdFromPush: '63bbab1b793423001e28722e'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GestureDetector, 'Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(QuestionPropertiesWidget), findsOneWidget);
    });
  });
}

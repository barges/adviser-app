// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http_mock_adapter/http_mock_adapter.dart';
// import 'package:mockito/annotations.dart';
// import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
// import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
// import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
// import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
// import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
// import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';

// const String emptyString = '';
// const int limit = 10;

// const String getStoryRoute = '/stories';
// const String getPublicQuestionsRoute = '/experts/questions/public';
// const String getConversationsListRoute = '/experts/conversations';
// const String getHistoryListRoute = '/experts/conversations/history';

// @GenerateMocks([])
// void main() {
//   late Dio dio;
//   late DioAdapter dioAdapter;
//   late ChatsApi chatsApi;
//   late ChatsRepository chatsRepository;

//   setUpAll(() {
//     dio = Dio();
//     dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
//     chatsApi = ChatsApi(dio);
//     chatsRepository = ChatsRepositoryImpl(chatsApi);
//   });

//   group('Get story', () {
//     test(
//         'returns an ConversationsStoryResponse'
//         ' if the http call completes successfully', () async {
//       dioAdapter.onGet(
//         getStoryRoute,
//         (server) => server.reply(
//           200,
//           {},
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         await chatsRepository.getStory(storyID: emptyString),
//         isA<ConversationsStoryResponse>(),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but story was not found', () async {
//       dioAdapter.onGet(
//         getStoryRoute,
//         (server) => server.reply(
//           404,
//           {
//             'localizedMessage': 'Story was not found',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getStory(storyID: emptyString),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'Story was not found' &&
//                 e.response?.statusCode == 404,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but permission denieds', () async {
//       dioAdapter.onGet(
//         getStoryRoute,
//         (server) => server.reply(
//           403,
//           {
//             'localizedMessage': 'Permission denied',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getStory(storyID: emptyString),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'Permission denied' &&
//                 e.response?.statusCode == 403,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but some of parameters are invalid',
//         () async {
//       dioAdapter.onGet(
//         getStoryRoute,
//         (server) => server.reply(
//           400,
//           {
//             'localizedMessage': 'Validation error',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getStory(storyID: emptyString),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'Validation error' &&
//                 e.response?.statusCode == 400,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but there are server error', () async {
//       dioAdapter.onGet(
//         getStoryRoute,
//         (server) => server.reply(
//           500,
//           {
//             'localizedMessage': 'ServerError',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getStory(storyID: emptyString),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'ServerError' &&
//                 e.response?.statusCode == 500,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes with connection timeout', () async {
//       dioAdapter.onGet(
//         getStoryRoute,
//         (server) => server.throws(
//           408,
//           DioError(
//               type: DioErrorType.connectTimeout,
//               requestOptions: RequestOptions(path: emptyString)),
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getStory(storyID: emptyString),
//         throwsA(
//           predicate(
//             (e) => e is DioError && e.type == DioErrorType.connectTimeout,
//           ),
//         ),
//       );
//     });
//   });

//   group('Get Public Questions', () {
//     test(
//         'returns an ConversationsStoryResponse'
//         ' if the http call completes successfully', () async {
//       dioAdapter.onGet(
//         getPublicQuestionsRoute,
//         (server) => server.reply(
//           200,
//           {},
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );
//       expect(
//         await chatsRepository.getPublicQuestions(limit: limit),
//         isA<QuestionsListResponse>(),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but some of parameters are invalid',
//         () async {
//       dioAdapter.onGet(
//         getPublicQuestionsRoute,
//         (server) => server.reply(
//           400,
//           {
//             'localizedMessage': 'Bad request',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getPublicQuestions(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'Bad request' &&
//                 e.response?.statusCode == 400,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but expert has not completed account',
//         () async {
//       dioAdapter.onGet(
//         getPublicQuestionsRoute,
//         (server) => server.reply(
//           428,
//           {
//             'localizedMessage': 'Expert has not completed account',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getPublicQuestions(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'Expert has not completed account' &&
//                 e.response?.statusCode == 428,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but an expert is legal blocked',
//         () async {
//       dioAdapter.onGet(
//         getPublicQuestionsRoute,
//         (server) => server.reply(
//           451,
//           {
//             'localizedMessage': 'An expert is legal blocked',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getPublicQuestions(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'An expert is legal blocked' &&
//                 e.response?.statusCode == 451,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but an server error occurs', () async {
//       dioAdapter.onGet(
//         getPublicQuestionsRoute,
//         (server) => server.reply(
//           500,
//           {
//             'localizedMessage': 'ServerError',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getPublicQuestions(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'ServerError' &&
//                 e.response?.statusCode == 500,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes with connection timeout', () async {
//       dioAdapter.onGet(
//         getPublicQuestionsRoute,
//         (server) => server.throws(
//           408,
//           DioError(
//               type: DioErrorType.connectTimeout,
//               requestOptions: RequestOptions(path: emptyString)),
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getPublicQuestions(limit: limit),
//         throwsA(
//           predicate(
//             (e) => e is DioError && e.type == DioErrorType.connectTimeout,
//           ),
//         ),
//       );
//     });
//   });

//   group('Get Conversations List', () {
//     test(
//         'returns an QuestionsListResponse'
//         ' if the http call completes successfully', () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.reply(
//           200,
//           {},
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         await chatsRepository.getConversationsList(limit: limit),
//         isA<QuestionsListResponse>(),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but some of parameters are invalid',
//         () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.reply(
//           400,
//           {
//             'localizedMessage': 'Bad request',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getConversationsList(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'Bad request' &&
//                 e.response?.statusCode == 400,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but expert has taken public question',
//         () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.reply(
//           409,
//           {
//             'localizedMessage': 'Expert has taken public question',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getConversationsList(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'Expert has taken public question' &&
//                 e.response?.statusCode == 409,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but expert has not completed account',
//         () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.reply(
//           428,
//           {
//             'localizedMessage': 'Expert has not completed account',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getConversationsList(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'Expert has not completed account' &&
//                 e.response?.statusCode == 428,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but an expert is legal blocked',
//         () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.reply(
//           451,
//           {
//             'localizedMessage': 'An expert is legal blocked',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getConversationsList(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'An expert is legal blocked' &&
//                 e.response?.statusCode == 451,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but an server error occurs', () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.reply(
//           500,
//           {
//             'localizedMessage': 'ServerError',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getConversationsList(limit: limit),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'ServerError' &&
//                 e.response?.statusCode == 500,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes with connection timeout', () async {
//       dioAdapter.onGet(
//         getConversationsListRoute,
//         (server) => server.throws(
//           408,
//           DioError(
//               type: DioErrorType.connectTimeout,
//               requestOptions: RequestOptions(path: emptyString)),
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getConversationsList(limit: limit),
//         throwsA(
//           predicate(
//             (e) => e is DioError && e.type == DioErrorType.connectTimeout,
//           ),
//         ),
//       );
//     });
//   });

//   group('Get History List', () {
//     test(
//         'returns an HistoryResponse'
//         ' if the http call completes successfully', () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.reply(
//           200,
//           {},
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         isA<HistoryResponse>(),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but some of parameters are invalid',
//         () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.reply(
//           400,
//           {
//             'localizedMessage': 'Bad request',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'Bad request' &&
//                 e.response?.statusCode == 400,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but expert has taken public question',
//         () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.reply(
//           409,
//           {
//             'localizedMessage': 'Expert has taken public question',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'Expert has taken public question' &&
//                 e.response?.statusCode == 409,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but expert has not completed account',
//         () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.reply(
//           428,
//           {
//             'localizedMessage': 'Expert has not completed account',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'Expert has not completed account' &&
//                 e.response?.statusCode == 428,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but an expert is legal blocked',
//         () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.reply(
//           451,
//           {
//             'localizedMessage': 'An expert is legal blocked',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] ==
//                     'An expert is legal blocked' &&
//                 e.response?.statusCode == 451,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes, but an server error occurs', () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.reply(
//           500,
//           {
//             'localizedMessage': 'ServerError',
//           },
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is DioError &&
//                 e.response?.data['localizedMessage'] == 'ServerError' &&
//                 e.response?.statusCode == 500,
//           ),
//         ),
//       );
//     });

//     test(
//         'returns an DioError'
//         ' if the http call completes with connection timeout', () async {
//       dioAdapter.onGet(
//         getHistoryListRoute,
//         (server) => server.throws(
//           408,
//           DioError(
//               type: DioErrorType.connectTimeout,
//               requestOptions: RequestOptions(path: emptyString)),
//           // Reply would wait for one-sec before returning data.
//           delay: const Duration(seconds: 1),
//         ),
//       );

//       expect(
//         () async => await chatsRepository.getHistoryList(
//           clientId: emptyString,
//           limit: limit,
//         ),
//         throwsA(
//           predicate(
//             (e) => e is DioError && e.type == DioErrorType.connectTimeout,
//           ),
//         ),
//       );
//     });
//   });
// }

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:fortunica/data/models/chats/history.dart';
import 'package:fortunica/data/models/chats/story.dart';
import 'package:fortunica/data/models/enums/sessions_types.dart';
import 'package:fortunica/data/network/api/auth_api.dart';
import 'package:fortunica/data/network/api/chats_api.dart';
import 'package:fortunica/data/network/api/customer_api.dart';
import 'package:fortunica/data/network/requests/update_note_request.dart';
import 'package:fortunica/data/network/responses/conversations_story_response.dart';
import 'package:fortunica/data/network/responses/history_response.dart';
import 'package:fortunica/data/network/responses/login_response.dart';
import 'package:fortunica/data/network/responses/questions_list_response.dart';
import 'package:fortunica/data/network/responses/rituals_response.dart';
import 'package:fortunica/data/network/responses/update_note_response.dart';

const String emptyString = '';
const int limit = 10;

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late AuthApi authApi;
  late ChatsApi chatsApi;
  late CustomerApi customerApi;

  setUpAll(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    authApi = AuthApi(dio);
    chatsApi = ChatsApi(dio);
    customerApi = CustomerApi(dio);
  });

  group('AuthApi login()', () {
    test(
        'returns a LoginResponse'
        ' if server returns accessToken, that should be String?, as String ',
        () async {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          {'accessToken': 'someRandomAccessToken'},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await authApi.login(),
        predicate((value) =>
            value is LoginResponse &&
            value.accessToken == 'someRandomAccessToken'),
      );
    });

    test(
        'returns a LoginResponse'
        ' if server returns accessToken, that should be String?, as null',
        () async {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          {'accessToken': null},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await authApi.login(),
        predicate(
            (value) => value is LoginResponse && value.accessToken == null),
      );
    });

    test(
        'returns a LoginResponse'
        ' if server doesn`t return accessToken at all', () async {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          {},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await authApi.login(),
        predicate(
            (value) => value is LoginResponse && value.accessToken == null),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns accessToken, that should be String?, as List',
        () async {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          {'accessToken': []},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await authApi.login(),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'List<dynamic>' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns accessToken, that should be String?, as int',
        () async {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          {'accessToken': 5},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await authApi.login(),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'int' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a DioError'
        ' if server returns String instead of Map', () async {
      dioAdapter.onPost(
        '/experts/login/app',
        (server) => server.reply(
          200,
          'some random string',
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await authApi.login(),
        throwsA(
          predicate(
            (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.error.toString() ==
                    "type 'String' is not a subtype of type 'Map<String, dynamic>?' in type cast",
          ),
        ),
      );
    });
  });

  group('ChatsApi getStory()', () {
    test(
        'returns a ConversationsStoryResponse'
        ' if server returns values with right types', () async {
      dioAdapter.onPost(
        '/stories',
        (server) => server.reply(
          200,
          {
            'questions': [],
            'answers': [],
            'clientID': '',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getStory(storyID: emptyString),
        predicate((value) =>
            value is ConversationsStoryResponse &&
            value.questions is List<ChatItem> &&
            value.questions!.isEmpty &&
            value.answers is List<ChatItem> &&
            value.answers!.isEmpty &&
            value.clientID == ''),
      );
    });

    test(
        'returns an empty ConversationsStoryResponse'
        ' if server returns empty Map', () async {
      dioAdapter.onPost(
        '/stories',
        (server) => server.reply(
          200,
          {},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getStory(storyID: emptyString),
        predicate((value) =>
            value is ConversationsStoryResponse &&
            value.questions == null &&
            value.answers == null &&
            value.clientID == null),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns questions, that should be List<ChatItem>?, as String',
        () async {
      dioAdapter.onPost(
        '/stories',
        (server) => server.reply(
          200,
          {
            'questions': 'questions',
            'answers': [],
            'clientID': '',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getStory(storyID: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'String' is not a subtype of type 'List<dynamic>?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns answers, that should be List<ChatItem>?, as String',
        () async {
      dioAdapter.onPost(
        '/stories',
        (server) => server.reply(
          200,
          {
            'questions': [],
            'answers': 'answers',
            'clientID': '',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getStory(storyID: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'String' is not a subtype of type 'List<dynamic>?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns clientID, that should be String?, as int',
        () async {
      dioAdapter.onPost(
        '/stories',
        (server) => server.reply(
          200,
          {
            'questions': [],
            'answers': [],
            'clientID': 25,
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getStory(storyID: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'int' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a DioError'
        ' if server returns String instead of Map', () async {
      dioAdapter.onPost(
        '/stories',
        (server) => server.reply(
          200,
          'some random string',
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getStory(storyID: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.error.toString() ==
                    "type 'String' is not a subtype of type 'Map<String, dynamic>?' in type cast",
          ),
        ),
      );
    });
  });

  group('ChatsApi getHistoryList()', () {
    test(
        'returns a HistoryResponse'
        ' if server returns values with right types', () async {
      dioAdapter.onGet(
        '/experts/conversations/history',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': true,
            'lastItem': 'lastItem',
            'hasBefore': true,
            'firstItem': 'firstItem',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        predicate((value) =>
            value is HistoryResponse &&
            value.history is List<History> &&
            value.history!.isEmpty &&
            value.hasMore == true &&
            value.lastItem == 'lastItem' &&
            value.hasBefore == true &&
            value.firstItem == 'firstItem'),
      );
    });

    test(
        'returns a HistoryResponse'
        ' if server returns values with right types, but not returns hasBefore and firstItem at all',
        () async {
      dioAdapter.onGet(
        '/experts/conversations/history',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': true,
            'lastItem': 'lastItem',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        predicate((value) =>
            value is HistoryResponse &&
            value.history is List<History> &&
            value.history!.isEmpty &&
            value.hasMore == true &&
            value.lastItem == 'lastItem' &&
            value.hasBefore == null &&
            value.firstItem == null),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns data, that should be List<dynamic>?, as int',
        () async {
      dioAdapter.onGet(
        '/experts/conversations/history',
        (server) => server.reply(
          200,
          {
            'data': 5,
            'hasMore': true,
            'lastItem': 'lastItem',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'int' is not a subtype of type 'List<dynamic>?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns hasMore, that should be bool?, as String',
        () async {
      dioAdapter.onGet(
        '/experts/conversations/history',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': 'true',
            'lastItem': 'lastItem',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'String' is not a subtype of type 'bool?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns lastItem, that should be String?, as List',
        () async {
      dioAdapter.onGet(
        '/experts/conversations/history',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': true,
            'lastItem': [],
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'List<dynamic>' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a DioError'
        ' if server returns String instead of Map', () async {
      dioAdapter.onGet(
        '/experts/conversations/history',
        (server) => server.reply(
          200,
          'String',
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        throwsA(
          predicate(
            (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.error.toString() ==
                    "type 'String' is not a subtype of type 'Map<String, dynamic>?' in type cast",
          ),
        ),
      );
    });
  });

  group('ChatsApi getRituals()', () {
    test(
        'returns an RitualsResponse'
        ' if server returns values with right types', () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          {
            'story': const Story(),
            'clientID': 'clientID',
            'clientName': 'clientName',
            'inputFieldsData': [],
            'identifier': 'tarot',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getRituals(id: emptyString),
        predicate(
          (value) =>
              value is RitualsResponse &&
              value.story == const Story() &&
              value.clientID == 'clientID' &&
              value.clientName == 'clientName' &&
              value.inputFieldsData!.isEmpty &&
              value.identifier == SessionsTypes.tarot,
        ),
      );
    });

    test(
        'returns an RitualsResponse'
        ' if server returns unknown identifier', () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          {
            'story': const Story(),
            'clientID': 'clientID',
            'clientName': 'clientName',
            'inputFieldsData': [],
            'identifier': 'undefined value',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getRituals(id: emptyString),
        predicate(
          (value) =>
              value is RitualsResponse &&
              value.story == const Story() &&
              value.clientID == 'clientID' &&
              value.clientName == 'clientName' &&
              value.inputFieldsData!.isEmpty &&
              value.identifier == SessionsTypes.undefined,
        ),
      );
    });

    test(
        'returns an RitualsResponse'
        ' if server returns identifier, that should be SessionsTypes, as int',
        () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          {
            'story': const Story(),
            'clientID': 'clientID',
            'clientName': 'clientName',
            'inputFieldsData': [],
            'identifier': 75,
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getRituals(id: emptyString),
        predicate(
          (value) =>
              value is RitualsResponse &&
              value.story == const Story() &&
              value.clientID == 'clientID' &&
              value.clientName == 'clientName' &&
              value.inputFieldsData!.isEmpty &&
              value.identifier == SessionsTypes.undefined,
        ),
      );
    });

    test(
        'returns an RitualsResponse'
        ' if server returns story as Map', () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          {
            'story': {},
            'clientID': 'clientID',
            'clientName': 'clientName',
            'inputFieldsData': [],
            'identifier': 'tarot',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getRituals(id: emptyString),
        predicate(
          (value) =>
              value is RitualsResponse &&
              value.story == const Story() &&
              value.clientID == 'clientID' &&
              value.clientName == 'clientName' &&
              value.inputFieldsData!.isEmpty &&
              value.identifier == SessionsTypes.tarot,
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns clientID and clientName, that should be String?, as int',
        () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          {
            'story': {},
            'clientID': 25,
            'clientName': 35,
            'inputFieldsData': [],
            'identifier': 'tarot',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getRituals(id: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'int' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a TypeError'
        ' if server returns inputFieldsData, that should be List<dynamic>?, as String',
        () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          {
            'story': {},
            'clientID': 'clientID',
            'clientName': 'clientName',
            'inputFieldsData': 'inputFieldData',
            'identifier': 'tarot',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getRituals(id: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'String' is not a subtype of type 'List<dynamic>?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a DioError'
        ' if server returns String instead of Map', () async {
      dioAdapter.onGet(
        '/rituals/single/',
        (server) => server.reply(
          200,
          "some random String",
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getRituals(id: emptyString),
        throwsA(
          predicate(
            (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.error.toString() ==
                    "type 'String' is not a subtype of type 'Map<String, dynamic>?' in type cast",
          ),
        ),
      );
    });
  });

  group('CustomerApi updateNoteToCustomer()', () {
    test(
        'returns an UpdateNoteResponse'
        ' if server returns values with right types', () async {
      dioAdapter.onPost(
        '/notes',
        (server) => server.reply(
          200,
          {
            '_id': 'id',
            'content': 'content',
            'expertID': 'expertID',
            'clientID': 'clientID',
            'searchKey': 'searchKey',
            'createdAt': 'createdAt',
            'updatedAt': 'updatedAt',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
          await customerApi.updateNoteToCustomer(
            const UpdateNoteRequest(
                clientID: emptyString, content: emptyString),
          ),
          const UpdateNoteResponse(
            id: 'id',
            content: 'content',
            expertID: 'expertID',
            clientID: 'clientID',
            searchKey: 'searchKey',
            createdAt: 'createdAt',
            updatedAt: 'updatedAt',
          ));
    });

    test(
        'throws a TypeError'
        ' if server returns value, that should be String?, as int', () async {
      dioAdapter.onPost(
        '/notes',
        (server) => server.reply(
          200,
          {
            '_id': 5,
            'content': 6,
            'expertID': 7,
            'clientID': 8,
            'searchKey': 9,
            'createdAt': 10,
            'updatedAt': 11,
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await customerApi.updateNoteToCustomer(
          const UpdateNoteRequest(clientID: emptyString, content: emptyString),
        ),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'int' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a DioError'
        ' if server returns String instead of Map', () async {
      dioAdapter.onGet(
        '/notes',
        (server) => server.reply(
          200,
          "some random String",
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await customerApi.updateNoteToCustomer(
          const UpdateNoteRequest(clientID: emptyString, content: emptyString),
        ),
        throwsA(
          predicate(
            (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.error.toString() ==
                    "type 'String' is not a subtype of type 'Map<String, dynamic>?' in type cast",
          ),
        ),
      );
    });
  });

  group('ChatsApi GetPublicQuestions', () {
    test(
        'returns an QuestionsListResponse'
        ' if server returns values with right types', () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': true,
            'limit': 10,
            'lastItem': 'lastItem',
            'lastId': 'lastId',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        await chatsApi.getPublicQuestions(limit: limit),
        isA<QuestionsListResponse>(),
      );
    });

    test(
        'returns an QuestionsListResponse'
        ' if server returns data, that should be List<dynamic>?, as int',
        () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          {
            'data': 10,
            'hasMore': true,
            'limit': 10,
            'lastItem': 'lastItem',
            'lastId': 'lastId',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getPublicQuestions(limit: limit),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'int' is not a subtype of type 'List<dynamic>?' in type cast",
          ),
        ),
      );
    });

    test(
        'returns an QuestionsListResponse'
        ' if server returns hasMore, that should be bool?, as String',
        () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': 'true',
            'limit': 10,
            'lastItem': 'lastItem',
            'lastId': 'lastId',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getPublicQuestions(limit: limit),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'String' is not a subtype of type 'bool?' in type cast",
          ),
        ),
      );
    });

    test(
        'returns an QuestionsListResponse'
        ' if server returns limit, that should be int?, as String', () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': true,
            'limit': '10',
            'lastItem': 'lastItem',
            'lastId': 'lastId',
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getPublicQuestions(limit: limit),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'String' is not a subtype of type 'int?' in type cast",
          ),
        ),
      );
    });

    test(
        'returns an QuestionsListResponse'
        ' if server returns limit, that should be String?, as String',
        () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          {
            'data': [],
            'hasMore': true,
            'limit': 10,
            'lastItem': [],
            'lastId': [],
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getPublicQuestions(limit: limit),
        throwsA(
          predicate(
            (e) =>
                e is TypeError &&
                e.toString() ==
                    "type 'List<dynamic>' is not a subtype of type 'String?' in type cast",
          ),
        ),
      );
    });

    test(
        'throws a DioError'
        ' if server returns String instead of Map', () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          'some random String',
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );

      expect(
        () async => await chatsApi.getPublicQuestions(limit: limit),
        throwsA(
          predicate(
            (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.error.toString() ==
                    "type 'String' is not a subtype of type 'Map<String, dynamic>?' in type cast",
          ),
        ),
      );
    });
  });
}

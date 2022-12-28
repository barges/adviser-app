import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_advisor_interface/data/models/chats/story.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/network/requests/update_note_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/data/network/responses/rituals_response.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';

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

  group('LoginResponse', () {
    test(
        'returns an LoginResponse'
        ' if server returns accessToken as String', () async {
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
        isA<LoginResponse>(),
      );
    });

    test(
        'returns an LoginResponse'
        ' if server returns accessToken as null', () async {
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
        isA<LoginResponse>(),
      );
    });

    test(
        'returns an LoginResponse'
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
        isA<LoginResponse>(),
      );
    });

    test(
        'returns an LoginResponse'
        ' if server returns accessToken as List', () async {
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
        await authApi.login(),
        isA<LoginResponse>(),
      );
    });

    test(
        'returns an LoginResponse'
        ' if server returns accessToken as int', () async {
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
        await authApi.login(),
        isA<LoginResponse>(),
      );
    });

    test(
        'returns an LoginResponse'
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
        await authApi.login(),
        isA<LoginResponse>(),
      );
    });
  });

  group('ConversationsStoryResponse', () {
    test(
        'returns an ConversationsStoryResponse'
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
        isA<ConversationsStoryResponse>(),
      );
    });

    test(
        'returns an ConversationsStoryResponse'
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
        isA<ConversationsStoryResponse>(),
      );
    });

    test(
        'returns an ConversationsStoryResponse'
        ' if server returns questions as String', () async {
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
        await chatsApi.getStory(storyID: emptyString),
        isA<ConversationsStoryResponse>(),
      );
    });

    test(
        'returns an ConversationsStoryResponse'
        ' if server returns answers as String', () async {
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
        await chatsApi.getStory(storyID: emptyString),
        isA<ConversationsStoryResponse>(),
      );
    });

    test(
        'returns an ConversationsStoryResponse'
        ' if server returns clientID as int', () async {
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
        await chatsApi.getStory(storyID: emptyString),
        isA<ConversationsStoryResponse>(),
      );
    });

    test(
        'returns an ConversationsStoryResponse'
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
        await chatsApi.getStory(storyID: emptyString),
        isA<ConversationsStoryResponse>(),
      );
    });
  });

  group('HistoryResponse', () {
    test(
        'returns an HistoryResponse'
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
        isA<HistoryResponse>(),
      );
    });

    test(
        'returns an HistoryResponse'
        ' if server returns data as int', () async {
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
        await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        isA<HistoryResponse>(),
      );
    });

    test(
        'returns an HistoryResponse'
        ' if server returns hasMore as String', () async {
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
        await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        isA<HistoryResponse>(),
      );
    });

    test(
        'returns an HistoryResponse'
        ' if server returns lastItem as List', () async {
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
        await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        isA<HistoryResponse>(),
      );
    });

    test(
        'returns an HistoryResponse'
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
        await chatsApi.getHistoryList(
          clientId: emptyString,
          limit: limit,
        ),
        isA<HistoryResponse>(),
      );
    });
  });

  group('RitualsResponse', () {
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
        isA<RitualsResponse>(),
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
        isA<RitualsResponse>(),
      );
    });

    test(
        'returns an RitualsResponse'
        ' if server returns identifier as int', () async {
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
        isA<RitualsResponse>(),
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
        isA<RitualsResponse>(),
      );
    });

    test(
        'returns an RitualsResponse'
        ' if server returns clientID and clientName as int', () async {
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
        await chatsApi.getRituals(id: emptyString),
        isA<RitualsResponse>(),
      );
    });

    test(
        'returns an RitualsResponse'
        ' if server returns inputFieldsData as String', () async {
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
        await chatsApi.getRituals(id: emptyString),
        isA<RitualsResponse>(),
      );
    });

    test(
        'returns an RitualsResponse'
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
        await chatsApi.getRituals(id: emptyString),
        isA<RitualsResponse>(),
      );
    });
  });

  group('UpdateNoteResponse', () {
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
          const UpdateNoteRequest(clientID: emptyString, content: emptyString),
        ),
        isA<UpdateNoteResponse>(),
      );
    });

    test(
        'returns an UpdateNoteResponse'
        ' if server returns values with wrong types', () async {
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
        await customerApi.updateNoteToCustomer(
          const UpdateNoteRequest(clientID: emptyString, content: emptyString),
        ),
        isA<UpdateNoteResponse>(),
      );
    });

    test(
        'returns an UpdateNoteResponse'
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
        await customerApi.updateNoteToCustomer(
          const UpdateNoteRequest(clientID: emptyString, content: emptyString),
        ),
        isA<UpdateNoteResponse>(),
      );
    });
  });

  group('QuestionsListResponse', () {
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
        ' if server returns values with wrong types', () async {
      dioAdapter.onPost(
        '/experts/questions/public',
        (server) => server.reply(
          200,
          {
            'data': 10,
            'hasMore': 'true',
            'limit': '10',
            'lastItem': [],
            'lastId': [],
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
        await chatsApi.getPublicQuestions(limit: limit),
        isA<QuestionsListResponse>(),
      );
    });
  });
}

import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/gender.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';

class ChatScreenTestChatItems {
  static ChatItem publicQuestion = ChatItem(
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

  static ChatItem ritualLoveCrushReadingQuestion = ChatItem(
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

  static ChatItem ritualAuraReadingQuestion = ChatItem(
      type: ChatItemType.ritual,
      questionType: null,
      ritualIdentifier: SessionsTypes.aurareading,
      status: null,
      clientName: 'Hope Fortunikovna',
      takenDate: null,
      createdAt: DateTime.parse('2022-07-25 06:18:42.278Z'),
      updatedAt: DateTime.parse('2022-10-12 12:42:44.793Z'),
      startAnswerDate: null,
      content:
          'Aut et voluptatem consequatur ad officiis sint voluptatibus inventore. Aut facilis totam est. Cum et ipsa odio officia id quia velit voluptates iure. Et est qui blanditiis quasi error in aut occaecati. Laboriosam earum ipsam voluptatum amet deserunt.',
      id: '62de35c2b584e9001e590daf',
      clientInformation: ClientInformation(
          birthdate: DateTime.parse('1989-02-07 00:00:00.000Z'),
          zodiac: ZodiacSign.aquarius,
          gender: Gender.nonGender,
          country: 'BR'),
      attachments: [],
      unansweredTypes: null,
      clientID: '5f5224f45a1f7c001c99763c',
      ritualID: '62de35bcb584e9001e590d7d',
      lastQuestionId: null,
      unansweredCount: null,
      storyID: '62de35bcb584e9001e590d82',
      isActive: true,
      isAnswer: false,
      isSent: true);
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_tile_content_widget.dart';

import '../../../widget_tester_extension.dart';

void main() {
  group('ListTileContentWidget', () {
    testWidgets(
        'should display only text'
        ' if ChatItem do not have any attachments', (tester) async {
      const ChatItem argumentQuestion = ChatItem(content: 'someContent');
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ListTileContentWidget(question: argumentQuestion)),
      ));
      await tester.pumpAndSettle();

      expect(find.text(argumentQuestion.content!), findsOneWidget);
    });

    testWidgets(
        'should display play button and Audio message text'
        ' if ChatItem have audio attachment, but do not have content',
        (tester) async {
      const ChatItem argumentQuestion =
          ChatItem(attachments: [Attachment(mime: 'audio/')]);
      await tester.runAsync(() async {
        await tester.pumpWidget(const MaterialApp(
          localizationsDelegates: [S.delegate],
          home:
              Scaffold(body: ListTileContentWidget(question: argumentQuestion)),
        ));
        await tester.pumpAndSettle();

        Element element = tester.element(find.byType(SvgPicture));
        SvgPicture image = element.widget as SvgPicture;
        await precachePicture(image.pictureProvider, element);

        await tester.pumpAndSettle();
      });

      expect(find.text('Audio message'), findsOneWidget);
      expectLater(find.byType(SvgPicture),
          matchesGoldenFile('goldens/assets_play.png'));
    });

    testWidgets(
        'should display play button and ChatItem content'
        ' if ChatItem have audio attachment and content', (tester) async {
      const ChatItem argumentQuestion = ChatItem(
          content: 'Some content that displayed with audio',
          attachments: [Attachment(mime: 'audio/')]);
      await tester.runAsync(() async {
        await tester.pumpWidget(const MaterialApp(
          localizationsDelegates: [S.delegate],
          home:
              Scaffold(body: ListTileContentWidget(question: argumentQuestion)),
        ));
        await tester.pumpAndSettle();

        Element element = tester.element(find.byType(SvgPicture));
        SvgPicture image = element.widget as SvgPicture;
        await precachePicture(image.pictureProvider, element);

        await tester.pumpAndSettle();
      });

      expect(find.text(argumentQuestion.content!), findsOneWidget);
      expectLater(find.byType(SvgPicture),
          matchesGoldenFile('goldens/assets_play_with_content.png'));
    });

    testWidgets(
        'should display image and ChatItem content'
        ' if ChatItem have image attachment and content', (tester) async {
      const ChatItem argumentQuestion = ChatItem(
          content: 'Some content that displayed with image',
          attachments: [
            Attachment(url: 'test/assets/test_placeholder.png', mime: '')
          ]);
      await tester.pumpWidget(const MaterialApp(
        localizationsDelegates: [S.delegate],
        home: Scaffold(body: ListTileContentWidget(question: argumentQuestion)),
      ));
      await tester.pumpAndSettle();

      expect(find.text(argumentQuestion.content!), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'should display play button and image'
        ' if ChatItem have audio and image attachments', (tester) async {
      const ChatItem argumentQuestion = ChatItem(attachments: [
        Attachment(mime: 'audio/'),
        Attachment(url: 'test/assets/test_placeholder.png')
      ]);
      await tester.runAsync(() async {
        await tester.pumpWidget(const MaterialApp(
          localizationsDelegates: [S.delegate],
          home:
              Scaffold(body: ListTileContentWidget(question: argumentQuestion)),
        ));
        await tester.pumpAndSettle();

        Element elementPicture = tester.element(find.byType(SvgPicture));
        SvgPicture picture = elementPicture.widget as SvgPicture;
        await precachePicture(picture.pictureProvider, elementPicture);

        await tester.pumpAndSettle();
      });

      expect(find.byType(Image), findsOneWidget);
      expectLater(find.byType(SvgPicture),
          matchesGoldenFile('goldens/assets_play_with_image.png'));
    });
  });
}

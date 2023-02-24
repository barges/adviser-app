import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';

void main() {
  group('UserAvatar', () {
    testWidgets(
        'should display placeholder'
        ' if imageFile and avatarUrl fields are null', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MaterialApp(
            home: Scaffold(
          body: UserAvatar(),
        )));
        await tester.pumpAndSettle();

        Element elementPicture = tester.element(find.byType(SvgPicture));
        SvgPicture picture = elementPicture.widget as SvgPicture;
        await precachePicture(picture.pictureProvider, elementPicture);

        await tester.pumpAndSettle();
      });

      expectLater(find.byType(UserAvatar),
          matchesGoldenFile('goldens/placeholder_avatar.png'));
    });

    testWidgets(
        'should display zodiac sign image'
        ' if avatarUrl and isZodiac fields are not null', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
          body: UserAvatar(
            avatarUrl: ZodiacSign.aquarius.imagePathLight,
            isZodiac: true,
          ),
        )));
        await tester.pumpAndSettle();

        Element elementPicture = tester.element(find.byType(SvgPicture));
        SvgPicture picture = elementPicture.widget as SvgPicture;
        await precachePicture(picture.pictureProvider, elementPicture);

        await tester.pumpAndSettle();
      });

      expectLater(find.byType(UserAvatar),
          matchesGoldenFile('goldens/zodiac_avatar.png'));
    });

    testWidgets(
        'should display file image'
        ' if imageFile field is not null', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: UserAvatar(
          imageFile: File('test/assets/test_placeholder.png'),
        ),
      )));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            BoxDecoration boxDecoration = widget.decoration as BoxDecoration;
            return boxDecoration.image?.image is FileImage;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets(
        'should display network image'
        ' if avatarUrl field is not null or empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: UserAvatar(
          avatarUrl: 'someImageUrl',
        ),
      )));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            BoxDecoration boxDecoration = widget.decoration as BoxDecoration;
            return boxDecoration.image?.image is CachedNetworkImageProvider;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets(
        'should display specific color badge'
        ' if badgeColor field is not null', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: UserAvatar(
          badgeColor: Colors.green,
        ),
      )));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            BoxDecoration boxDecoration = widget.decoration as BoxDecoration;
            return boxDecoration.color == Colors.green;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets(
        'should display with "Photo is required" text'
        ' if withError field is true', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          localizationsDelegates: [S.delegate],
          home: Scaffold(
            body: UserAvatar(
              withError: true,
            ),
          )));
      await tester.pumpAndSettle();

      expect(
        find.text('Photo is required'),
        findsOneWidget,
      );
    });
  });
}

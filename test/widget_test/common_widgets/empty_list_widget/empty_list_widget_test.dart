import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

void main() {
  group('EmptyListWiidget', () {
    testWidgets(
        'should be displayed with image, title and label'
        ' if label is not null', (tester) async {
      String title = 'Some title';
      String label = 'Some label';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: EmptyListWidget(
          title: title,
          label: label,
        )),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.text(title), findsOneWidget);
      expect(find.text(label), findsOneWidget);
    });

    testWidgets(
        'should be displayed with image and title, but without label'
        ' if label is null', (tester) async {
      String title = 'Some title';
      String label = 'Some label';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: EmptyListWidget(
          title: title,
        )),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(1));
      expect(find.text(title), findsOneWidget);
      expect(find.text(label), findsNothing);
    });

    testWidgets(
        'should be displayed with light logo image'
        ' if theme of application is light', (tester) async {
      String title = 'Some title';

      await tester.runAsync(() async {
        await tester.pumpWidget(
          Builder(builder: (context) {
            return MaterialApp(
              theme: AppThemes.themeLight(context),
              home: Scaffold(
                  body: EmptyListWidget(
                title: title,
              )),
            );
          }),
        );
        await tester.pumpAndSettle();

        Element element = tester.element(find.byType(Image));
        Image image = element.widget as Image;
        await precacheImage(image.image, element);

        await tester.pumpAndSettle();
      });

      expectLater(find.byType(Image),
          matchesGoldenFile('goldens/assets_empty_list_logo.png'));
    });

    testWidgets(
        'should be displayed with dark logo image'
        ' if theme of application is dark', (tester) async {
      String title = 'Some title';

      await tester.runAsync(() async {
        await tester.pumpWidget(
          Builder(builder: (context) {
            return MaterialApp(
              theme: AppThemes.themeDark(context),
              home: Scaffold(
                  body: EmptyListWidget(
                title: title,
              )),
            );
          }),
        );
        await tester.pumpAndSettle();

        Element element = tester.element(find.byType(Image));
        Image image = element.widget as Image;
        await precacheImage(image.image, element);

        await tester.pumpAndSettle();
      });

      expectLater(find.byType(Image),
          matchesGoldenFile('goldens/assets_empty_list_logo_dark.png'));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';

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

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        home: Scaffold(
            body: EmptyListWidget(
          title: title,
        )),
      ));
      await tester.pumpAndSettle();

      expectLater(find.byType(Image),
          matchesGoldenFile('goldens/assets_empty_list_logo.png'));
    });

    testWidgets(
        'should be displayed with dark logo image'
        ' if theme of application is dark', (tester) async {
      String title = 'Some title';

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
            backgroundColor: Colors.white,
            body: EmptyListWidget(
              title: title,
            )),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      expectLater(find.byType(Image),
          matchesGoldenFile('goldens/assets_empty_list_logo_dark.png'));
    });
  });
}

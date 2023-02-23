import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

void main() {
  group('NoConnectionWidget', () {
    testWidgets('should have image, title and label', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          localizationsDelegates: [S.delegate],
          home: Scaffold(body: NoConnectionWidget())));

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('No internet connection.'), findsOneWidget);
      expect(
          find.text(
              'Uh-oh. It looks like you\'ve lost your connection. Please try again.'),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with light logo image'
        ' if theme of application is light', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          Builder(builder: (context) {
            return MaterialApp(
              localizationsDelegates: const [S.delegate],
              theme: AppThemes.themeLight(context),
              home: const Scaffold(body: NoConnectionWidget()),
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
          matchesGoldenFile('goldens/assets_no_connection_logo.png'));
    });

    testWidgets(
        'should be displayed with dark logo image'
        ' if theme of application is dark', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          Builder(builder: (context) {
            return MaterialApp(
              localizationsDelegates: const [S.delegate],
              theme: AppThemes.themeDark(context),
              home: const Scaffold(body: NoConnectionWidget()),
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
          matchesGoldenFile('goldens/assets_no_connection_logo_dark.png'));
    });
  });
}

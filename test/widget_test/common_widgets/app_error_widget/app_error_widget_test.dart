import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';

void main() {
  group('AppErrorWidget', () {
    const String errorMessage = 'Some error message';

    testWidgets(
        'should be displayed with text'
        ' if errorMessage field is not empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            errorMessage: errorMessage,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Container, errorMessage), findsOneWidget);
    });

    testWidgets(
        'should be displayed as SizedBox.shrink'
        ' if errorMessage field is empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            errorMessage: '',
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
        'should be displayed with cross button'
        ' if isRequired field is false', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            errorMessage: errorMessage,
            isRequired: false,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expectLater(find.byType(GestureDetector),
          matchesGoldenFile('goldens/assets_vectors_close.png'));
    });

    testWidgets(
        'should be displayed without cross button'
        ' if isRequired field is true', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            errorMessage: errorMessage,
            isRequired: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expectLater(find.byType(GestureDetector), findsNothing);
    });
  });
}

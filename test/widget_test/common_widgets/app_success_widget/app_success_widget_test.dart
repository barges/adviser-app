import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/open_email_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_success_widget.dart';

void main() {
  const String successMessage = 'Some success message';

  group('AppSuccessWidget', () {
    testWidgets(
        'should be displayed with text'
        ' if successMessage field is not empty', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppSuccessWidget(
            message: successMessage,
            onClose: () {},
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Container, successMessage), findsOneWidget);
    });

    testWidgets(
        'should be displayed as SizedBox.shrink'
        ' if errorMessage field is empty', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppSuccessWidget(
            message: '',
            onClose: () {},
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should have a cross button', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppSuccessWidget(
            message: successMessage,
            onClose: () {},
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expectLater(find.byType(GestureDetector),
          matchesGoldenFile('goldens/assets_vectors_close.png'));
    });

    testWidgets(
        'should have open email button'
        ' if needEmailButton is true', (tester) async {
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: const [S.delegate],
        home: Scaffold(
          body: AppSuccessWidget(
            message: successMessage,
            onClose: () {},
            needEmailButton: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(OpenEmailButton), findsOneWidget);
    });
  });
}

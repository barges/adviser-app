import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';

void main() {
  group('PasswordField', () {
    testWidgets(
        'User should not have posibility to enter spaces in password field',
        (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PasswordTextField(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              hintText: 'Enter a password'),
        ),
      ));

      await widgetTester.enterText(
          find.byType(TextField), 'Hello PasswordField');
      await widgetTester.pump();

      expect(find.text('HelloPasswordField'), findsOneWidget);
    });

    testWidgets('should have a hint text', (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PasswordTextField(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              hintText: 'Enter your password'),
        ),
      ));

      expect(find.text('Enter your password'), findsOneWidget);
    });
  });
}

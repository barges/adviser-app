import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

void main() {
  group('PasswordField', () {
    testWidgets(
        'User should not have posibility to enter spaces in password field',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PasswordTextField(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              hintText: 'Enter a password'),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Hello PasswordField');
      await tester.pump();

      expect(find.text('HelloPasswordField'), findsOneWidget);
    });

    testWidgets('should have a hint text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PasswordTextField(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              hintText: 'Enter your password'),
        ),
      ));

      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('should have a hint text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PasswordTextField(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              hintText: 'Enter your password'),
        ),
      ));

      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets(
      'should have a hide password button',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          Builder(builder: (context) {
            return MaterialApp(
              theme: AppThemes.themeLight(context),
              darkTheme: AppThemes.themeDark(context),
              home: Scaffold(
                body: PasswordTextField(
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  hintText: 'Enter your password',
                ),
              ),
            );
          }),
        );
        await tester.pumpAndSettle();

        expectLater(find.byType(PasswordTextField),
            matchesGoldenFile('goldens/assets_vectors_visibilityOff.png'));
      },
    );

    testWidgets(
      'should have a another hide password button if hiddenPassword is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          Builder(builder: (context) {
            return MaterialApp(
              theme: AppThemes.themeLight(context),
              darkTheme: AppThemes.themeDark(context),
              home: Scaffold(
                body: PasswordTextField(
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  hintText: 'Enter your password',
                  hiddenPassword: false,
                ),
              ),
            );
          }),
        );
        await tester.pumpAndSettle();

        expectLater(find.byType(PasswordTextField),
            matchesGoldenFile('goldens/assets_vectors_visibility.png'));
      },
    );
  });
}

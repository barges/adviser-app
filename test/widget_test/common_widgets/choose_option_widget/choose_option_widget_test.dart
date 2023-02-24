import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

void main() {
  group('ChooseOptionWidget', () {
    testWidgets(
        'should be displayed with texts'
        ' that are contains in options field', (tester) async {
      const List<String> options = ['Option 1', 'Option 2', 'Option 3'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChooseOptionWidget(
              options: options,
              currentIndex: 0,
              onChangeOptionIndex: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (String element in options) {
        expect(find.text(element), findsOneWidget);
      }
      expect(find.byType(GestureDetector), findsNWidgets(options.length));
    });

    testWidgets(
        'should display selected item'
        ' with primaryColor background color and backgroundColor text color',
        (tester) async {
      const List<String> options = ['Option 1', 'Option 2', 'Option 3'];
      const int currentIndex = 0;
      await tester.pumpWidget(
        Builder(builder: (context) {
          return MaterialApp(
            theme: AppThemes.themeLight(context),
            home: Scaffold(
              body: ChooseOptionWidget(
                options: options,
                currentIndex: currentIndex,
                onChangeOptionIndex: (_) {},
              ),
            ),
          );
        }),
      );
      await tester.pumpAndSettle();

      expect(
          ((tester.firstWidget(find.descendant(
                      of: find.byType(GestureDetector),
                      matching: find.widgetWithText(
                          Container, options[currentIndex]))) as Container)
                  .decoration as BoxDecoration)
              .color,
          const Color(0xff3975E9));

      expect(
          ((tester.firstWidget(find.text(options[currentIndex])) as Text).style
                  as TextStyle)
              .color,
          const Color(0xFFFFFFFF));
    });

    testWidgets(
        'should display unselected item'
        ' with transparent background color and primaryColor text color',
        (tester) async {
      const List<String> options = ['Option 1', 'Option 2', 'Option 3'];
      const int currentIndex = 0;
      await tester.pumpWidget(
        Builder(builder: (context) {
          return MaterialApp(
            theme: AppThemes.themeLight(context),
            home: Scaffold(
              body: ChooseOptionWidget(
                options: options,
                currentIndex: currentIndex,
                onChangeOptionIndex: (_) {},
              ),
            ),
          );
        }),
      );
      await tester.pumpAndSettle();

      options.forEachIndexed(
        (index, element) {
          if (index != currentIndex) {
            expect(
                ((tester.firstWidget(find.descendant(
                            of: find.byType(GestureDetector),
                            matching: find.widgetWithText(
                                Container, options[index]))) as Container)
                        .decoration as BoxDecoration)
                    .color,
                Colors.transparent);

            expect(
                ((tester.firstWidget(find.text(options[index])) as Text).style
                        as TextStyle)
                    .color,
                const Color(0xff3975E9));
          }
        },
      );
    });

    testWidgets(
        'should display items with opacity'
        ' if disabledIndexes field contains its indexes', (tester) async {
      const List<String> options = ['Option 1', 'Option 2', 'Option 3'];
      const int currentIndex = 0;
      const List<int> disabledIndexes = [1, 2];
      await tester.pumpWidget(
        Builder(builder: (context) {
          return MaterialApp(
            theme: AppThemes.themeLight(context),
            home: Scaffold(
              body: ChooseOptionWidget(
                options: options,
                currentIndex: currentIndex,
                onChangeOptionIndex: (_) {},
                disabledIndexes: disabledIndexes,
              ),
            ),
          );
        }),
      );
      await tester.pumpAndSettle();

      expect(
          ((tester.firstWidget(find.descendant(
                      of: find.byType(GestureDetector),
                      matching: find.widgetWithText(
                          Container, options[currentIndex]))) as Container)
                  .decoration as BoxDecoration)
              .color,
          const Color(0xff3975E9));

      for (int element in disabledIndexes) {
        expect(
            (tester.firstWidget(
              find.ancestor(
                of: find.text(options[element]),
                matching: find.byType(Opacity),
              ),
            ) as Opacity)
                .opacity,
            0.4);
      }
    });
  });
}

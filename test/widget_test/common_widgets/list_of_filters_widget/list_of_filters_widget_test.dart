import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

void main() {
  group('ListOfFilterWidget', () {
    testWidgets(
        'should be displayed  with 3 filters'
        ' if filters field value is List with 3 items', (tester) async {
      const List<String> filters = [
        'firstFilter',
        'secondFilter',
        'thirdFilter'
      ];

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ListOfFiltersWidget(
        filters: filters,
        currentFilterIndex: 0,
        onTapToFilter: (_) {},
      ))));

      for (String element in filters) {
        expect(find.text(element), findsOneWidget);
      }
    });

    testWidgets(
        'should be displayed with filters with different colors'
        ' depends on currentIndex', (tester) async {
      const List<String> filters = [
        'firstFilter',
        'secondFilter',
        'thirdFilter'
      ];
      const int currentIndex = 0;

      await tester.pumpWidget(Builder(builder: (context) {
        return MaterialApp(
            theme: AppThemes.themeLight(context),
            home: Scaffold(
                body: ListOfFiltersWidget(
              filters: filters,
              currentFilterIndex: currentIndex,
              onTapToFilter: (_) {},
            )));
      }));

      expect(
          ((tester.firstWidget(
                          find.widgetWithText(Container, filters[currentIndex]))
                      as Container)
                  .decoration as BoxDecoration)
              .color,
          const Color(0xffB7DCFF));

      filters.forEachIndexed((index, element) {
        if (index != currentIndex) {
          logger.d(index);
          expect(
              ((tester.firstWidget(
                              find.widgetWithText(Container, filters[index]))
                          as Container)
                      .decoration as BoxDecoration)
                  .color,
              const Color(0xFFF1F4FB));
        }
      });
    });
  });
}

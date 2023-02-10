import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/market_filter_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

void main() {
  group('MarketFilterWidget', () {
    testWidgets(
        'should be displayed as SizedBox.shrink() and should not be clickable'
        ' if userMarket field length less then 2', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [S.delegate],
          home: Scaffold(
            body: MarketFilterWidget(
                userMarkets: const [],
                currentMarketIndex: 0,
                changeIndex: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
        'should be displayed with "Market: All Markets" label'
        ' if userMarket field length more then 2'
        ' and first List item is MarketsType.all'
        ' and currentMarketIndex is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [S.delegate],
          home: Scaffold(
            body: MarketFilterWidget(
              userMarkets: const [
                MarketsType.all,
                MarketsType.de,
                MarketsType.en
              ],
              currentMarketIndex: 0,
              changeIndex: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(GestureDetector, 'Market: All Markets'),
          findsOneWidget);
    });

    testWidgets(
        'should be displayed with scaffoldBackgroundColor for background'
        ' and hoverColor for text'
        ' if selected market is MarketsType.all', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          return MaterialApp(
            theme: AppThemes.themeLight(context),
            localizationsDelegates: const [S.delegate],
            home: Scaffold(
              body: MarketFilterWidget(
                userMarkets: const [
                  MarketsType.all,
                  MarketsType.de,
                  MarketsType.en
                ],
                currentMarketIndex: 0,
                changeIndex: (_) {},
              ),
            ),
          );
        }),
      );
      await tester.pumpAndSettle();

      expect(
          ((tester.firstWidget(
                          find.widgetWithText(Container, 'Market: All Markets'))
                      as Container)
                  .decoration as BoxDecoration)
              .color,
          const Color(0xFFF1F4FB));

      expect(
          ((tester.firstWidget(find.text('Market: All Markets')) as Text)
              .style
              ?.color),
          const Color(0xFF28313A));
    });

    testWidgets(
        'should be displayed with primaryColorLight for background'
        ' and primaryColor for text'
        ' if selected market is not MarketsType.all', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          return MaterialApp(
            theme: AppThemes.themeLight(context),
            localizationsDelegates: const [S.delegate],
            home: Scaffold(
              body: MarketFilterWidget(
                userMarkets: const [
                  MarketsType.all,
                  MarketsType.de,
                  MarketsType.en
                ],
                currentMarketIndex: 1,
                changeIndex: (_) {},
              ),
            ),
          );
        }),
      );
      await tester.pumpAndSettle();

      expect(
          ((tester.firstWidget(
                          find.widgetWithText(Container, 'Market: Deutsch'))
                      as Container)
                  .decoration as BoxDecoration)
              .color,
          const Color(0xffB7DCFF));

      expect(
          ((tester.firstWidget(find.text('Market: Deutsch')) as Text)
              .style
              ?.color),
          const Color(0xff3975E9));
    });

    testWidgets(
        'should open CupertinoPicker'
        ' if user clicks on it', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          return MaterialApp(
            theme: AppThemes.themeLight(context),
            localizationsDelegates: const [S.delegate],
            home: Scaffold(
              body: MarketFilterWidget(
                userMarkets: const [
                  MarketsType.all,
                  MarketsType.de,
                  MarketsType.en
                ],
                currentMarketIndex: 1,
                changeIndex: (_) {},
              ),
            ),
          );
        }),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(find.byType(CupertinoPicker), findsOneWidget);
    });
  });
}

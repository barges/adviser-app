import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';

import '../../../widget_tester_extension.dart';

void main() {
  group('AppImageWidget', () {
    const String networkImagePath = 'https://picsum.photos/200';
    const String localImagePath = '/test/assets/test_placeholder.png';

    testWidgets(
        'should use CacheNetworkImage'
        ' if uri field value is network url', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppImageWidget(
              uri: Uri.parse(networkImagePath),
            ),
          ),
        ),
      );
      await tester.pumpNtimes(times: 50);

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets(
        'should use Image.file'
        ' if uri field value is local path to file', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppImageWidget(
              uri: Uri.parse(localImagePath),
            ),
          ),
        ),
      );
      await tester.pumpNtimes(times: 50);

      expect(find.byType(Image), findsOneWidget);
    });
  });
}

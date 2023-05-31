import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';

class SendImageScreen extends StatelessWidget {
  final File image;

  const SendImageScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final Uri uri = Uri.parse(image.path);
      return Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).selectedPhotoZodiac,
          actionOnClick: () {
            context.pop<bool?>(true);
          },
        ),
        body: Container(
          color: Theme.of(context).canvasColor,
          child: InteractiveViewer(
            panEnabled: false,
            maxScale: 5.0,
            minScale: 1.0,
            child: AppImageWidget(
              uri: uri,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      );
    });
  }
}

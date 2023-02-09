import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

mixin ShareMixin {
  void pickAndShareImage(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      await Share.shareXFiles([XFile(pickedFile.path)],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  void shareListOfImages(BuildContext context, List<String> paths) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareXFiles(paths.map((e) => XFile(e)).toList(),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  void shareText(BuildContext context, String text) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(text,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}

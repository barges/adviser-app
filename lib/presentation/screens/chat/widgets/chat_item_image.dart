import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatImageWidget extends StatelessWidget {
  final String url;
  const ChatImageWidget(
    this.url, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 134.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(url),
        ),
      ),
    );
  }
}

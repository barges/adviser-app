import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? imageFile;
  final double diameter;
  final Color? badgeColor;
  final bool withBorder;
  final bool withError;

  const UserAvatar(
      {Key? key,
      this.avatarUrl,
      this.imageFile,
      this.badgeColor,
      this.diameter = 86.0,
      this.withBorder = false,
      this.withError = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor,
            shape: BoxShape.circle,
            border: withBorder
                ? Border.all(
                    width: 2.0,
                    color: withError
                        ? Theme.of(context).errorColor
                        : Theme.of(context).canvasColor)
                : null,
          ),
          child: imageFile == null
              ? avatarUrl == null || avatarUrl!.isEmpty
                  ? Container(
                      child: Assets.vectors.placeholderProfileImage
                          .svg(color: Theme.of(context).canvasColor),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(avatarUrl!),
                        ),
                      ),
                    )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(imageFile!),
                    ),
                  ),
                ),
        ),
        if (badgeColor != null)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 18.0,
                width: 18.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badgeColor,
                  border: Border.all(
                    width: 3.0,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ),
          ),
        if (withError)
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.current.photoIsRequired,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.0, color: Theme.of(context).errorColor),
                  ))),
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class NotesWidget extends StatelessWidget {
  final List<String> texts;
  final List<List<String>> images;
  final VoidCallback? onTapAddNew;
  final VoidCallback? onTapOldNote;

  const NotesWidget({
    Key? key,
    this.texts = const [],
    this.images = const [],
    this.onTapAddNew,
    this.onTapOldNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 24.0, horizontal: AppConstants.horizontalScreenPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).notes,
                    style: Get.textTheme.headlineMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${texts.length}',
                        style: Get.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Get.theme.shadowColor)),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.vectors.plus.svg(),
                  const SizedBox(width: 9.0),
                  GestureDetector(
                    onTap: onTapAddNew,
                    child: Text(
                      S.of(context).addNew,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 11.0),
          texts.isNotEmpty
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) => _OneNoteWidget(
                      onTap: onTapOldNote,
                      text: texts[index],
                      images: images.isNotEmpty ? images[index] : const []),
                  separatorBuilder: (_, __) => const SizedBox(height: 11.0),
                  itemCount: min(texts.length, images.length),
                )
              : const _EmptyNotesWidget()
        ],
      ),
    );
  }
}

class _EmptyNotesWidget extends StatelessWidget {
  const _EmptyNotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Get.isDarkMode
            ? Assets.images.logos.emptyListLogoDark.image()
            : Assets.images.logos.emptyListLogo.image(),
        const SizedBox(height: 24.0),
        Text(
          S.of(context).youDoNotHaveAnyNotesYet,
          textAlign: TextAlign.center,
          style: Get.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            S.of(context).addInformationYouWantKeepInMindAboutThisClient,
            textAlign: TextAlign.center,
            style: Get.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: Get.theme.shadowColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _OneNoteWidget extends StatelessWidget {
  final String text;
  final List<String> images;
  final VoidCallback? onTap;

  const _OneNoteWidget(
      {Key? key, required this.text, required this.images, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Get.theme.canvasColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Get.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12.0),
                Material(
                  textStyle: Get.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Get.theme.shadowColor),
                  child: Row(
                    children: [
                      Text('2020-01-07T00:00:00.000Z'.parseDateTimePattern2),
                      if (images.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, right: 4.0),
                              child: Assets.vectors.attach.svg(),
                            ),
                            Text(images.length.toString()),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (images.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: AppConstants.horizontalScreenPadding),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                  child: Image.network(
                    images[0],
                    height: 78.0,
                    width: 78.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
        ]),
      ),
    );
  }
}

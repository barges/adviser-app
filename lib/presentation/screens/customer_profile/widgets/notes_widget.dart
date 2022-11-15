import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class NotesWidget extends StatelessWidget {
  final List<GetNoteResponse> notes;
  final List<List<String>> images;
  final VoidCallback? onTapAddNew;
  final VoidCallback? onTapOldNote;

  const NotesWidget({
    Key? key,
    this.notes = const [],
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
                    'Note', //S.of(context).notes,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  /**
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('${texts.length}',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).shadowColor)),
                    )
                  */
                ],
              ),
              notes.isEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.vectors.plus.svg(),
                        const SizedBox(width: 9.0),
                        GestureDetector(
                          onTap: onTapAddNew,
                          child: Text(
                            S.of(context).addNew,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 11.0),
          notes.isNotEmpty
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) => _OneNoteWidget(
                      onTap: onTapOldNote,
                      text: notes[index].content!,
                      updatedAt: notes[index].updatedAt!,
                      images: images.isNotEmpty ? images[index] : const []),
                  separatorBuilder: (_, __) => const SizedBox(height: 11.0),
                  itemCount: min(notes.length, images.length),
                )
              : EmptyListWidget(
                  title: S.of(context).youDoNotHaveAnyNotesYet,
                  label: S
                      .of(context)
                      .addInformationYouWantKeepInMindAboutThisClient,
                )
        ],
      ),
    );
  }
}

class _OneNoteWidget extends StatelessWidget {
  final String text;
  final List<String> images;
  final VoidCallback? onTap;
  final String updatedAt;

  const _OneNoteWidget(
      {Key? key,
      required this.text,
      required this.images,
      this.onTap,
      required this.updatedAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 12.0),
                Material(
                  textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).shadowColor),
                  child: Row(
                    children: [
                      Text(updatedAt.parseDateTimePattern2),
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

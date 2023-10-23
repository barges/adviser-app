import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions.dart';
import '../../../../app_constants.dart';
import '../../../../data/models/customer_info/note.dart';
import '../../../../generated/assets/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../empty_list_widget.dart';
import '../customer_profile_cubit.dart';

class NotesWidget extends StatelessWidget {
  final List<Note>? notes;
  final List<List<String>> images;

  const NotesWidget({
    Key? key,
    this.notes,
    this.images = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerProfileCubit customerProfileCubit =
        context.read<CustomerProfileCubit>();
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
                    SFortunica.of(context).noteFortunica,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              notes?.isEmpty == true
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.vectors.plus.svg(),
                        const SizedBox(width: 4.0),
                        GestureDetector(
                          onTap: () =>
                              customerProfileCubit.createNewNote(context),
                          child: Text(
                            SFortunica.of(context).addNewFortunica,
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
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          notes != null
              ? notes!.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final Note note = notes![index];
                        return _OneNoteWidget(
                            onTap: () =>
                                customerProfileCubit.updateNote(context, note),
                            text: note.content ?? '',
                            updatedAt: note.updatedAt,
                            images:
                                images.isNotEmpty ? images[index] : const []);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                      itemCount: min(notes!.length, images.length),
                    )
                  : EmptyListWidget(
                      title: SFortunica.of(context)
                          .youDoNotHaveAnyNotesYetFortunica,
                      label: SFortunica.of(context)
                          .addAnyInformationYouWantToRememberAboutThisClientFortunica,
                    )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _OneNoteWidget extends StatelessWidget {
  final String text;
  final List<String> images;
  final VoidCallback? onTap;
  final DateTime? updatedAt;

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
                  maxLines: 3,
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
                      if (updatedAt != null)
                        Text(
                          updatedAt!.noteTime,
                        ),
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

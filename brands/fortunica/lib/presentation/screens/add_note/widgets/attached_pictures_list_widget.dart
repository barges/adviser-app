import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/presentation/screens/add_note/add_note_cubit.dart';

class AttachedPicturesListWidget extends StatelessWidget {
  const AttachedPicturesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imagesPaths =
        context.select((AddNoteCubit cubit) => cubit.state.imagesPaths);
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Center(
        child: Builder(builder: (context) {
          return (imagesPaths.isNotEmpty)
              ? Column(
                  children: List.generate(
                      imagesPaths.length,
                      (index) => Builder(builder: (context) {
                            final String imagesPath = context.select(
                                (AddNoteCubit cubit) =>
                                    cubit.state.imagesPaths[index]);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Image.file(
                                File(imagesPath),
                                height: MediaQuery.of(context).size.height / 2,
                                fit: BoxFit.cover,
                              ),
                            );
                          })),
                )
              : const SizedBox.shrink();
        }),
      ),
    );
  }
}

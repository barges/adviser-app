import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/screens/send_image/send_image_cubit.dart';

class SendImageScreen extends StatelessWidget {
  final File image;
  final String clientId;

  const SendImageScreen({
    Key? key,
    required this.image,
    required this.clientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SendImageCubit(
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ZodiacChatRepository>(),
        image,
        clientId,
      ),
      child: Builder(builder: (context) {
        final SendImageCubit sendImageCubit = context.read<SendImageCubit>();
        final Uri uri = Uri.parse(image.path);
        return Scaffold(
          appBar: SimpleAppBar(
            title: SZodiac.of(context).selectedPhotoZodiac,
            actionOnClick: () => sendImageCubit.sendImageToChat(context),
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
      }),
    );
  }
}

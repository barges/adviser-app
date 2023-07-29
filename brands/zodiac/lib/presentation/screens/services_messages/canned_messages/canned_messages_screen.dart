import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zodiac/infrastructure/di/inject_config.dart';

import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/add_canned_message_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/canned_message_manager_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/services_messages_screen.dart';

class CannedMessagesScreen extends StatelessWidget {
  const CannedMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => zodiacGetIt.get<CannedMessagesCubit>(),
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: verticalInterval),
          child: Column(
            children: [
              const AddCannedMessageWidget(),
              CannedMessageManagerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

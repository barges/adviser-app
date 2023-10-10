import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_cubit.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/auto_reply_list_widget.dart';

class AutoReplyScreen extends StatelessWidget {
  const AutoReplyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => zodiacGetIt.get<AutoReplyCubit>(),
      child: Builder(builder: (context) {
        final AutoReplyCubit autoReplyCubit = context.read<AutoReplyCubit>();

        return Scaffold(
          appBar: WideAppBar(
            bottomWidget: Text(
              SZodiac.of(context).autoReplyZodiac,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: AppConstants.horizontalScreenPadding),
            child: AutoReplyListWidget(),
          ),
        );
      }),
    );
  }
}

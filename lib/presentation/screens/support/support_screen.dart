import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/support/support_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/support/support_state.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportCubit(getIt.get<CachingManager>()),
      child: Builder(builder: (context) {
        final SupportCubit supportCubit = context.read<SupportCubit>();
        return BlocListener<SupportCubit, SupportState>(
          listenWhen: (prev, current) => prev.configured != current.configured,
          listener: (_, state) {
            if (state.configured) {
              Get.back();
              Freshchat.showFAQ(
                faqFilterType: FaqFilterType.Category,
                contactUsTags: supportCubit.getContactUsTags(),
                faqTags: supportCubit.getCategories(),
                faqTitle: S.of(context).customerSupport,
                showContactUsOnFaqScreens: false,
              );
            }
          },
          child: const Material(child: SizedBox.shrink()),
        );
      }),
    );
  }
}

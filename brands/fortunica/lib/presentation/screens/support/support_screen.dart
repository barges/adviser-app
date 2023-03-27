import 'package:fortunica/fortunica.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/screens/support/support_cubit.dart';
import 'package:fortunica/presentation/screens/support/support_state.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportCubit(
        freshChatService: fortunicaGetIt.get<FreshChatService>(),
        cachingManager: fortunicaGetIt.get<FortunicaCachingManager>(),
        userRepository: fortunicaGetIt.get<FortunicaUserRepository>(),
      ),
      child: Builder(builder: (context) {
        final SupportCubit supportCubit = context.read<SupportCubit>();
        return BlocListener<SupportCubit, SupportState>(
          listenWhen: (prev, current) => prev.configured != current.configured,
          listener: (_, state) {
            final locale = Intl.getCurrentLocale();
            if (state.configured) {
              context.pop();
              Freshchat.showFAQ(
                faqFilterType: FaqFilterType.Category,
                contactUsTags: FortunicaBrand().freshChatTags(locale),
                faqTags: FortunicaBrand().freshChatCategories(locale),
                faqTitle: SFortunica.of(context).customerSupportFortunica,
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

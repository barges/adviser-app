import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/support/support_cubit.dart';
import 'package:zodiac/presentation/screens/support/support_state.dart';
import 'package:zodiac/zodiac.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportCubit(
        freshChatService: zodiacGetIt.get<FreshChatService>(),
        cachingManager: zodiacGetIt.get<ZodiacCachingManager>(),
        userRepository: zodiacGetIt.get<ZodiacUserRepository>(),
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
                contactUsTags: ZodiacBrand().freshChatTags(locale),
                faqTags: ZodiacBrand().freshChatCategories(locale),
                faqTitle: SZodiac.of(context).customerSupportZodiac,
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

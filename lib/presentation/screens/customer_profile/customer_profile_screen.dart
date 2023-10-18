import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/app_error/app_error.dart';
import '../../../data/models/enums/zodiac_sign.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../main_cubit.dart';
import '../../common_widgets/appbar/chat_conversation_app_bar.dart';
import '../../common_widgets/customer_profile/customer_profile_widget.dart';
import '../../common_widgets/messages/app_error_widget.dart';
import 'customer_profile_screen_cubit.dart';

class CustomerProfileScreen extends StatelessWidget {
  final CustomerProfileScreenArguments customerProfileScreenArguments;

  const CustomerProfileScreen({
    Key? key,
    required this.customerProfileScreenArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerProfileScreenCubit(
        fortunicaGetIt.get<MainCubit>(),
        customerProfileScreenArguments,
      ),
      child: Builder(builder: (context) {
        final CustomerProfileScreenCubit customerProfileScreenCubit =
            context.read<CustomerProfileScreenCubit>();

        final CustomerProfileScreenArguments? appBarUpdateArguments =
            context.select((CustomerProfileScreenCubit cubit) =>
                cubit.state.appBarUpdateArguments);
        final AppError appError =
            context.select((MainCubit cubit) => cubit.state.appError);
        return Scaffold(
          appBar: ChatConversationAppBar(
            title: appBarUpdateArguments?.clientName,
            zodiacSign: appBarUpdateArguments?.zodiacSign,
          ),
          body: Column(
            children: [
              AppErrorWidget(
                errorMessage: appError.getMessage(context),
                close: customerProfileScreenCubit.closeErrorWidget,
              ),
              appBarUpdateArguments?.customerID != null
                  ? Expanded(
                      child: CustomerProfileWidget(
                        customerId: appBarUpdateArguments!.customerID!,
                        updateClientInformationCallback:
                            customerProfileScreenCubit.updateAppBarInformation,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      }),
    );
  }
}

class CustomerProfileScreenArguments {
  final String? customerID;
  final String? clientName;
  final ZodiacSign? zodiacSign;

  const CustomerProfileScreenArguments({
    this.customerID,
    this.clientName,
    this.zodiacSign,
  });
}

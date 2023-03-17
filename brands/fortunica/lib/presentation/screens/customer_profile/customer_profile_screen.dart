import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:fortunica/data/models/enums/zodiac_sign.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:fortunica/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen_cubit.dart';

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
        fortunicaGetIt.get<FortunicaMainCubit>(),
        customerProfileScreenArguments,
      ),
      child: Builder(builder: (context) {
        final CustomerProfileScreenCubit customerProfileScreenCubit =
            context.read<CustomerProfileScreenCubit>();

        final CustomerProfileScreenArguments? appBarUpdateArguments =
            context.select((CustomerProfileScreenCubit cubit) =>
                cubit.state.appBarUpdateArguments);
        final AppError appError =
            context.select((FortunicaMainCubit cubit) => cubit.state.appError);
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

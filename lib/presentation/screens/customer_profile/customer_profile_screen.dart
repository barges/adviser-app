import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_screen_cubit.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerProfileScreenCubit(getIt.get<MainCubit>()),
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

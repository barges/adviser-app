import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_screen_cubit.dart';

class CustomerProfileScreen extends StatelessWidget {
 const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerProfileScreenCubit(),
      child: Builder(builder: (context) {
        final CustomerProfileScreenCubit customerProfileScreenCubit =
            context.read<CustomerProfileScreenCubit>();

        final CustomerProfileScreenArguments? appBarUpdateArguments =
            context.select((CustomerProfileScreenCubit cubit) =>
                cubit.state.appBarUpdateArguments);
        return Scaffold(
          appBar: ChatConversationAppBar(
            title: appBarUpdateArguments?.clientName,
            zodiacSign: appBarUpdateArguments?.zodiacSign,
          ),
          body: appBarUpdateArguments?.customerID != null
              ? CustomerProfileWidget(
                  customerId: appBarUpdateArguments!.customerID!,
                  updateClientInformationCallback:
                      customerProfileScreenCubit.updateAppBarInformation,
                )
              : const SizedBox.shrink(),
        );
      }),
    );
  }
}

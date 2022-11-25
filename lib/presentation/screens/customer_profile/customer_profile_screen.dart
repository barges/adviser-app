import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerProfileScreenArguments arguments = Get.arguments;
    return Scaffold(
      appBar: ChatConversationAppBar(
        title: arguments.clientName,
        zodiacSign: arguments.zodiacSign,
      ),
      body: CustomerProfileWidget(
        customerId: arguments.customerID,
      ),
    );
  }
}

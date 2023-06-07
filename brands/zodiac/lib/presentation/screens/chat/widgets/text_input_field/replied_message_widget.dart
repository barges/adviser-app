import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/chat_text_input_widget.dart';

class RepliedMessageWidget extends StatelessWidget {
  const RepliedMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.d('sdfdsf');
      },
      child: Container(
        height: repliedMessageHeight,
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
      ),
    );
  }
}

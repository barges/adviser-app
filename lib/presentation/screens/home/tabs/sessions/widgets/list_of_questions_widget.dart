import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/model/question.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/chat_list_tile_widget.dart';

class ListOfQuestionsWidget extends StatelessWidget {
  final List<Question> questions;

  const ListOfQuestionsWidget({Key? key, required this.questions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) =>
            ChatListTileWidget(question: questions[index]),
        itemCount: questions.length);
  }
}

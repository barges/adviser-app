import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChatItem> items =
        context.select((ChatCubit cubit) => cubit.state.activeMessages);
    ChatItem? question;
    if (items.isNotEmpty) {
      question = items.last;
    }

    if (question == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          border: Border.all(
            width: 1.0,
            color: Theme.of(context).hintColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  S.of(context).personalDetails,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).shadowColor,
                        fontSize: 13.0,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  question.clientName ?? '',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).hoverColor,
                        fontSize: 17.0,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (question.clientInformation != null &&
                      question.clientInformation!.birthdate != null)
                    Text(
                      DateFormat(datePattern1)
                          .format(question.clientInformation!.birthdate!),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).shadowColor,
                          ),
                    ),
                  if (question.clientInformation != null &&
                      question.clientInformation!.gender != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 4.0,
                        width: 4.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  if (question.clientInformation != null &&
                      question.clientInformation!.gender != null)
                    Text(
                      toBeginningOfSentenceCase(
                          question.clientInformation!.gender!.name)!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).shadowColor,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

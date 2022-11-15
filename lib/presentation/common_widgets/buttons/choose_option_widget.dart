import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChooseOptionWidget extends StatelessWidget {
  final List<String> options;
  final int currentIndex;
  final ValueChanged<int>? onChangeOptionIndex;

  const ChooseOptionWidget({
    Key? key,
    required this.options,
    required this.currentIndex,
    required this.onChangeOptionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options
            .mapIndexed(
              (element, index) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onChangeOptionIndex != null) {
                      onChangeOptionIndex!(index);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius)),
                    child: Text(
                      element,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: currentIndex == index
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

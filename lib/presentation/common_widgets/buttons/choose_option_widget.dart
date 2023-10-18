import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../app_constants.dart';

class ChooseOptionWidget extends StatelessWidget {
  final List<String> options;
  final int currentIndex;
  final ValueChanged<int>? onChangeOptionIndex;
  final List<int> disabledIndexes;

  const ChooseOptionWidget({
    Key? key,
    required this.options,
    required this.currentIndex,
    required this.onChangeOptionIndex,
    this.disabledIndexes = const [],
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
        children: options.mapIndexed(
          (index, element) {
            final bool isDisabled = disabledIndexes.contains(index);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!isDisabled && onChangeOptionIndex != null) {
                    onChangeOptionIndex!(index);
                  }
                },
                child: Opacity(
                  opacity: isDisabled ? 0.4 : 1.0,
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
            );
          },
        ).toList(),
      ),
    );
  }
}

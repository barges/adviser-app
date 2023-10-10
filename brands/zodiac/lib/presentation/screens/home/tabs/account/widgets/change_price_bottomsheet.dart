import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:zodiac/generated/l10n.dart';

Future<void> changePriceBottomsheet({
  required BuildContext context,
  required int integerNumberPart,
  required int fractionalNumberPart,
  required ValueChanged<double> onDone,
}) async {
  final ThemeData theme = Theme.of(context);
  final FixedExtentScrollController integerPartScrollController =
      FixedExtentScrollController(initialItem: integerNumberPart);
  final FixedExtentScrollController fractionalPartScrollController =
      FixedExtentScrollController(initialItem: fractionalNumberPart);

  showModalBottomSheet(
      context: context,
      shape: const BeveledRectangleBorder(),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52.0,
              color: theme.scaffoldBackgroundColor,
              padding:
                  const EdgeInsets.all(AppConstants.horizontalScreenPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      SZodiac.of(context).cancelZodiac,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    SZodiac.of(context).youCanChangePriceOncePer24HZodiac,
                    style: theme.textTheme.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      final double newValue = integerPartScrollController
                              .selectedItem +
                          (fractionalPartScrollController.selectedItem % 100) /
                              100;
                      onDone(newValue);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      SZodiac.of(context).doneZodiac,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 15.0,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 216.0,
                child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 34.0,
                              onSelectedItemChanged: (_) {},
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                capEndEdge: false,
                              ),
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '\$',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(fontSize: 16.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: integerPartScrollController,
                              itemExtent: 34.0,
                              onSelectedItemChanged: (_) {},
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                capStartEdge: false,
                                capEndEdge: false,
                              ),
                              children: List.generate(
                                200,
                                (i) => Center(
                                  child: Text(
                                    i.toString(),
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(fontSize: 23.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: fractionalPartScrollController,
                              looping: true,
                              itemExtent: 34.0,
                              onSelectedItemChanged: (_) {},
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                capStartEdge: false,
                                capEndEdge: false,
                              ),
                              children: List.generate(
                                100,
                                (i) => Center(
                                  child: Text(
                                    i.toString(),
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(fontSize: 23.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CupertinoPicker(
                              itemExtent: 34.0,
                              onSelectedItemChanged: (_) {},
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                capStartEdge: false,
                              ),
                              children: [
                                Center(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      SZodiac.of(context).perMinuteZodiac,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(fontSize: 16.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
          ],
        );
      });
}

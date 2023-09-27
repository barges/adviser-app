import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';

class InformationExpansionPanel extends StatefulWidget {
  final String title;
  final String content;

  const InformationExpansionPanel({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<InformationExpansionPanel> createState() =>
      _InformationExpansionPanelState();
}

class _InformationExpansionPanelState extends State<InformationExpansionPanel> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) => setState(() {
          logger.d(isExpanded);
          this.isExpanded = !this.isExpanded;
        }),
        expandedHeaderPadding: EdgeInsets.zero,
        expandIconColor: theme.shadowColor,
        elevation: 0,
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            canTapOnHeader: true,
            isExpanded: isExpanded,
            headerBuilder: (context, isExpanded) => Row(
              children: [
                Assets.zodiac.vectors.infoSquareLarge.svg(
                    height: 32.0,
                    width: 32.0,
                    fit: BoxFit.fill,
                    colorFilter:
                        ColorFilter.mode(theme.shadowColor, BlendMode.srcIn)),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 14.0,
                    ),
                  ),
                )
              ],
            ),
            body: Text(
              widget.content,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 14.0,
                color: theme.shadowColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

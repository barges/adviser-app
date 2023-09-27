import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/enums/approval_status.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final ValidationErrorType errorType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final int? maxLength;
  final bool isPassword;
  final bool isBig;
  final bool showCounter;
  final String? footerHint;
  final ApprovalStatus? approvalStatus;
  final bool cutMaxLength;

  const AppTextField({
    Key? key,
    this.focusNode,
    this.label,
    this.controller,
    this.nextFocusNode,
    this.textInputType,
    this.textInputAction,
    this.maxLength,
    this.footerHint,
    this.approvalStatus,
    this.isPassword = false,
    this.isBig = false,
    this.errorType = ValidationErrorType.empty,
    this.hintText = '',
    this.showCounter = false,
    this.cutMaxLength = false,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late int currentLength;

  @override
  void initState() {
    super.initState();
    currentLength = widget.controller?.text.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final String? approvalText = widget.approvalStatus?.getText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  bottom: 4.0,
                ),
                child: Text(
                  widget.label!,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            if (approvalText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: _ApprovalStatusWidget(
                  approvalStatus: widget.approvalStatus!,
                ),
              ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: widget.errorType != ValidationErrorType.empty
                ? theme.errorColor
                : widget.focusNode != null && widget.focusNode!.hasPrimaryFocus
                    ? theme.primaryColor
                    : theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: widget.isBig ? null : AppConstants.textFieldsHeight - 3,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: theme.canvasColor,
            ),
            padding: EdgeInsets.only(bottom: widget.showCounter ? 12.0 : 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: widget.isBig
                      ? EdgeInsets.fromLTRB(
                          12.0, 12.0, 12.0, widget.showCounter ? 0.0 : 12.0)
                      : const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    keyboardType: widget.textInputType,
                    textInputAction: widget.textInputAction,
                    maxLength: widget.cutMaxLength ? widget.maxLength : null,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    },
                    onChanged: (value) =>
                        setState(() => currentLength = value.length),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.shadowColor),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      counterText: '',
                    ),
                    maxLines: widget.isBig ? 5 : 1,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                if (widget.showCounter)
                  _CounterWidget(
                    currentLength: currentLength,
                    maxLength: widget.maxLength,
                  )
              ],
            ),
          ),
        ),
        if (widget.errorType != ValidationErrorType.empty)
          _FooterTextWidget(
            text: widget.errorType.text(context),
            color: theme.errorColor,
          )
        else if (widget.footerHint != null)
          _FooterTextWidget(
            text: widget.footerHint!,
            color: theme.shadowColor,
          )
      ],
    );
  }
}

class _ApprovalStatusWidget extends StatelessWidget {
  final ApprovalStatus approvalStatus;
  const _ApprovalStatusWidget({
    Key? key,
    required this.approvalStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 6.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: approvalStatus.color,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            approvalStatus.iconPath,
            height: 10.0,
            width: 10.0,
            colorFilter: ColorFilter.mode(
              approvalStatus.color,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            approvalStatus.getText(context)?.toUpperCase() ?? '',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 12.0,
                  color: approvalStatus.color,
                ),
          )
        ],
      ),
    );
  }
}

class _CounterWidget extends StatelessWidget {
  final int currentLength;
  final int? maxLength;
  const _CounterWidget({
    Key? key,
    required this.currentLength,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (maxLength != null) {
      final bool limitReached = currentLength > maxLength!;
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          '$currentLength/$maxLength',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 14.0,
            color: limitReached ? AppColors.error : AppColors.online,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _FooterTextWidget extends StatelessWidget {
  final String text;
  final Color color;

  const _FooterTextWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 2.0,
        left: 12.0,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontSize: 12.0,
        ),
      ),
    );
  }
}

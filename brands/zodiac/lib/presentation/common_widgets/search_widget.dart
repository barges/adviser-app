import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final bool isBorder;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  final VoidCallback? onCancel;

  const SearchWidget({
    Key? key,
    required this.onChanged,
    this.backgroundColor,
    this.autofocus = false,
    this.isBorder = true,
    this.focusNode,
    this.onCancel,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final BehaviorSubject _searchStream = BehaviorSubject<String>();

  late final StreamSubscription _searchSubscription;

  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchSubscription = _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((text) async {
      widget.onChanged(text);
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchSubscription.cancel();
    _searchStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = widget.backgroundColor ?? theme.hintColor;
    final bool hasCancelButton = widget.onCancel != null;
    return Container(
      alignment: Alignment.center,
      height: AppConstants.appBarHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        border: widget.isBorder
            ? Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: theme.hintColor,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  AppConstants.horizontalScreenPadding,
                  9.0,
                  hasCancelButton ? 8.0 : AppConstants.horizontalScreenPadding,
                  9.0),
              height: AppConstants.iconButtonSize,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(
                  AppConstants.buttonRadius,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 8.0,
                    ),
                    child: Assets.vectors.search.svg(
                      color: theme.shadowColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: widget.autofocus,
                      focusNode: widget.focusNode,
                      controller: _searchTextController,
                      onChanged: (text) {
                        _searchStream.add(text);
                      },
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 17.0,
                      ),
                      decoration: InputDecoration(
                        hintText: SZodiac.of(context).searchZodiac,
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 17.0,
                          color: theme.shadowColor,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 4.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasCancelButton)
            GestureDetector(
              onTap: () {
                _searchTextController.clear();
                _searchStream.add('');
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
              },
              child: Container(
                height: AppConstants.iconButtonSize,
                width: AppConstants.iconButtonSize,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                  color: backgroundColor,
                ),
                child: Assets.zodiac.vectors.crossSmall.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                  color: theme.primaryColor,
                ),
              ),
            )
        ],
      ),
    );
  }
}

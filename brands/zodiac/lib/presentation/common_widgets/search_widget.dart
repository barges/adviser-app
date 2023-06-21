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
  final bool hasCancelButton;
  final Color? backgroundColor;
  final ValueChanged<bool>? onFocused;

  const SearchWidget({
    Key? key,
    required this.onChanged,
    this.backgroundColor,
    this.onFocused,
    this.autofocus = false,
    this.isBorder = true,
    this.hasCancelButton = false,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final BehaviorSubject _searchStream = BehaviorSubject<String>();

  late final StreamSubscription _searchSubscription;

  final TextEditingController _searchTextController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchSubscription = _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((text) async {
      widget.onChanged(text);
    });

    if (widget.onFocused != null) {
      _searchFocusNode.addListener(() {
        widget.onFocused!(_searchFocusNode.hasFocus);
      });
    }
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchSubscription.cancel();
    _searchStream.close();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = widget.backgroundColor ?? theme.hintColor;
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
                  widget.hasCancelButton
                      ? 8.0
                      : AppConstants.horizontalScreenPadding,
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
                      focusNode: _searchFocusNode,
                      autofocus: widget.autofocus,
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
          if (widget.hasCancelButton)
            GestureDetector(
              onTap: () {
                _searchTextController.clear();
                _searchStream.add('');
              },
              child: Container(
                height: AppConstants.iconButtonSize,
                width: AppConstants.iconButtonSize,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                  color: backgroundColor,
                ),
                child: Assets.vectors.cross.svg(
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SearchWidget({Key? key, required this.onChanged}) : super(key: key);

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
    _searchSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      height: AppConstants.appBarHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: theme.hintColor,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 9.0,
          horizontal: AppConstants.horizontalScreenPadding,
        ),
        height: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          color: theme.hintColor,
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
    );
  }
}

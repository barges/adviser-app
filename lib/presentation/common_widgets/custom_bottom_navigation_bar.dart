import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<CustomBottomNavigationItem> items;
  final Color backgroundColor;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.items,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 2.0,
        ),
        Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items
                  .mapIndexed(
                    (index, child) => InkWell(
                      onTap: () => onTap(index),
                      child: child,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomBottomNavigationItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final TextStyle? labelStyle;
  final Color activeColor;
  final Color inactiveColor;
  final bool isSelected;

  const CustomBottomNavigationItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.inactiveColor,
    required this.isSelected,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(
          height: 4.0,
        ),
        Text(
          label,
          style: labelStyle?.copyWith(
            color: isSelected ? activeColor : inactiveColor,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

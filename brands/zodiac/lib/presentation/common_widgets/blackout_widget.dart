import 'package:flutter/material.dart';

class BlackoutWidget extends StatelessWidget {
  final Widget child;
  const BlackoutWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0),
          ],
          stops: const [0.2619, 1],
        ),
      ),
      child: child,
    );
  }
}

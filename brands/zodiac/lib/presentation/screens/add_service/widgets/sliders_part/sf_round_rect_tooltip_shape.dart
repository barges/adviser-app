import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

const double tooltipTriangleHeight = 4.0;
const double tooltipTriangleWidth = 8.0;

class SfRoundRectangularTooltipShape extends SfTooltipShape {
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final Color color;
  final TextStyle? textStyle;

  SfRoundRectangularTooltipShape({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.cornerRadius,
    required this.color,
    this.textStyle,
  });

  Path _updateRectangularTooltipWidth(
    Size textSize,
    double tooltipStartY,
    Rect trackRect,
    double dx,
  ) {
    final double dy = tooltipStartY + tooltipTriangleHeight;
    final double tooltipWidth = textSize.width + horizontalPadding * 2;
    final double tooltipHeight = textSize.height + verticalPadding * 2;
    final double halfTooltipWidth = tooltipWidth / 2;
    //  final double halfTooltipHeight = tooltipHeight / 2;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;

    double rightLineWidth = halfTooltipWidth;
    final double leftLineWidth = tooltipWidth - rightLineWidth;

    return _getRectangularPath(
      tooltipStartY,
      rightLineWidth,
      halfTooltipTriangleWidth,
      dy,
      tooltipHeight,
      leftLineWidth,
    );
  }

  Path _getRectangularPath(
    double tooltipStartY,
    double rightLineWidth,
    double halfTooltipTriangleWidth,
    double dy,
    double tooltipHeight,
    double leftLineWidth, {
    double? toolTipWidth,
  }) {
    final Path path = Path();

    path.moveTo(0, -tooltipStartY);
    //    /
    final bool canAdjustTooltipNose =
        rightLineWidth > halfTooltipTriangleWidth + cornerRadius / 2;
    path.lineTo(
        canAdjustTooltipNose ? halfTooltipTriangleWidth : rightLineWidth,
        -dy - (canAdjustTooltipNose ? 0 : cornerRadius / 2));
    //      ___
    //     /
    path.lineTo(rightLineWidth - cornerRadius, -dy);
    //      ___|
    //     /
    path.quadraticBezierTo(
        rightLineWidth, -dy, rightLineWidth, -dy - cornerRadius);
    path.lineTo(rightLineWidth, -dy - tooltipHeight + cornerRadius);
    //  _______
    //      ___|
    //     /
    path.quadraticBezierTo(rightLineWidth, -dy - tooltipHeight,
        rightLineWidth - cornerRadius, -dy - tooltipHeight);
    path.lineTo(-leftLineWidth + cornerRadius, -dy - tooltipHeight);
    //  _______
    // |    ___|
    //     /
    path.quadraticBezierTo(-leftLineWidth, -dy - tooltipHeight, -leftLineWidth,
        -dy - tooltipHeight + cornerRadius);
    path.lineTo(-leftLineWidth, -dy - cornerRadius);
    //  ________
    // |___  ___|
    //      /
    if (leftLineWidth > halfTooltipTriangleWidth) {
      path.quadraticBezierTo(
          -leftLineWidth, -dy, -leftLineWidth + cornerRadius, -dy);
      path.lineTo(-halfTooltipTriangleWidth, -dy);
    }
    //  ________
    // |___  ___|
    //     \/
    path.close();

    return path;
  }

  /// Draws the tooltip based on the values passed in the arguments.
  @override
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {required RenderBox parentBox,
      required dynamic sliderThemeData,
      required Paint paint,
      required Animation<double> animation,
      required Rect trackRect}) {
    // ignore: avoid_as
    final Path path = _updateRectangularTooltipWidth(
      textPainter.size,
      offset.dy,
      trackRect,
      thumbCenter.dx,
    );

    context.canvas.save();
    context.canvas.translate(thumbCenter.dx, thumbCenter.dy);
    context.canvas.scale(animation.value);
    final Paint strokePaint = Paint();

    strokePaint
      ..color = color
      ..style = PaintingStyle.stroke;

    context.canvas.drawPath(path, strokePaint);
    context.canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);

    final Rect pathRect = path.getBounds();
    final double halfTextPainterWidth = textPainter.width / 2;

    final double dx = -halfTextPainterWidth;

    final double dy = offset.dy +
        tooltipTriangleHeight +
        (pathRect.size.height - tooltipTriangleHeight) / 2 +
        textPainter.height / 2;

    textPainter.paint(context.canvas, Offset(dx, -dy));

    context.canvas.restore();
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Widget? trailingIcon;
  VoidCallback? onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      required this.title,
      this.trailingIcon,
      this.onPressed});
}

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final Widget? menuSeparator;
  final double? menuBorderRadius;
  final Widget? topMenuWidget;
  final VoidCallback? onHold;
  final VoidCallback? onClose;
  final double? topMenuWidgetHeight;
  final ChatCubit? cubit;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const FocusedMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.menuSeparator,
      this.menuBorderRadius,
      this.topMenuWidget,
      this.topMenuWidgetHeight,
      this.onHold,
      this.onClose,
      this.cubit,
      this.openWithTap = false})
      : assert((topMenuWidget != null && topMenuWidgetHeight != null) ||
            (topMenuWidget == null && topMenuWidgetHeight == null)),
        super(key: key);

  @override
  State<FocusedMenuHolder> createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset.zero;
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            if (widget.onHold != null) {
              widget.onHold!();
            }
            await openMenu(context);
          }
        },
        child: SizedBox(
          key: containerKey,
          child: widget.child,
        ));
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration:
                widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);

              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    menuSeparator: widget.menuSeparator,
                    menuBorderRadius: widget.menuBorderRadius,
                    topMenuWidget: widget.topMenuWidget,
                    topMenuWidgetHeight: widget.topMenuWidgetHeight,
                    child: widget.cubit != null
                        ? BlocProvider.value(
                            value: widget.cubit!,
                            child: widget.child,
                          )
                        : widget.child,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
    if (widget.onClose != null) {
      widget.onClose!();
    }
  }
}

class FocusedMenuDetails extends StatefulWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final Widget? menuSeparator;
  final double? menuBorderRadius;
  final Widget? topMenuWidget;
  final double? topMenuWidgetHeight;

  const FocusedMenuDetails({
    Key? key,
    required this.menuItems,
    required this.child,
    required this.childOffset,
    required this.childSize,
    required this.menuBoxDecoration,
    required this.itemExtent,
    required this.animateMenu,
    required this.blurSize,
    required this.blurBackgroundColor,
    required this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.menuBorderRadius,
    this.menuSeparator,
    this.topMenuWidget,
    this.topMenuWidgetHeight,
  }) : super(key: key);

  @override
  State<FocusedMenuDetails> createState() => _FocusedMenuDetailsState();
}

class _FocusedMenuDetailsState extends State<FocusedMenuDetails> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // final maxMenuHeight = size.height * 0.45;
    final menuHeight = widget.menuItems.length * (widget.itemExtent ?? 50.0) +
        (widget.menuSeparator != null
            ? widget.menuItems.length - 1 * 8.0
            : 0.0);

    final maxMenuWidth = widget.menuWidth ?? (size.width * 0.70);
    //  final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    // final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
    //     ? childOffset.dx
    //     : (childOffset.dx - maxMenuWidth + childSize!.width);

    final noVerticalOverflow =
        (widget.childOffset.dy + menuHeight + widget.childSize!.height) <
            size.height -
                widget.bottomOffsetHeight! -
                MediaQuery.of(context).padding.bottom -
                MediaQuery.of(context).padding.top;

    final childPositionDy = noVerticalOverflow
        ? widget.childOffset.dy
        : widget.childOffset.dy - menuHeight - widget.bottomOffsetHeight!;

    //final topOffset = childPositionDy + childSize!.height + menuOffset!;

    final bottomOffset =
        size.height - childPositionDy + (widget.menuOffset ?? 0.0);

    final bool messageOverflows = ((widget.childSize?.height ?? 0.0) +
            menuHeight +
            (widget.topMenuWidgetHeight ?? 0.0) +
            MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom >
        size.height + (widget.childOffset.dy < 0 ? widget.childOffset.dy : 0));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: widget.blurSize ?? 4, sigmaY: widget.blurSize ?? 4),
                child: Container(
                  color: (widget.blurBackgroundColor ?? Colors.black)
                      .withOpacity(0.7),
                ),
              )),
          Positioned(
            // top: topOffset,
            // left: leftOffset,
            top: messageOverflows ? 0.0 : childPositionDy,
            left: widget.childOffset.dx,
            bottom: messageOverflows ? widget.bottomOffsetHeight : null,

            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: messageOverflows
                        ? 50 +
                            (widget.topMenuWidgetHeight ?? 0) +
                            (widget.menuOffset ?? 0)
                        : 0.0,
                  ),
                  AbsorbPointer(
                    absorbing: true,
                    child: SizedBox(
                        width: widget.childSize!.width,
                        height: widget.childSize!.height,
                        child: widget.child),
                  ),
                  if (widget.menuOffset != null)
                    SizedBox(
                      height: widget.menuOffset,
                    ),
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 200),
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      return Transform.scale(
                        scale: value,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    tween: Tween(begin: 0.0, end: 1.0),
                    child: Container(
                      width: maxMenuWidth,
                      height: menuHeight + 11.0,
                      decoration: widget.menuBoxDecoration ??
                          BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  widget.menuBorderRadius ?? 5.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 10,
                                    spreadRadius: 1)
                              ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            widget.menuBorderRadius ?? 5.0),
                        child: ListView.separated(
                          itemCount: widget.menuItems.length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              widget.menuSeparator ?? const SizedBox.shrink(),
                          itemBuilder: (context, index) {
                            FocusedMenuItem item = widget.menuItems[index];
                            Widget listItem = GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (item.onPressed != null) {
                                    item.onPressed!();
                                  }
                                },
                                child: Container(
                                    //alignment: Alignment.center,
                                    // margin: const EdgeInsets.only(bottom: 1),
                                    color: item.backgroundColor ?? Colors.white,
                                    height: widget.itemExtent ?? 50.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 11.0, horizontal: 16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          item.title,
                                          if (item.trailingIcon != null) ...[
                                            item.trailingIcon!
                                          ]
                                        ],
                                      ),
                                    )));
                            if (widget.animateMenu) {
                              return TweenAnimationBuilder(
                                  builder: (context, dynamic value, child) {
                                    return Transform(
                                      transform:
                                          Matrix4.rotationX(1.5708 * value),
                                      alignment: Alignment.bottomCenter,
                                      child: child,
                                    );
                                  },
                                  tween: Tween(begin: 1.0, end: 0.0),
                                  duration: Duration(milliseconds: index * 200),
                                  child: listItem);
                            } else {
                              return listItem;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //     top: childPositionDy,
          //     left: childOffset.dx,
          //     child: AbsorbPointer(
          //         absorbing: false,
          //         child: SizedBox(
          //             width: childSize!.width,
          //             height: childSize!.height,
          //             child: child))),
          if (widget.topMenuWidget != null &&
              widget.topMenuWidgetHeight != null)
            Positioned(
                top: messageOverflows ? 50.0 : null,
                bottom: messageOverflows ? null : bottomOffset,
                left: widget.childOffset.dx,
                child: TweenAnimationBuilder(
                  duration: Duration(milliseconds: 200),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return Transform.scale(
                      scale: value,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  tween: Tween(begin: 0.0, end: 1.0),
                  child: widget.topMenuWidget,
                )),
        ],
      ),
    );
  }
}

library gradient_fab;

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

class GradientFab extends StatefulWidget {
  // Gradient Fab decoration. The decoration can have customized gradient and border Radius.
  final Decoration decoration;

  final Duration animationDuration;

  final AnimatedIconData animatedIconData;

  final Color animatedIconColor;

  final VoidCallback onOpen;

  final VoidCallback onClose;

  final List<FabChild> children;

  // if ScrollController is not null, the GradientFab will go hide on scroll
  final ScrollController controller;

  const GradientFab(
      {Key key,
      this.decoration,
      this.animationDuration,
      this.animatedIconData,
      this.animatedIconColor,
      this.children,
      this.onOpen,
      this.onClose,
      this.controller})
      : super(key: key);

  @override
  _GradientFabState createState() => _GradientFabState();
}

class _GradientFabState extends State<GradientFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;
  bool _isOpen;
  bool _isVis;
  bool _isClosingProgress;

  @override
  void didUpdateWidget(GradientFab oldWidget) {
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration =
          widget.animationDuration ?? Duration(milliseconds: 500);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _isVis = true;
    _isClosingProgress = false;
    if (widget.controller != null)
      widget.controller.addListener(() {
        if (widget.controller.hasClients &&
            widget.controller.position.userScrollDirection ==
                ScrollDirection.forward) {
          if (!_isVis) {
            setState(() {
              _isVis = true;
            });
          }
        } else if (widget.controller.hasClients &&
            widget.controller.position.userScrollDirection ==
                ScrollDirection.reverse) {
          if (_isVis && !_isClosingProgress) {
            if (_isOpen) {
              _isClosingProgress = true;
              _controller.reverse().then((value) {
                _isClosingProgress = false;
                setState(() {
                  _isVis = false;
                });
              });
            } else {
              setState(() {
                _isVis = false;
              });
            }
          }
        }
      });
    _isOpen = false;
    _controller = AnimationController(
      duration: widget.animationDuration ?? Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggleButton() {
    if (!_isOpen) {
      _controller.forward(from: 0);
      if (widget.onOpen != null) widget.onOpen();
    } else {
      _controller.reverse();
      if (widget.onClose != null) widget.onClose();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  List<Widget> renderButton() {
    List<FabChild> temp = widget.children ?? List();
    List<Widget> toReturn = temp
        .map(
          (child) => Container(
            height: 50 * animation.value,
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                child.iconData,
                size: 24 * animation.value,
                color: child.iconColor,
              ),
              onPressed: child.onPress,
            ),
          ),
        )
        .toList()
          ..add(Container(
            height: 50,
            alignment: Alignment.center,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              color: Colors.white,
              progress: _controller,
            ),
          ));

    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomRight,
      children: [
        AnimatedPositioned(
          right: _isVis ? 0 : -90,
          duration: Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: _toggleButton,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, anim) {
                return Container(
                    height: ((widget.children == null
                                ? 0
                                : widget.children.length) *
                            50 *
                            animation.value) +
                        50.0,
                    width: 50,
                    alignment: Alignment.bottomCenter,
                    decoration: widget.decoration ??
                        BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.indigo[300],
                                  Colors.indigo[900],
                                ]),
                            borderRadius: BorderRadius.circular(50)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: renderButton()));
              },
            ),
          ),
        )
      ],
    );
  }
}

class FabChild {
  Color iconColor;
  IconData iconData;
  VoidCallback onPress;
  FabChild({
    this.iconColor = Colors.white,
    @required this.iconData,
    @required this.onPress,
  });
}

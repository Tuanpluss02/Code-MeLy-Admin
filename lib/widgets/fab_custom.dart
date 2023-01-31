// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed1;
  final String tooltip1;
  final Icon icon1;
  final Function() onPressed2;
  final String tooltip2;
  final Icon icon2;

  const FancyFab(
      {Key? key,
      required this.onPressed1,
      required this.tooltip1,
      required this.icon1,
      required this.onPressed2,
      required this.tooltip2,
      required this.icon2})
      : super(key: key);

  @override
  State<FancyFab> createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.purple,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  // Widget add() {
  //   return const FloatingActionButton(
  //     onPressed: null,
  //     tooltip: 'Add',
  //     child: Icon(Icons.add),
  //   );
  // }

  Widget button2() {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: widget.onPressed2,
      tooltip: widget.tooltip2,
      child: widget.icon2,
    );
  }

  Widget button1() {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: widget.onPressed1,
      tooltip: widget.tooltip1,
      child: widget.icon1,
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      // backgroundColor: Colors.purple,
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Transform(
        //   transform: Matrix4.translationValues(
        //     0.0,
        //     _translateButton.value * 3.0,
        //     0.0,
        //   ),
        //   child: add(),
        // ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: button2(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: button1(),
        ),
        toggle(),
      ],
    );
  }
}

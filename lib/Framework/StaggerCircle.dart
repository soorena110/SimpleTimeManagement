import 'package:flutter/material.dart';

import 'CircleIcon.dart';

class StaggerCircle extends StatefulWidget {
  final IconData icon;
  final Color backgroundColor;

  StaggerCircle(this.icon, this.backgroundColor);

  @override
  State<StatefulWidget> createState() {
    return StaggerCircleState();
  }
}

class StaggerCircleState extends State<StaggerCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _rotationAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));
    _rotationAnimation = Tween(begin: -.3, end: .6).animate(new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut));
    _scaleAnimation = Tween(begin: -.5, end: .5).animate(new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut));

    _animationController.addListener(() {
      if (_animationController.isCompleted) _animationController.reverse();
      if (_animationController.isDismissed) _animationController.forward();
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _alarmingCircle(BuildContext context, Widget child) {
    return Transform.scale(
        scale: .5 + _scaleAnimation.value.abs(),
        child: Transform.rotate(
          angle: _rotationAnimation.value,
          child: CircleIcon(widget.icon, widget.backgroundColor),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController, builder: _alarmingCircle);
  }
}

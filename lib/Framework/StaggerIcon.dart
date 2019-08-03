import 'package:flutter/material.dart';

class StaggerIcon extends StatefulWidget {
  final IconData icon;
  final bool isActive;

  StaggerIcon(this.icon, {this.isActive = false});

  @override
  State<StatefulWidget> createState() {
    return StaggerIconState();
  }
}

class StaggerIconState extends State<StaggerIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _rotationAnimation;
  Animation<double> _scaleAnimation;

  bool _isActive;

  @override
  void initState() {
    super.initState();

    _isActive = widget.isActive;
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

    if (widget.isActive) _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _isActive = widget.isActive;
    });
    if (widget.isActive)
      _animationController.forward();
    else
      _animationController.stop();
  }

  Widget _alarmingIcon(BuildContext context, Widget child) {
    return Transform.scale(
        scale: .5 + _scaleAnimation.value.abs(),
        child: Transform.rotate(
            angle: _rotationAnimation.value, child: Icon(widget.icon)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isActive)
      return AnimatedBuilder(
          animation: _animationController, builder: _alarmingIcon);
    return Icon(widget.icon);
  }
}

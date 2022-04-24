import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoneIcon extends StatefulWidget {
  @override
  _DoneIconState createState() => _DoneIconState();
}

class _DoneIconState extends State<DoneIcon>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AnimationController _controller;

  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: Lottie.asset(
        'assets/done.json',
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = Duration(milliseconds: 2000)
            ..forward();

          _controller.isCompleted
              ? Navigator.of(context).pushReplacementNamed('/')
              : null;
        },
      ),
    );
  }
}

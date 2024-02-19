import 'dart:async';
import 'package:flutter/material.dart';

class SessionTimeoutListener extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onTimeOut;

  SessionTimeoutListener({
    Key? key,
    required this.child,
    required this.duration,
    required this.onTimeOut,
  }) : super(key: key);

  @override
  State<SessionTimeoutListener> createState() => _SessionTimeOutListenerState();
}

class _SessionTimeOutListenerState extends State<SessionTimeoutListener>
    with WidgetsBindingObserver {
  Timer? _timer;

  void _startTimer() {
    print('TIMER HAS BEEN RESET');
    _timer?.cancel();

    _timer = Timer(widget.duration, () {
      widget.onTimeOut();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _startTimer();
      },
      child: widget.child,
    );
  }
}

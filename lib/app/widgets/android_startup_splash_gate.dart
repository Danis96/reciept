import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AndroidStartupSplashGate extends StatefulWidget {
  const AndroidStartupSplashGate({required this.child, super.key});

  final Widget child;

  @override
  State<AndroidStartupSplashGate> createState() =>
      _AndroidStartupSplashGateState();
}

class _AndroidStartupSplashGateState extends State<AndroidStartupSplashGate> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 700);

  bool _showSplash = defaultTargetPlatform == TargetPlatform.android;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!_showSplash) {
      return;
    }
    _timer = Timer(_minimumSplashDuration, _hideSplash);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_showSplash) {
      precacheImage(const AssetImage('assets/splash.png'), context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _hideSplash() {
    if (!mounted) {
      return;
    }
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _showSplash
          ? const ColoredBox(
              key: ValueKey<String>('android-startup-splash'),
              color: Color(0xFFDE6834),
              child: SizedBox.expand(
                child: Image(
                  image: AssetImage('assets/splash.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : widget.child,
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final String route;
  final Future<bool> Function() loadCondition;
  final Map<String, dynamic>? args;

  const LoadingScreen(
      {super.key,
      required this.route,
      required this.loadCondition,
      required this.args});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await widget.loadCondition()) {
        _timer.cancel();
        Navigator.pushNamed(context, widget.route, arguments: widget.args);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

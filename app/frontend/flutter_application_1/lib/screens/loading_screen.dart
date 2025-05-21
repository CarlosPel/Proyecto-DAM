// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/data/user_data.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await _checkCondition()) {
        _timer.cancel();
        Navigator.pushNamed(context, AppRoutes.homeScreen);
      }
    });
  }

  Future<bool> _checkCondition() async {
    try {
      await getUserToken();
      return true;
    } catch (e) {
      return false;
    }
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

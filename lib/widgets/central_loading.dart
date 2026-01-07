import 'dart:async';

import 'package:one/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.blue.shade500,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CoreCentralLoading(),
              const SizedBox(height: 10),
              Text(context.loc.loading),
            ],
          ),
        ),
      ),
    );
  }
}

class CoreCentralLoading extends StatefulWidget {
  const CoreCentralLoading({super.key});

  @override
  State<CoreCentralLoading> createState() => _CoreCentralLoadingState();
}

class _CoreCentralLoadingState extends State<CoreCentralLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Timer? _timer;
  static int _index = 1;
  static const _duration = Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      upperBound: 1,
      lowerBound: 0,
    )..repeat();
    _timer = Timer.periodic(_duration, (ti) {
      setState(() {
        if (_index >= 5) {
          _index = 1;
        } else {
          _index++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(_animationController.value * 6.3),
          child: child,
        );
      },
      child: Image.asset(
        AppAssets.loaders(_index),
        key: ValueKey(AppAssets.loaders(_index)),
        cacheWidth: 50,
        cacheHeight: 50,
        height: 50,
        width: 50,
      ),
    );
  }
}

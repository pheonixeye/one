import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class RotatingClinicsTab extends StatefulWidget implements PreferredSizeWidget {
  const RotatingClinicsTab({
    super.key,
    required this.clinics,
  });
  final List<Clinic> clinics;

  @override
  State<RotatingClinicsTab> createState() => _RotatingClinicsTabState();

  @override
  Size get preferredSize => Size.fromHeight(80);
}

class _RotatingClinicsTabState extends State<RotatingClinicsTab>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  Timer? _timer;
  final _changeDuration = const Duration(seconds: 10);
  final _animationDuration = const Duration(microseconds: 500);
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.clinics.length, vsync: this);

    _timer = Timer.periodic(_changeDuration, (tim) {
      if (_controller != null) {
        try {
          _controller!.animateTo(
            _controller!.index + 1,
            duration: _animationDuration,
          );
        } catch (e) {
          _controller!.animateTo(0, duration: _animationDuration);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          controller: _controller,
          tabAlignment: TabAlignment.center,
          tabs: [
            ...widget.clinics.map((e) {
              return Tab(child: Text(l.isEnglish ? e.name_en : e.name_ar));
            }),
          ],
        );
      },
    );
  }
}

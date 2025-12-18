// ignore: must_be_immutable
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InformationWidget extends StatefulWidget {
  InformationWidget({
    super.key,
    required this.message,
    this.color,
    this.onTap,
  });
  final String message;
  final Color? color;
  VoidCallback? onTap;

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _duration = const Duration(seconds: 5);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
      onTap: widget.onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.message,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.info,
              color: widget.color ?? Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _controller.value,
              color: Colors.amber,
              backgroundColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            );
          },
        ),
      ),
    );
  }
}

OverlayEntry informationOverlayEntry(
  String message, [
  Color? color,
]) {
  final _overlay = InformationWidget(
    message: message,
    color: color,
  );

  final _entry = OverlayEntry(
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 10,
            height: 65,
            child: Card.outlined(
              child: _overlay,
            ),
          ),
        ),
      );
    },
  );

  _overlay.onTap = () {
    _entry.remove();
  };
  return _entry;
}

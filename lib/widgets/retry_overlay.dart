// ignore: must_be_immutable
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/random_curved_animation.dart';

// ignore: must_be_immutable
class RetryButtonWidget extends StatefulWidget {
  RetryButtonWidget({super.key, required this.toRetry, this.toClose});
  final Function toRetry;
  VoidCallback? toClose;

  @override
  State<RetryButtonWidget> createState() => _RetryButtonWidgetState();
}

class _RetryButtonWidgetState extends State<RetryButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final _duration = const Duration(milliseconds: 1000);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.3,
      upperBound: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: RandomCurver().curve,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              child: Text(context.loc.retry),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmBtn(
              tooltip: context.loc.retry,
              onPressed: () {
                widget.toRetry();
                if (widget.toClose != null) {
                  widget.toClose!();
                }
              },
              child: const Icon(Icons.refresh),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmBtn(
              backgroundColor: Colors.red.shade200,
              key: UniqueKey(),
              onPressed: () {
                if (widget.toClose != null) {
                  widget.toClose!();
                }
              },
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

OverlayEntry retryOverlayEntry(Function toRetry) {
  final _overlay = RetryButtonWidget(toRetry: toRetry);

  final _entry = OverlayEntry(
    builder: (context) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 60,
          width: 240,
          child: Card.outlined(
            color: Colors.red.withValues(alpha: 0.3),
            child: _overlay,
          ),
        ),
      );
    },
  );

  _overlay.toClose = () {
    _entry.remove();
  };

  return _entry;
}

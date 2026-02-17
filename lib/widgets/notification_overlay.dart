import 'dart:async';
import 'dart:typed_data';

import 'package:one/extensions/after_layout.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/models/notifications/in_app_notification.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_overlay.dart';
import 'package:one/utils/sound_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class NotificationOverlayCard extends StatefulWidget implements EquatableMixin {
  const NotificationOverlayCard({
    super.key,
    required this.notification,
    this.fileBlob,
  });
  final InAppNotification notification;
  final Uint8List? fileBlob;

  @override
  State<NotificationOverlayCard> createState() =>
      _NotificationOverlayCardState();

  @override
  List<Object?> get props => [notification.id];

  @override
  bool? get stringify => true;
}

class _NotificationOverlayCardState extends State<NotificationOverlayCard>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  Timer? timer;
  static const _duration = Duration(milliseconds: 10);
  final ValueNotifier<double> _progress = ValueNotifier(0);
  late final AudioPlayer player;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    final _l = context.read<PxLocale>();
    player = AudioPlayer();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // Adjust duration as needed
      vsync: this,
    );

    // Define the animation from off-screen left (Offset(-1.0, 0.0)) to visible (Offset.zero)
    _offsetAnimation =
        Tween<Offset>(
          begin: Offset(
            _l.isEnglish ? -1 : 1,
            0.0,
          ), // Starts one full width to the left of its normal position
          end: Offset.zero, // Ends at its normal position
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn, // Add a natural easing curve
          ),
        );

    // Start the animation automatically when the screen loads
    _controller.forward();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await SoundHelper.playSound(player, widget.fileBlob);
  }

  @override
  void didChangeDependencies() {
    timer = Timer.periodic(_duration, (timer) async {
      _progress.value += 0.001;
      if (_progress.value >= 1.0) {
        timer.cancel();
        _controller.reverse();
        await Future.delayed(const Duration(milliseconds: 1000));
        PxOverlay.removeOverlay(widget.notification.id ?? '');
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    _progress.dispose();
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        final index = PxOverlay.overlays.keys.toList().indexWhere(
          (e) => e == widget.notification.id,
        );
        if (index == -1) {
          return const SizedBox();
        }
        return Padding(
          padding: EdgeInsets.only(
            top: (index * 120.0) + 12,
            left: l.isEnglish ? 12 : 0,
            right: !l.isEnglish ? 12 : 0,
            bottom: 0,
          ),
          child: Align(
            alignment: l.isEnglish ? Alignment.topLeft : Alignment.topRight,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: context.isMobile
                    ? MediaQuery.sizeOf(context).width * 0.9
                    : MediaQuery.sizeOf(context).width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Card.outlined(
                  elevation: 6,
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      onTap: () async {
                        timer?.cancel();
                        // SoundHelper.notificationSound.stop();
                        _controller.reverse();
                        await Future.delayed(
                          const Duration(milliseconds: 1000),
                        );
                        PxOverlay.toggleOverlay(
                          id: widget.notification.id ?? '',
                          child: widget,
                        );
                      },
                      leading: const CircleAvatar(child: Icon(Icons.info)),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.notification.title ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 4,
                        children: [
                          Text(widget.notification.message ?? ''),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: _progress,
                              builder: (context, value, child) {
                                return LinearProgressIndicator(
                                  backgroundColor: Colors.cyanAccent,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.red,
                                      ),
                                  value: value,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

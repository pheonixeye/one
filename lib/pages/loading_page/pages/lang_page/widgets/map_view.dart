import 'package:flutter/material.dart';

class MapViewContainer extends StatelessWidget {
  const MapViewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 460,
      height: 360,
      child: Card.outlined(
        elevation: 6,
        child: HtmlElementView(
          viewType: 'map-view',
        ),
      ),
    );
  }
}

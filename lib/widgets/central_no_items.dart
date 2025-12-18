import 'package:flutter/material.dart';

class CentralNoItems extends StatelessWidget {
  const CentralNoItems({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.outlined(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

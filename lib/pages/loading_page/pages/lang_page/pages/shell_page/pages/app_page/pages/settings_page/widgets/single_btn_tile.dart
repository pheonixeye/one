import 'package:flutter/material.dart';

class SingleBtnTile extends StatelessWidget {
  const SingleBtnTile({
    super.key,
    required this.title,
    required this.btn,
  });
  final String title;
  final Widget btn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
            trailing: btn,
            subtitle: const Divider(),
          ),
        ),
      ),
    );
  }
}

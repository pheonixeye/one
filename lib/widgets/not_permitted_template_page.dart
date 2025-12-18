import 'package:one/extensions/loc_ext.dart';
import 'package:flutter/material.dart';

class NotPermittedTemplatePage extends StatelessWidget {
  const NotPermittedTemplatePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              ),
              subtitle: const Divider(),
            ),
          ),
          const Spacer(),
          Center(
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.notAnAdminAccount),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

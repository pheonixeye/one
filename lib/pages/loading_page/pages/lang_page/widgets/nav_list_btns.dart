import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/providers/scroll_px.dart';
import 'package:provider/provider.dart';

class NavListBtns extends StatelessWidget {
  const NavListBtns({super.key, this.inFooter = false});
  final bool inFooter;
  final _mobilePadding = const EdgeInsets.all(2.0);
  final _regularPadding = const EdgeInsets.all(8.0);
  @override
  Widget build(BuildContext context) {
    final padding = context.isMobile ? _mobilePadding : _regularPadding;
    List<Widget> buildChildren(PxScroll s) => [
      if (!inFooter) const Spacer(),
      Padding(
        padding: padding,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            s.scrollToIndex(0);
          },
          child: Text(context.loc.home),
        ),
      ),
      Padding(
        padding: padding,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            s.scrollToIndex(1);
          },
          child: Text(context.loc.features),
        ),
      ),
      Padding(
        padding: padding,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            s.scrollToIndex(7);
          },
          child: Text(context.loc.pricing),
        ),
      ),
      Padding(
        padding: padding,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            s.scrollToIndex(11);
          },
          child: Text(context.loc.faq),
        ),
      ),
      Padding(
        padding: padding,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            s.scrollToIndex(18);
          },
          child: Text(context.loc.contact),
        ),
      ),
      if (!inFooter) const Spacer(),
    ];
    return Consumer<PxScroll>(
      builder: (context, s, _) {
        if (context.isMobile) {
          return Wrap(
            children: buildChildren(s),
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildChildren(s),
        );
      },
    );
  }
}

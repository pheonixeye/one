import 'package:flutter/material.dart';
import 'package:one/pages/loading_page/pages/lang_page/widgets/home_list_widgets.dart';
import 'package:one/pages/loading_page/pages/lang_page/widgets/nav_bar.dart';
import 'package:one/pages/loading_page/pages/lang_page/widgets/responsive_fab.dart';
import 'package:one/providers/scroll_px.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LangPage extends StatefulWidget {
  const LangPage({super.key});

  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PxScroll>(
      builder: (context, s, _) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: NavBar(),
          ),
          body: ScrollablePositionedList.builder(
            shrinkWrap: true,
            itemScrollController: s.controller,
            itemBuilder: (context, index) {
              return HomeWidgetsList.widgets(context)[index];
            },
            itemCount: HomeWidgetsList.widgets(context).length,
          ),
          floatingActionButton: const ResponsiveFab(),
        );
      },
    );
  }
}

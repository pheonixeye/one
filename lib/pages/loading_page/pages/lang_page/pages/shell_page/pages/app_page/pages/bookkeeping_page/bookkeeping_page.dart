import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/detailed_view_bookkeeping.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/focused_view_bookkeeping.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/not_permitted_template_page.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/add_bookkeeping_entry_dialog.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/filter_header_bookkeeping.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class BookkeepingPage extends StatefulWidget {
  const BookkeepingPage({super.key});

  @override
  State<BookkeepingPage> createState() => _BookkeepingPageState();
}

class _BookkeepingPageState extends State<BookkeepingPage> {
  late final ScrollController _verticalScroll;
  late final ScrollController _horizontalScroll;

  @override
  void initState() {
    super.initState();
    _verticalScroll = ScrollController();
    _horizontalScroll = ScrollController();
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxBookkeeping, PxLocale>(
      builder: (context, a, b, l, _) {
        while (b.result == null || a.constants == null) {
          return CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
          PermissionEnum.User_Bookkeeping_Read,
          context,
        );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.bookkeeping);
        }
        return Scaffold(
          body: Column(
            children: [
              const FilterHeaderBookkeeping(),
              switch (b.viewType) {
                BookkeepingViewType.detailed => const DetailedViewBookKeeping(),
                BookkeepingViewType.focused => const FocusedViewBookkeeping(),
              },
            ],
          ),
          floatingActionButton: SmBtn(
            tooltip: context.loc.addBookkeepingEntry,
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                PermissionEnum.User_Bookkeeping_Add,
                context,
              );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(permission: _perm.permission);
                  },
                );
                return;
              }
              final _bookkeepingDto = await showDialog<BookkeepingItem?>(
                context: context,
                builder: (context) {
                  return AddBookkeepingEntryDialog();
                },
              );
              if (_bookkeepingDto == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await b.addBookkeepingEntry(_bookkeepingDto);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

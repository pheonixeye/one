import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/add_remove_discount_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_one_visit_bookkeeping.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscountManagmentRow extends StatelessWidget {
  const DiscountManagmentRow({super.key, required this.visit});
  final VisitExpanded visit;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAppConstants, PxOneVisitBookkeeping>(
      builder: (context, a, b, _) {
        while (a.constants == null || b.result == null) {
          return const Row(
            children: [Expanded(child: LinearProgressIndicator())],
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Icon(Icons.discount),
              ),
              Expanded(child: Text(context.loc.discount)),
              Builder(
                builder: (context) {
                  while (b.result is ApiErrorResult) {
                    return Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          const Icon(Icons.error),
                          Text(
                            context.loc.error,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }
                  //todo: calculate discounts
                  return Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '(${b.discountTotal})'.toArabicNumber(context),
                        children: [
                          TextSpan(text: ' '),
                          TextSpan(
                            text: context.loc.egp,
                            style: TextStyle(letterSpacing: 0),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color:
                            (b.discountTotal != null &&
                                b.discountTotal!.isNegative)
                            ? Colors.red
                            : null,
                        letterSpacing: 2,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              PopupMenuButton<void>(
                offset: Offset(0, 48),
                elevation: 6,
                shadowColor: Colors.transparent,
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(),
                ),
                child: Card.outlined(
                  elevation: 6,
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.menu),
                  ),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      mouseCursor: SystemMouseCursors.click,
                      enabled: true,
                      child: Center(
                        child: Card.outlined(
                          color: Colors.green.shade50,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.addDiscount),
                          ),
                        ),
                      ),
                      onTap: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_TodayVisits_Add_Discount,
                          context,
                        );
                        if (!_perm.isAllowed) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return NotPermittedDialog(
                                permission: _perm.permission,
                              );
                            },
                          );
                          return;
                        }

                        if (visit.visit_status == a.notAttended.name_en) {
                          showIsnackbar(context.loc.visitNotAttended);
                          return;
                        }

                        final _dto = await showDialog<BookkeepingItem?>(
                          context: context,
                          builder: (context) {
                            return AddRemoveDiscountDialog(
                              visit: visit,
                              direction: BookkeepingDirection.OUT,
                            );
                          },
                        );
                        if (_dto == null) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await b.addBookkeepingEntry(_dto);
                            },
                          );
                        }
                      },
                    ),
                    PopupMenuItem(
                      mouseCursor: SystemMouseCursors.click,
                      enabled: true,
                      child: Center(
                        child: Card.outlined(
                          color: Colors.red.shade50,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.removeDiscount),
                          ),
                        ),
                      ),
                      onTap: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                          PermissionEnum.User_TodayVisits_Remove_Discount,
                          context,
                        );
                        if (!_perm.isAllowed) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return NotPermittedDialog(
                                permission: _perm.permission,
                              );
                            },
                          );
                          return;
                        }
                        if (visit.visit_status == a.notAttended.name_en) {
                          showIsnackbar(context.loc.visitNotAttended);
                          return;
                        }

                        if (b.discountTotal != null && b.discountTotal! >= 0) {
                          showIsnackbar(context.loc.noDiscountApplied);
                          return;
                        }

                        final _dto = await showDialog<BookkeepingItem?>(
                          context: context,
                          builder: (context) {
                            return AddRemoveDiscountDialog(
                              visit: visit,
                              direction: BookkeepingDirection.IN,
                            );
                          },
                        );
                        if (_dto == null) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await b.addBookkeepingEntry(_dto);
                            },
                          );
                        }
                      },
                    ),
                  ];
                },
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/supplies/supply_movement_dto.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/supply_movements_page/widgets/add_supply_movement_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_supply_movements.dart';
import 'package:one/widgets/floating_ax_menu_bubble.dart';
import 'package:one/widgets/not_permitted_dialog.dart';
import 'package:provider/provider.dart';

class SupplyMovementActionBubble extends StatefulWidget {
  const SupplyMovementActionBubble({super.key});

  @override
  State<SupplyMovementActionBubble> createState() =>
      _SupplyMovementActionBubbleState();
}

class _SupplyMovementActionBubbleState extends State<SupplyMovementActionBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxSupplyMovements>(
      builder: (context, s, _) {
        return FloatingActionMenuBubble(
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.white,
          animatedIconData: AnimatedIcons.menu_arrow,
          backGroundColor: Theme.of(
            context,
          ).floatingActionButtonTheme.backgroundColor!,
          items: [
            Bubble(
              title: context.loc.refresh,
              iconColor: Colors.white,
              bubbleColor: Theme.of(
                context,
              ).floatingActionButtonTheme.backgroundColor!,
              icon: Icons.refresh,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () async {
                _animationController.reverse();
                //@permission
                final _perm = context.read<PxAuth>().isActionPermitted(
                  PermissionEnum.User_SupplyMovements_Read,
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
                await shellFunction(
                  context,
                  toExecute: () async {
                    await s.retry();
                  },
                );
              },
            ),
            Bubble(
              title: context.loc.newSupplyMovement,
              iconColor: Colors.white,
              bubbleColor: Theme.of(
                context,
              ).floatingActionButtonTheme.backgroundColor!,
              icon: Icons.add,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () async {
                _animationController.reverse();
                //@permission
                final _perm = context.read<PxAuth>().isActionPermitted(
                  PermissionEnum.User_SupplyMovement_Add,
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
                final _dtos = await showDialog<List<SupplyMovementDto?>?>(
                  context: context,
                  builder: (context) {
                    return AddSupplyMovementDialog();
                  },
                );
                if (_dtos == null) {
                  return;
                }
                if (context.mounted) {
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await s.addSupplyMovements(_dtos);
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

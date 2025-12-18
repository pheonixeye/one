import 'package:one/router/router.dart';

enum ProfileSetupItem {
  drugs(AppRouter.drugs),
  labs(AppRouter.labs),
  rads(AppRouter.rads),
  procedures(AppRouter.procedures),
  supplies(AppRouter.supplies);

  final String route;

  const ProfileSetupItem(this.route);
}

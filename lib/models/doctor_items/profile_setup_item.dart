import 'package:one/router/router.dart';

enum ProfileSetupItem {
  drugs(AppRouter.drugs),
  labs(AppRouter.labs),
  rads(AppRouter.rads),
  procedures(AppRouter.procedures),
  documents(AppRouter.documents),
  supplies(AppRouter.supplies),
  referrals(AppRouter.referrals);

  final String route;

  const ProfileSetupItem(this.route);

  ProfileSetupItem getByStringValue(String value) {
    return switch (value) {
      AppRouter.drugs => drugs,
      AppRouter.labs => labs,
      AppRouter.rads => rads,
      AppRouter.procedures => procedures,
      AppRouter.documents => documents,
      AppRouter.supplies => supplies,
      AppRouter.referrals => referrals,
      _ => drugs,
    };
  }
}

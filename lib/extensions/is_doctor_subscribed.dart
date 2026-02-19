import 'package:one/providers/px_subscription.dart';

extension IsDoctorSubscribed on PxSubscription {
  bool get isDoctorSubscribed => hasAciveSubscriptions;
}

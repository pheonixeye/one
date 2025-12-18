import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

extension WidgetExt on ProfileSetupItem {
  String actionButtonTooltip(BuildContext context) {
    return switch (this) {
      ProfileSetupItem.drugs => '${context.loc.add} ${context.loc.doctorDrugs}',
      ProfileSetupItem.labs =>
        '${context.loc.add} ${context.loc.laboratoryRequests}',
      ProfileSetupItem.rads => '${context.loc.add} ${context.loc.radiology}',
      ProfileSetupItem.procedures =>
        '${context.loc.add} ${context.loc.procedures}',
      ProfileSetupItem.supplies => '${context.loc.add} ${context.loc.supplies}',
    };
  }

  String pageTitleName(BuildContext context) {
    return switch (this) {
      ProfileSetupItem.drugs => context.loc.doctorDrugs,
      ProfileSetupItem.labs => context.loc.laboratoryRequests,
      ProfileSetupItem.rads => context.loc.radiology,
      ProfileSetupItem.procedures => context.loc.procedures,
      ProfileSetupItem.supplies => context.loc.supplies,
    };
  }
}

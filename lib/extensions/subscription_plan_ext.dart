import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/models/app_constants/subscription_plan.dart';

extension WxSubscriptionPlan on SubscriptionPlan {
  String get getAssetImage {
    return switch (name_en.toLowerCase()) {
      'monthly' => AppAssets.monthly,
      'half annual' => AppAssets.halfAnnual,
      'annual' => AppAssets.annual,
      _ => throw UnimplementedError(),
    };
  }

  Color get getCardColor {
    return switch (name_en.toLowerCase()) {
      'monthly' => Colors.green.shade50,
      'half annual' => Colors.blue.shade50,
      'annual' => Colors.pink.shade50,
      _ => Colors.white,
    };
  }
}

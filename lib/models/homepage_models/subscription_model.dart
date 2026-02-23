// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:one/models/homepage_models/feature_model.dart';

class Subscription extends Equatable {
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String monthlyFees;
  final String yearlyFees;
  final List<Feature> features;

  const Subscription({
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.monthlyFees,
    required this.yearlyFees,
    required this.features,
  });

  @override
  List<Object?> get props => [
    titleEn,
    titleAr,
    descriptionEn,
    descriptionAr,
    monthlyFees,
    yearlyFees,
    features,
  ];
}

// ignore: constant_identifier_names, non_constant_identifier_names
final List<Subscription> SUBSCRIPTIONS = [
  Subscription(
    titleEn: "Silver Package",
    titleAr: 'الباقة الفضية',
    descriptionEn: "The Basic Package, Minimal Features.",
    descriptionAr: "الباقة الاساسية, مميزات محددة",
    monthlyFees: "250",
    yearlyFees: "2500",
    features: [..._subscriptionFeatures.sublist(0, 2)],
  ),
  Subscription(
    titleEn: "Gold Package",
    titleAr: 'الباقة الذهبية',
    descriptionEn: "The Mid Range Package, Contains Most Used Features.",
    descriptionAr: "الباقة المتوسطة, تحتوي علي المميزات الاكثر استخداما",
    monthlyFees: "350",
    yearlyFees: "3500",
    features: [..._subscriptionFeatures.sublist(0, 3)],
  ),
  Subscription(
    titleEn: "Platinum Package",
    titleAr: 'الباقة البلاتينة',
    descriptionEn: "The Complete Package, Contains Extra Useful Features.",
    descriptionAr: "الباقة الكاملة, تحتوي علي كل المميزات.",
    monthlyFees: "500",
    yearlyFees: "5000",
    features: [..._subscriptionFeatures.sublist(0, 4)],
  ),
  Subscription(
    titleEn: "Suit Your Needs",
    titleAr: 'باقة مفصلة',
    descriptionEn: "If No Other Package Seems Appropriate, Contact Us.",
    descriptionAr: "اذا لم تجد باقة مناسبة برجاء التواصل مع قسم المبيعات",
    monthlyFees: "-",
    yearlyFees: "-",
    features: [..._subscriptionFeatures],
  ),
];

List<Feature> get allFeatures => _subscriptionFeatures;

final List<Feature> _subscriptionFeatures = [
  //TODO: modulate features
  Feature.access(),
  Feature.prescription(),
  Feature.notifications(),
  Feature.addImages(),
];

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:one/models/app_constants/subscription_plan.dart';
import 'package:one/models/doctor.dart';

import 'package:one/models/x_pay/amount.dart';

///
///{
///    "name": "Monthly rent",
///    "address": "123 Main St, City",
///    "order_description": "Monthly rent payment",
///    "customer_title": "Mr.",
///    "customer_name": "Mahmoud mmm",
///    "customer_email": "test@example.com",
///    "allow_recurring_payments": false,
///    "customer_mobile": "+201223456789",
///    "cc_email": "cc@example.com",
///    "amount": {
///        "amount": 100.0,
///        "currency": "EGP"
///    },
///    "discount_amount": {
///        "amount": 10.0,
///        "currency": "EGP"
///    },
///    "community_id": "xL4rPB7",
///    "paid": false,
///    "tags": [
///        {
///            "id": 1,
///            "name": "test-checkoutpage"
///        }
///    ],
///    "payment_methods": [
///        "CARD",
///        "FAWRY"
///    ],
///    "vat_percentage": 5.0,
///    "expiry_date": "2025-05-31",
///    "minimum_days_between_payments": 30,
/// "custom_fields": [],
///    "send_by_email": true,
///    "send_by_sms": true,
///    "redirect_url": "https://webhook.site/90b597de-669b-499a-a595-423054d9d46d",
///    "callback_url": "https://webhook.site/90b597de-669b-499a-a595-423054d9d46d"
///}
///
///
const List<String> _defaultPaymentMethods = ["CARD", "FAWRY", "VALU"];

class XPayDirectOrderRequest extends Equatable {
  final String name;
  final String address;
  final String order_description;
  //
  final String customer_title;
  final String customer_email;
  final String customer_mobile;
  final String customer_name;
  //
  final bool allow_recurring_payments;
  final String cc_email;
  final XpayAmount amount;
  final XpayAmount discount_amount;
  //
  final String community_id;
  final bool paid;
  //
  final List<dynamic> tags;
  //
  final List<String> payment_methods;
  final double vat_percentage;
  final String expiry_date;
  final int minimum_days_between_payments;
  final List<dynamic> custom_fields;
  final bool send_by_email;
  final bool send_by_sms;
  final String redirect_url;
  final String callback_url;

  const XPayDirectOrderRequest({
    required this.name,
    required this.address,
    required this.order_description,
    required this.customer_title,
    required this.customer_name,
    required this.customer_email,
    required this.customer_mobile,
    this.allow_recurring_payments = false,
    this.cc_email = 'transactions@proklinik.app',
    required this.amount,
    required this.discount_amount,
    required this.community_id,
    this.paid = false,
    this.tags = const [],
    this.payment_methods = _defaultPaymentMethods,
    this.vat_percentage = 14,
    required this.expiry_date,
    required this.minimum_days_between_payments,
    this.custom_fields = const [],
    this.send_by_email = true,
    this.send_by_sms = true,
    required this.redirect_url,
    required this.callback_url,
  });

  XPayDirectOrderRequest copyWith({
    String? name,
    String? address,
    String? order_description,
    String? customer_title,
    String? customer_name,
    String? customer_email,
    String? customer_mobile,
    bool? allow_recurring_payments,
    String? cc_email,
    XpayAmount? amount,
    XpayAmount? discount_amount,
    String? community_id,
    bool? paid,
    List<dynamic>? tags,
    List<String>? payment_methods,
    double? vat_percentage,
    String? expiry_date,
    int? minimum_days_between_payments,
    List<dynamic>? custom_fields,
    bool? send_by_email,
    bool? send_by_sms,
    String? redirect_url,
    String? callback_url,
  }) {
    return XPayDirectOrderRequest(
      name: name ?? this.name,
      address: address ?? this.address,
      order_description: order_description ?? this.order_description,
      customer_title: customer_title ?? this.customer_title,
      customer_name: customer_name ?? this.customer_name,
      customer_email: customer_email ?? this.customer_email,
      customer_mobile: customer_mobile ?? this.customer_mobile,
      allow_recurring_payments:
          allow_recurring_payments ?? this.allow_recurring_payments,
      cc_email: cc_email ?? this.cc_email,
      amount: amount ?? this.amount,
      discount_amount: discount_amount ?? this.discount_amount,
      community_id: community_id ?? this.community_id,
      paid: paid ?? this.paid,
      tags: tags ?? this.tags,
      payment_methods: payment_methods ?? this.payment_methods,
      vat_percentage: vat_percentage ?? this.vat_percentage,
      expiry_date: expiry_date ?? this.expiry_date,
      minimum_days_between_payments:
          minimum_days_between_payments ?? this.minimum_days_between_payments,
      custom_fields: custom_fields ?? this.custom_fields,
      send_by_email: send_by_email ?? this.send_by_email,
      send_by_sms: send_by_sms ?? this.send_by_sms,
      redirect_url: redirect_url ?? this.redirect_url,
      callback_url: callback_url ?? this.callback_url,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'order_description': order_description,
      'customer_title': customer_title,
      'customer_name': customer_name,
      'customer_email': customer_email,
      'customer_mobile': customer_mobile,
      'allow_recurring_payments': allow_recurring_payments,
      'cc_email': cc_email,
      'amount': amount.toJson(),
      'discount_amount': discount_amount.toJson(),
      'community_id': community_id,
      'paid': paid,
      'tags': tags,
      'payment_methods': payment_methods,
      'vat_percentage': vat_percentage,
      'expiry_date': expiry_date,
      'minimum_days_between_payments': minimum_days_between_payments,
      'custom_fields': custom_fields,
      'send_by_email': send_by_email,
      'send_by_sms': send_by_sms,
      'redirect_url': redirect_url,
      'callback_url': callback_url,
    };
  }

  factory XPayDirectOrderRequest.fromJson(Map<String, dynamic> map) {
    return XPayDirectOrderRequest(
      name: map['name'] as String,
      address: map['address'] as String,
      order_description: map['order_description'] as String,
      customer_title: map['customer_title'] as String,
      customer_name: map['customer_name'] as String,
      customer_email: map['customer_email'] as String,
      customer_mobile: map['customer_mobile'] as String,
      allow_recurring_payments: map['allow_recurring_payments'],
      cc_email: map['cc_email'] as String,
      amount: XpayAmount.fromJson(map['amount'] as Map<String, dynamic>),
      discount_amount: XpayAmount.fromJson(
        map['discount_amount'] as Map<String, dynamic>,
      ),
      community_id: map['community_id'] as String,
      paid: map['paid'] as bool,
      tags: List<dynamic>.from((map['tags'] as List<dynamic>)),
      payment_methods: (map['payment_methods'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      vat_percentage: map['vat_percentage'] as double,
      expiry_date: map['expiry_date'] as String,
      minimum_days_between_payments:
          map['minimum_days_between_payments'] as int,
      custom_fields: List<dynamic>.from(
        (map['custom_fields'] as List<dynamic>),
      ),
      send_by_email: map['send_by_email'],
      send_by_sms: map['send_by_sms'],
      redirect_url: map['redirect_url'] as String,
      callback_url: map['callback_url'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      address,
      order_description,
      customer_title,
      customer_email,
      customer_mobile,
      allow_recurring_payments,
      cc_email,
      amount,
      discount_amount,
      community_id,
      paid,
      tags,
      payment_methods,
      vat_percentage,
      expiry_date,
      minimum_days_between_payments,
      custom_fields,
      send_by_email,
      send_by_sms,
      redirect_url,
      callback_url,
    ];
  }

  factory XPayDirectOrderRequest.fromApplicationData({
    required Doctor doctor,
    required SubscriptionPlan plan,
    required String billing_address,
  }) {
    final _amount = XpayAmount(amount: plan.price.toDouble());
    final _discount_in_currency = plan.has_offer
        ? plan.price - ((plan.price * plan.current_discount_percentage) / 100)
        : 0;
    final _discount_amount = XpayAmount(
      amount: _discount_in_currency.toDouble(),
    );

    final _one_month_expiary = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(DateTime.now()..copyWith(month: DateTime.now().month + 1));
    final _planExpDate = DateTime.now().add(
      Duration(days: plan.duration_in_days),
    );
    final _order_description =
        'Dr. ${doctor.name_en} ProKliniK-One Subscription\n(${plan.name_en} Plan)\nStarting Date: ${DateFormat('dd / MM / yyyy', 'en').format(DateTime.now())}\nExpiry Date: ${DateFormat('dd / MM / yyyy', 'en').format(_planExpDate)}';

    return XPayDirectOrderRequest(
      name: 'ProKliniK-One ${plan.name_en} Plan',
      address: billing_address,
      order_description: _order_description,
      customer_title: 'Dr.',
      customer_name: doctor.name_en,
      customer_email: doctor.email,
      customer_mobile: '+2${doctor.phone}',
      amount: _amount,
      discount_amount: _discount_amount,
      community_id: const String.fromEnvironment('X_PAY_COMMUNITY_ID'),
      expiry_date: _one_month_expiary,
      minimum_days_between_payments: plan.duration_in_days,
      redirect_url: const String.fromEnvironment('REDIRECT_URL'),
      callback_url: '', //todo:
    );
  }
}

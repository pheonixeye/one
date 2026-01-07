import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/subscription_payment_api/sub_payment_exp.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/models/doctor_subscription.dart';
import 'package:one/models/payment.dart';

class DocSubPayApi {
  const DocSubPayApi();

  static const String doctor_subscription_collection = 'doctor_subscriptions';
  static const String subscription_payment_collection =
      'doctor_subscription_payment';

  static Future<void> updateSubscriptionPaymentsAndActivateDoctorSubscription({
    required String doc_id,
    required String x_pay_payment_id,
    required String x_pay_transaction_id,
    required String x_pay_transaction_status,
    required double amount,
  }) async {
    late final RecordModel _subPaymentGetQuery;

    try {
      _subPaymentGetQuery = await PocketbaseHelper.pbBase
          .collection(subscription_payment_collection)
          .getFirstListItem(
            "x_pay_payment_id = '$x_pay_payment_id' && doc_id = '$doc_id'",
          );
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(message: 'No Payment Reference Found.', code: 10);
    }
    final _payment = Payment.fromJson(_subPaymentGetQuery.toJson());

    if (_payment.x_pay_transaction_id != '') {
      //@handle
      throw CodedException(
        message: 'Transaction Has Already Been Processed.',
        code: 11,
      );
    }

    try {
      await PocketbaseHelper.pbBase
          .collection(subscription_payment_collection)
          .update(
            _payment.id,
            body: {
              'x_pay_transaction_id': x_pay_transaction_id,
              'x_pay_transaction_status': x_pay_transaction_status,
              'amount': amount,
            },
          );
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(
        message:
            'Unable To Update Payment Reference, Kindly Contact Our Support Team.',
        code: 12,
      );
    }

    try {
      await PocketbaseHelper.pbBase
          .collection(doctor_subscription_collection)
          .update(
            _payment.doctor_subscription_id,
            body: {'subscription_status': 'active'},
          );
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(
        code: 13,
        message:
            'Unable To Activate Subscription, Kindly Contact Our Support Team.',
      );
    }
  }

  static Future<void> updateSubPayXpayPaymentReference({
    required String sub_pay_id,
    required String x_pay_payment_id,
  }) async {
    try {
      await PocketbaseHelper.pbBase
          .collection(subscription_payment_collection)
          .update(sub_pay_id, body: {'x_pay_payment_id': x_pay_payment_id});
    } catch (e) {
      dprint(e);
      throw CodedException(
        code: 14,
        message:
            'Unable To Update Subscription Payment Reference, Kindly Contact Our Support Team.',
      );
    }
  }

  static Future<void> createDoctorSubscriptionAndSubscriptionPaymentRefrences({
    required DoctorSubscription doctorSubscription,
    required double amount,
    required String x_pay_payment_id,
  }) async {
    late final String _docSubRefId;
    late final String _subPayRefId;
    try {
      final _docSubRequest = await PocketbaseHelper.pbBase
          .collection(doctor_subscription_collection)
          .create(body: doctorSubscription.toJson());
      _docSubRefId = _docSubRequest.id;
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(
        code: 150,
        message:
            'Unable To Update Subscription & Payment References, Kindly Contact Our Support Team.',
      );
    }

    try {
      final _subPayRequest = await PocketbaseHelper.pbBase
          .collection(subscription_payment_collection)
          .create(
            body: {
              'doc_id': doctorSubscription.doc_id,
              'doctor_subscription_id': _docSubRefId,
              'amount': amount,
            },
          );
      _subPayRefId = _subPayRequest.id;
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(
        code: 151,
        message:
            'Unable To Update Subscription & Payment References, Kindly Contact Our Support Team.',
      );
    }

    try {
      await PocketbaseHelper.pbBase
          .collection(doctor_subscription_collection)
          .update(_docSubRefId, body: {'payment_id': _subPayRefId});
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(
        code: 152,
        message:
            'Unable To Update Subscription & Payment References, Kindly Contact Our Support Team.',
      );
    }

    try {
      await PocketbaseHelper.pbBase
          .collection(subscription_payment_collection)
          .update(_subPayRefId, body: {'x_pay_payment_id': x_pay_payment_id});
    } catch (e) {
      //@handle
      dprint(e);
      throw CodedException(
        code: 153,
        message:
            'Unable To Update Subscription & Payment References, Kindly Contact Our Support Team.',
      );
    }
  }
}

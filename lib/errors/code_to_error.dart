// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TranslatedError extends Equatable {
  final String en;
  final String ar;

  const TranslatedError({
    required this.en,
    required this.ar,
  });

  @override
  List<Object> get props => [en, ar];

  factory TranslatedError.unknown() {
    return TranslatedError(
      en: 'Unknown Error',
      ar: 'خطأ غير معلوم',
    );
  }
}

enum AppErrorCode {
  clientException(1),
  authException(2),
  orderDetailsException(3);

  final int code;

  const AppErrorCode(this.code);
}

class CodeToError {
  const CodeToError(this.code);

  final int? code;

  static final Map<int, TranslatedError> _errors = {
    ///client_exception_code
    AppErrorCode.clientException.code: TranslatedError(
      en: 'Something Went Wrong While Fetching Data.',
      ar: 'حدث خطا اثناء تنزيل البيانات المطلوبة',
    ),

    ///authentication_exception_code
    AppErrorCode.authException.code: TranslatedError(
      en: 'Something Went Wrong While Authenticating, check Email / Password combination.',
      ar: 'حدث خطا اثناء تسجبل الدخول - برجاء مراجعة البريد الالكتروني و كلمة السر.',
    ),

    ///order_details_exception
    AppErrorCode.orderDetailsException.code: TranslatedError(
      en: 'Your Order Has Expired.',
      ar: 'لقد انتهت صلاحية طلبك',
    ),

    ///subscription_payment_api_errors
    //TODO: error messages need to be less generic
    10: TranslatedError(
      en: 'No Payment Reference Found.',
      ar: 'No Payment Reference Found.', //@translate
    ),
    11: TranslatedError(
      en: 'Transaction Has Already Been Processed.',
      ar: 'Transaction Has Already Been Processed.', //@translate
    ),
    12: TranslatedError(
      en: 'Unable To Update Payment Reference, Kindly Contact Our Support Team.',
      ar: 'Unable To Update Payment Reference, Kindly Contact Our Support Team.', //@translate
    ),
    13: TranslatedError(
      en: 'Unable To Activate Subscription, Kindly Contact Our Support Team.',
      ar: 'Unable To Activate Subscription, Kindly Contact Our Support Team.', //@translate
    ),
    14: TranslatedError(
      en: 'Unable To Update Subscription Payment Reference, Kindly Contact Our Support Team.',
      ar: 'Unable To Update Subscription Payment Reference, Kindly Contact Our Support Team.', //@translate
    ),

    ///createDoctorSubscriptionAndSubscriptionPaymentRefrences
    ...Map.fromEntries(
      [150, 151, 152, 153].map((e) {
        return MapEntry(
          e,
          TranslatedError(
            en: 'Unable To Update Subscription & Payment Reference, Kindly Contact Our Support Team.',
            ar: 'Unable To Update Subscription & Payment Reference, Kindly Contact Our Support Team.', //@translate
          ),
        );
      }),
    ),
  };

  String errorMessage(bool isEnglish) => _errors[code] == null
      ? isEnglish
          ? TranslatedError.unknown().en
          : TranslatedError.unknown().ar
      : isEnglish
          ? _errors[code]!.en
          : _errors[code]!.ar;
}

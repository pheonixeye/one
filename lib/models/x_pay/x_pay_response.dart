import 'package:equatable/equatable.dart';

///{
///    "status": {
///        "code": 201,
///        "message": "success",
///        "errors": []
///    },
///    "data": {
///        "success": true,
///        "merchant_id": "xL4rPB7",
///        "payment_id": "1BlbR48",
///        "payment_link": "https://staging-iframe.xpay.app/i/community/xL4rPB7/direct-order/1BlbR48",
///        "message": "Direct order created successfully. SMS and email notifications sent."
///    },
///    "count": null,
///    "next": null,
///    "previous": null
///}
///
class XPayStatus extends Equatable {
  final int code;
  final String message;
  final List<dynamic> errors;
  const XPayStatus({
    required this.code,
    required this.message,
    required this.errors,
  });

  XPayStatus copyWith({
    int? code,
    String? message,
    List<dynamic>? errors,
  }) {
    return XPayStatus(
      code: code ?? this.code,
      message: message ?? this.message,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'errors': errors,
    };
  }

  factory XPayStatus.fromJson(Map<String, dynamic> map) {
    return XPayStatus(
      code: map['code'] as int,
      message: map['message'] as String,
      errors: List<dynamic>.from((map['errors'] as List<dynamic>)),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [code, message, errors];
}

class XPayData extends Equatable {
  final bool success;
  final String merchant_id;
  final String payment_id;
  final String payment_url;
  final String message;

  const XPayData({
    required this.success,
    required this.merchant_id,
    required this.payment_id,
    required this.payment_url,
    required this.message,
  });

  XPayData copyWith({
    bool? success,
    String? merchant_id,
    String? payment_id,
    String? payment_url,
    String? message,
  }) {
    return XPayData(
      success: success ?? this.success,
      merchant_id: merchant_id ?? this.merchant_id,
      payment_id: payment_id ?? this.payment_id,
      payment_url: payment_url ?? this.payment_url,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'merchant_id': merchant_id,
      'payment_id': payment_id,
      'payment_url': payment_url,
      'message': message,
    };
  }

  factory XPayData.fromJson(Map<String, dynamic> map) {
    return XPayData(
      success: map['success'] as bool,
      merchant_id: map['merchant_id'] as String,
      payment_id: map['payment_id'] as String,
      payment_url: map['payment_url'] as String,
      message: map['message'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      success,
      merchant_id,
      payment_id,
      payment_url,
      message,
    ];
  }
}

class XPayResponse extends Equatable {
  final XPayStatus status;
  final XPayData data;
  const XPayResponse({
    required this.status,
    required this.data,
  });

  XPayResponse copyWith({
    XPayStatus? status,
    XPayData? data,
  }) {
    return XPayResponse(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status.toJson(),
      'data': data.toJson(),
    };
  }

  factory XPayResponse.fromJson(Map<String, dynamic> map) {
    return XPayResponse(
      status: XPayStatus.fromJson(map['status'] as Map<String, dynamic>),
      data: XPayData.fromJson(map['data'] as Map<String, dynamic>),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status, data];
}

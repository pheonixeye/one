// import 'dart:convert';

// import 'package:one/functions/dprint.dart';
// import 'package:one/models/x_pay/x_pay_direct_order_request.dart';
// import 'package:http/http.dart' as http;
// import 'package:one/models/x_pay/x_pay_response.dart';

// class XPayApi {
//   const XPayApi();

//   static const _headers = {
//     'x-api-key': String.fromEnvironment('X_PAY_API_KEY'),
//     'content-type': 'application/json',
//     'accept': 'application/json',
//   };

//   Future<XPayResponse> generatePaymentLink(
//     XPayDirectOrderRequest x_request,
//   ) async {
//     final _uri = Uri.parse(const String.fromEnvironment('X_PAY_URL'));
//     try {
//       final _response = await http.post(
//         _uri,
//         headers: _headers,
//         body: jsonEncode(x_request.toJson()),
//       );

//       final _result = jsonDecode(_response.body);
//       prettyPrint(_response.body);
//       prettyPrint(_result);

//       return XPayResponse.fromJson(_result);
//     } catch (e) {
//       prettyPrint(e.toString());
//       rethrow;
//     }
//   }
// }

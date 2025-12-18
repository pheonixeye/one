import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:one/assets/assets.dart';
import 'package:one/core/api/subscription_payment_api/doc_sub_pay_api.dart';
import 'package:one/core/api/subscription_payment_api/sub_payment_exp.dart';
import 'package:one/extensions/after_layout.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/page_states_enum.dart';
import 'package:one/models/x_pay/x_pay_transaction_result.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, required this.query});
  final Map<String, dynamic> query;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AfterLayoutMixin {
  late final XPayTransactionResult _xPayTransactionResult;
  PageState _state = PageState.initial;
  CodedException? _exception;
  late final Future<void> _proceed;

  void _updateState(PageState s) {
    setState(() {
      _state = s;
    });
  }

  void _updateException(CodedException exp) {
    setState(() {
      _exception = exp;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      _xPayTransactionResult = XPayTransactionResult.fromJson(widget.query);
      _updateState(PageState.processing);
      if (_xPayTransactionResult.transaction_status != 'SUCCESSFUL') {
        throw CodedException(message: 'Payment Not Accepted.', code: 22);
      }
    } on CodedException catch (e) {
      _updateState(PageState.hasError);
      _updateException(e);
    }
    _proceed =
        DocSubPayApi.updateSubscriptionPaymentsAndActivateDoctorSubscription(
          doc_id: context.read<PxAuth>().doc_id,
          x_pay_payment_id: _xPayTransactionResult.payment_id,
          x_pay_transaction_id: _xPayTransactionResult.transaction_id,
          x_pay_transaction_status: _xPayTransactionResult.transaction_status,
          amount: _xPayTransactionResult.total_amount,
        );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    try {
      if (_xPayTransactionResult.transaction_status != 'SUCCESSFUL') {
        throw CodedException(message: 'Payment Not Accepted.', code: 22);
      }
      await _proceed;
      _updateState(PageState.hasResult);
    } on CodedException catch (e) {
      _updateState(PageState.hasError);
      _updateException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PxLocale>(
        builder: (context, l, _) {
          final Alignment _alignment = l.isEnglish
              ? Alignment.topLeft
              : Alignment.topRight;
          return Container(
            child: switch (_state) {
              PageState.initial => const SizedBox(),
              PageState.processing => CentralLoading(),
              PageState.hasError => Center(
                child: CentralError(
                  code: _exception?.code,
                  toExecute: () async {
                    // await _proceed;
                    GoRouter.of(context).goNamed(
                      AppRouter.app,
                      pathParameters: defaultPathParameters(context),
                    );
                  },
                ),
              ),
              PageState.hasResult => Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(AppAssets.after_purchase, fit: BoxFit.cover),
                  Align(
                    alignment: _alignment,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.icon, width: 50, height: 50),
                          const SizedBox(width: 10),
                          const Text(
                            'ProKliniK-One',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      Text(
                        context.loc.thankyouForYourPurchase,
                        style: TextStyle(
                          fontSize: context.isMobile ? 16 : 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          GoRouter.of(context).goNamed(
                            AppRouter.mysubscription,
                            pathParameters: defaultPathParameters(context),
                          );
                        },
                        label: Text(context.loc.mySubscription),
                        icon: const Icon(Icons.receipt_long),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.loc.professionalMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${context.loc.allRightsReserved} ${DateFormat('yyyy', l.lang).format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            },
          );
        },
      ),
    );
  }
}

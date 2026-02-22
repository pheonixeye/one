import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/app_constants/subscription_plan.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/page_states_enum.dart';
import 'package:one/models/x_pay/x_pay_direct_order_request.dart';
import 'package:one/models/x_pay/x_pay_response.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/pages/order_details_page/widgets/bottom_result_sheet.dart';
import 'package:one/router/router.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/snackbar_.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.data});
  final Map<String, dynamic>? data;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late final Doctor? _doctor = widget.data?['doctor'];

  late final XPayDirectOrderRequest? _request = widget.data?['request'];

  late final SubscriptionPlan? _plan = widget.data?['plan'];

  XPayResponse? _xPayResponse;

  PageState _state = PageState.initial;

  double get _orderCardWidth => context.isMobile
      ? MediaQuery.sizeOf(context).width
      : MediaQuery.sizeOf(context).width / 2;

  double get _resultModalHeight => context.isMobile
      ? MediaQuery.sizeOf(context).height / 3
      : MediaQuery.sizeOf(context).height / 2;

  void _updateState(PageState _s) {
    setState(() {
      _state = _s;
    });
  }

  @override
  Widget build(BuildContext context) {
    while (widget.data == null ||
        _doctor == null ||
        _request == null ||
        _plan == null) {
      //handle navigating from an unknown location
      //with request not being initialized
      return Scaffold(
        body: CentralError(
          code: AppErrorCode.orderDetailsException.code,
          toExecute: () async {
            GoRouter.of(context).goNamed(
              AppRouter.mysubscription,
              pathParameters: defaultPathParameters(context),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: _orderCardWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card.outlined(
              elevation: 6,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.orderSummary),
                      ),
                      subtitle: const Divider(color: Colors.grey),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.orderDescription),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _request.order_description.toArabicNumber(
                                context,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.subscriptionPrice),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_request.amount.amount} ${context.loc.egp}'
                                  .toArabicNumber(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.taxPercentage),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_request.vat_percentage} %'.toArabicNumber(
                                context,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.taxTotal),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${(_plan.price * (_request.vat_percentage / 100)).round()} ${context.loc.egp}'
                                  .toArabicNumber(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.orderTotal),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${(_plan.price + (_plan.price * (_request.vat_percentage / 100)).round())} ${context.loc.egp}'
                                  .toArabicNumber(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(color: Colors.grey),
                  ),

                  ///order_details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(switch (_state) {
                          PageState.initial => context.loc.generatePaymentLink,
                          PageState.processing => context.loc.loading,
                          PageState.hasResult =>
                            context.loc.paymentLinkGenerated,
                          PageState.hasError => context.loc.error,
                        }),
                      ),
                      icon: switch (_state) {
                        PageState.initial => const Icon(Icons.monetization_on),
                        PageState.processing => CircularProgressIndicator(
                          backgroundColor: Colors.green.shade100,
                        ),
                        PageState.hasResult => Icon(
                          Icons.check,
                          color: Colors.green.shade100,
                        ),
                        PageState.hasError => const Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                        ),
                      },
                      onPressed:
                          (_state == PageState.processing ||
                              _state == PageState.hasResult)
                          ? null
                          : () async {
                              // XPayResponse _xPayResponseTemplate;
                              _updateState(PageState.processing);
                              try {
                                //todo: Send payment link generation request
                                // _xPayResponseTemplate = await XPayApi()
                                //     .generatePaymentLink(_request);
                                //todo: add doc_sb && sub_pay references
                                // await DocSubPayApi.createDoctorSubscriptionAndSubscriptionPaymentRefrences(
                                //   doctorSubscription: Subscription(
                                //     id: '',
                                //     doc_id: _doctor.id,
                                //     plan_id: _plan.id,
                                //     subscription_status: 'inactive',
                                //     start_date: DateTime.now(),
                                //     end_date: DateTime.now().add(
                                //       Duration(days: _plan.duration_in_days),
                                //     ),
                                //     payment: null,
                                //     payment_id: '',
                                //   ),
                                //   amount: _request.amount.amount,
                                //   x_pay_payment_id:
                                //       _xPayResponseTemplate.data.payment_id,
                                // );

                                // setState(() {
                                //   _xPayResponse = _xPayResponseTemplate;
                                // });
                                _updateState(PageState.hasResult);
                              } on Exception catch (e) {
                                //todo: notify user with error
                                _updateState(PageState.hasError);
                                showIsnackbar(e.toString());
                                return;
                              }

                              if (context.mounted) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return BottomResultSheet(
                                      state: _state,
                                      xPayResponse: _xPayResponse!,
                                      modalHeight: _resultModalHeight,
                                    );
                                  },
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

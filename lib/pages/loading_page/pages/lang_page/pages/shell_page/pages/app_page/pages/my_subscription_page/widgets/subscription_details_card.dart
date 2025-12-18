import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/core/api/subscription_payment_api/doc_sub_pay_api.dart';
import 'package:one/core/api/x-pay/x_pay_api.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/models/doctor_subscription.dart';
import 'package:one/models/page_states_enum.dart';
import 'package:one/models/x_pay/x_pay_direct_order_request.dart';
import 'package:one/models/x_pay/x_pay_payment_status.dart';
import 'package:one/models/x_pay/x_pay_response.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/pages/order_details_page/widgets/bottom_result_sheet.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/widgets/billing_address_input_dialog.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_doc_subscription_info.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailsCard extends StatefulWidget {
  const SubscriptionDetailsCard({super.key, required this.sub});
  final DoctorSubscription sub;

  @override
  State<SubscriptionDetailsCard> createState() =>
      _SubscriptionDetailsCardState();
}

class _SubscriptionDetailsCardState extends State<SubscriptionDetailsCard> {
  PageState _state = PageState.initial;

  void _updateState(PageState _s) {
    setState(() {
      _state = _s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxDocSubscriptionInfo, PxLocale>(
      builder: (context, a, s, l, _) {
        while (a.constants == null) {
          return Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
              ),
            ),
          );
        }
        if (widget.sub.subscription_status == 'active') {
          return Card.filled(
            elevation: 6,
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.currentPlan),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const SmBtn(),
                        titleAlignment: ListTileTitleAlignment.top,
                        title: Builder(
                          builder: (context) {
                            final _plan = a.constants?.subscriptionPlan
                                .firstWhereOrNull(
                                  (e) => widget.sub.plan_id == e.id,
                                );
                            if (_plan == null) {
                              return const SizedBox();
                            }
                            return Text(
                              l.isEnglish ? _plan.name_en : _plan.name_ar,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: context.loc.subscriptionStatus,
                                  children: [
                                    TextSpan(text: ' : '),
                                    TextSpan(
                                      text:
                                          '(${widget.sub.subscription_status.toUpperCase()})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: context.loc.paymentStatus,
                                  children: [
                                    TextSpan(text: ' : '),
                                    WidgetSpan(
                                      child:
                                          (widget.sub.payment != null &&
                                              widget
                                                      .sub
                                                      .payment!
                                                      .x_pay_transaction_status ==
                                                  XpayPaymentStatus
                                                      .SUCCESSFUL
                                                      .name)
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.green.shade100,
                                            )
                                          : Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: context.loc.activationDate,
                                  children: [
                                    TextSpan(text: ' : '),
                                    TextSpan(
                                      text: DateFormat(
                                        'dd / MM / yyyy',
                                        l.lang,
                                      ).format(widget.sub.start_date),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: context.loc.expiryDate,
                                  children: [
                                    TextSpan(text: ' : '),
                                    TextSpan(
                                      text: DateFormat(
                                        'dd / MM / yyyy',
                                        l.lang,
                                      ).format(widget.sub.end_date),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          //inactive subscription card
          final _plan = a.constants!.subscriptionPlan.firstWhere(
            (e) => e.id == widget.sub.plan_id,
          );
          return Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                leading: const SmBtn(),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.isEnglish ? _plan.name_en : _plan.name_ar,
                        ),
                      ),
                      if (widget.sub.inGracePeriod)
                        Text(
                          '${context.loc.inGracePeriod} (${widget.sub.gracePeriodRemaining}) ${context.loc.days}',
                        ),
                    ],
                  ),
                ),
                subtitle: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: context.loc.subscriptionStatus,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text:
                                '(${widget.sub.subscription_status.toUpperCase()})',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.paymentStatus,
                        children: [
                          TextSpan(text: ' : '),
                          WidgetSpan(
                            child:
                                (widget.sub.payment != null &&
                                    widget
                                            .sub
                                            .payment!
                                            .x_pay_transaction_status ==
                                        XpayPaymentStatus.SUCCESSFUL.name)
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green.shade100,
                                  )
                                : Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.activationDate,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: DateFormat(
                              'dd / MM / yyyy',
                              l.lang,
                            ).format(widget.sub.start_date),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: context.loc.expiryDate,
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: DateFormat(
                              'dd / MM / yyyy',
                              l.lang,
                            ).format(widget.sub.end_date),
                          ),
                        ],
                      ),
                    ),
                    if (DateTime.now().isAfter(widget.sub.end_date) ||
                        widget.sub.subscription_status == 'expired')
                      const SizedBox()
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            label: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(switch (_state) {
                                PageState.initial =>
                                  context.loc.generatePaymentLink,
                                PageState.processing => context.loc.loading,
                                PageState.hasResult =>
                                  context.loc.paymentLinkGenerated,
                                PageState.hasError => context.loc.error,
                              }),
                            ),
                            icon: switch (_state) {
                              PageState.initial => const Icon(
                                Icons.monetization_on,
                              ),
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
                                    XPayResponse _xPayResponseTemplate;
                                    _updateState(PageState.processing);
                                    try {
                                      final _billingAddress =
                                          await showDialog<String>(
                                            context: context,
                                            builder: (context) {
                                              return const BillingAddressInputDialog();
                                            },
                                          );
                                      if (_billingAddress == null) {
                                        return;
                                      }
                                      if (!context.mounted) {
                                        return;
                                      }
                                      final XPayDirectOrderRequest _request =
                                          XPayDirectOrderRequest.fromApplicationData(
                                            doctor: context
                                                .read<PxDoctor>()
                                                .doctor!,
                                            plan: a.constants!.subscriptionPlan
                                                .firstWhere(
                                                  (e) =>
                                                      e.id ==
                                                      widget.sub.plan_id,
                                                ),
                                            billing_address: _billingAddress,
                                          );
                                      //todo: Send payment link generation request
                                      _xPayResponseTemplate = await XPayApi()
                                          .generatePaymentLink(_request);
                                      //todo: add doc_sb && sub_pay references
                                      await DocSubPayApi.updateSubPayXpayPaymentReference(
                                        sub_pay_id: widget.sub.payment!.id,
                                        x_pay_payment_id: _xPayResponseTemplate
                                            .data
                                            .payment_id,
                                      );

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
                                            xPayResponse: _xPayResponseTemplate,
                                            modalHeight: context.isMobile
                                                ? MediaQuery.sizeOf(
                                                        context,
                                                      ).height /
                                                      3
                                                : MediaQuery.sizeOf(
                                                        context,
                                                      ).height /
                                                      2,
                                          );
                                        },
                                      );
                                    }
                                  },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

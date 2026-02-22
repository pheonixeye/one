import 'package:one/models/subscriptions/subscription.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/my_subscription_page/widgets/subscription_details_card.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_subscription.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<PxSubscription, PxAppConstants, PxDoctor, PxLocale>(
      builder: (context, s, a, d, l, _) {
        Widget _buildInfoTitle() {
          return switch (s.state) {
            SubscriptionState.pending => Card.outlined(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Expanded(child: LinearProgressIndicator()),
                  ],
                ),
              ),
            ),
            SubscriptionState.active => Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.green,
                    ),
                    Text(context.loc.active),
                  ],
                ),
              ),
            ),
            SubscriptionState.inactive => Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    Text(context.loc.noActiveSubscriptions),
                  ],
                ),
              ),
            ),
            SubscriptionState.grace => Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.amber,
                    ),
                    Text(context.loc.inGracePeriod),
                  ],
                ),
              ),
            ),
          };
        }

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(context.loc.mySubscription)),
                        Expanded(
                          child: _buildInfoTitle(),
                        ),
                        if (!context.isMobile) const Spacer(),
                      ],
                    ),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (s.result == null || a.constants == null) {
                      return const CentralLoading();
                    }

                    while (s.result is ApiErrorResult) {
                      return CentralError(
                        code: (s.result as ApiErrorResult<SubscriptionExpanded>)
                            .errorCode,
                        toExecute: s.retry,
                      );
                    }

                    final _item =
                        (s.result as ApiDataResult<SubscriptionExpanded>).data;
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        final _sub = _item;
                        return SubscriptionDetailsCard(sub: _sub);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

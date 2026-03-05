import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/widgets/sm_btn.dart';

class PrivacyPolicyAndUsageDialog extends StatelessWidget {
  const PrivacyPolicyAndUsageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(context.loc.policyTitle),
          const Spacer(),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: context.isMobile
            ? MediaQuery.widthOf(context) - 50
            : MediaQuery.widthOf(context) / 2,
        height: MediaQuery.heightOf(context) - 50,
        child: ListView(
          cacheExtent: 3000,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Divider(),
            ),
            ListTile(
              title: Row(
                spacing: 8,
                children: [
                  const SmBtn(),
                  const SmBtn(),
                  Text(context.loc.usagePolicyTitle),
                ],
              ),
              subtitle: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
            ),
            PolicyUsageTile(
              index: '1',
              title: context.loc.usageAcceptanceTitle,
              body: context.loc.usageAcceptanceBody,
            ),

            PolicyUsageTile(
              index: '2',
              title: context.loc.usageServiceDescriptionTitle,
              body: context.loc.usageServiceDescriptionBody,
            ),
            PolicyUsageTile(
              index: '3',
              title: context.loc.usageEligibleUseTitle,
              body: context.loc.usageEligibleUseBody,
            ),
            PolicyUsageTile(
              index: '4',
              title: context.loc.usageProhibitedUseTitle,
              body: context.loc.usageProhibitedUseBody,
            ),
            PolicyUsageTile(
              index: '5',
              title: context.loc.usageUserResponsibilitiesTitle,
              body: context.loc.usageUserResponsibilitiesBody,
            ),
            PolicyUsageTile(
              index: '6',
              title: context.loc.usageContractsBillingTitle,
              body: context.loc.usageContractsBillingBody,
            ),
            PolicyUsageTile(
              index: '7',
              title: context.loc.usageSubscriptionTitle,
              body: context.loc.usageSubscriptionBody,
            ),
            PolicyUsageTile(
              index: '8',
              title: context.loc.usageTerminationTitle,
              body: context.loc.usageTerminationBody,
            ),
            PolicyUsageTile(
              index: '9',
              title: context.loc.usageDisclaimerTitle,
              body: context.loc.usageDisclaimerBody,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Divider(),
            ),
            ListTile(
              title: Row(
                spacing: 8,
                children: [
                  const SmBtn(),
                  const SmBtn(),
                  Text(context.loc.privacyPolicyTitle),
                ],
              ),
              subtitle: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
            ),
            PolicyUsageTile(
              index: '1',
              title: context.loc.privacyRolesTitle,
              body: context.loc.privacyRolesBody,
            ),
            PolicyUsageTile(
              index: '2',
              title: context.loc.privacyCollectedDataTitle,
              body: context.loc.privacyCollectedDataBody,
            ),
            PolicyUsageTile(
              index: '2',
              title: context.loc.privacyUsageTitle,
              body: context.loc.privacyUsageBody,
            ),
            PolicyUsageTile(
              index: '3',
              title: context.loc.privacySharingTitle,
              body: context.loc.privacySharingBody,
            ),
            PolicyUsageTile(
              index: '4',
              title: context.loc.privacySecurityTitle,
              body: context.loc.privacySecurityBody,
            ),
            PolicyUsageTile(
              index: '5',
              title: context.loc.privacyRetentionTitle,
              body: context.loc.privacyRetentionBody,
            ),
            PolicyUsageTile(
              index: '6',
              title: context.loc.privacyRightsTitle,
              body: context.loc.privacyRightsBody,
            ),
            PolicyUsageTile(
              index: '7',
              title: context.loc.privacyLiabilityTitle,
              body: context.loc.privacyLiabilityBody,
            ),
            PolicyUsageTile(
              index: '8',
              title: context.loc.policyContactTitle,
              body: context.loc.policyContactBody,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Divider(),
            ),
          ],
        ),
      ),
      scrollable: false,
    );
  }
}

class PolicyUsageTile extends StatelessWidget {
  const PolicyUsageTile({
    super.key,
    required this.title,
    required this.body,
    required this.index,
  });
  final String title;
  final String body;
  final String index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        spacing: 8,
        children: [
          SmBtn(
            child: Text(index.toArabicNumber(context)),
          ),
          Text(title),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsetsDirectional.only(start: 50.0),
        child: Text(body),
      ),
    );
  }
}

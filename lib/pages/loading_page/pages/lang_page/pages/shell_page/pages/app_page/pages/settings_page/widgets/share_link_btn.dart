import 'package:flutter/material.dart';
import 'package:one/core/api/kutt_api.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/booking_url_dialog.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class ShareLinkBtn extends StatelessWidget {
  const ShareLinkBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxAuth>(
      builder: (context, a, _) {
        return SmBtn(
          tooltip: context.loc.shareBookingLink,
          onPressed: () async {
            if (a.organization == null) {
              return;
            }
            String? _url;
            await shellFunction(
              context,
              toExecute: () async {
                _url = await KuttApi(
                  a.organization?.bookingUrl(context) ?? '',
                ).shortenLink();
              },
              duration: const Duration(milliseconds: 260),
            );
            if (_url != null && context.mounted) {
              await showDialog(
                context: context,
                builder: (context) {
                  return BookingUrlDialog(
                    url: _url ?? '',
                  );
                },
              );
            }
          },
          child: const Icon(Icons.share),
        );
      },
    );
  }
}

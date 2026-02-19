import 'package:flutter/material.dart';
import 'package:one/assets/assets.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class CentralError extends StatelessWidget {
  const CentralError({
    super.key,
    required this.code,
    required this.toExecute,
    this.isForQrRescan = false,
  });
  final int? code;
  final Future<void> Function() toExecute;
  final bool isForQrRescan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.outlined(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Image.asset(AppAssets.errorIcon, width: 75, height: 75),
              Consumer<PxLocale>(
                builder: (context, l, _) {
                  return Text(
                    CodeToError(code).errorMessage(l.isEnglish),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: isForQrRescan
                    ? () {
                        toExecute();
                      }
                    : () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await toExecute();
                          },
                        );
                      },
                label: Text(
                  isForQrRescan ? context.loc.rescanQrCode : context.loc.retry,
                ),
                icon: Icon(Icons.refresh, color: Colors.green.shade100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: avoid_web_libraries_in_flutter
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/widgets/map_view.dart';
import 'package:web/web.dart' as html;

import 'package:flutter/material.dart';

class InfoContact extends StatelessWidget {
  const InfoContact({super.key});

  @override
  Widget build(BuildContext context) {
    //todo: RESPONSIVE

    return Expanded(
      flex: 10,
      child: Padding(
        padding: context.isMobile
            ? const EdgeInsets.symmetric(horizontal: 10)
            : const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: context.isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.letsTalk,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(context.loc.haveQuestions),
                ),
                if (!context.isMobile) const Spacer(),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      //todo: implement call
                      html.window.open(
                        "tel:+201555905768",
                        "Call Mobile",
                        "_blank",
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.isMobile ? 0 : 4,
                      ),
                      title: Text(
                        context.loc.callUs,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: const Text(
                        "+201555905768",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(),
                      ),
                    ),
                    onPressed: () {
                      //todo: implement send email
                      //todo: test
                      html.window.open(
                        "mailto:info@ProKliniK.app",
                        "Send Email",
                        "_blank",
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.isMobile ? 0 : 4,
                      ),
                      title: Text(context.loc.emailUs),
                      subtitle: const Text("info@ProKliniK.app"),
                    ),
                  ),
                ),
                if (!context.isMobile) const Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.isMobile ? 0 : 4,
              ),
              leading: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
              title: Text(context.loc.visitHelpCenter),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.isMobile ? 0 : 4,
              ),
              leading: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
              isThreeLine: true,
              title: Text(context.loc.visitUsPersonally),
              subtitle: Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(text: "${context.loc.addressOne}\n"),
                    TextSpan(text: "${context.loc.addressTwo}\n"),
                    TextSpan(text: "${context.loc.addressThree}\n"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const MapViewContainer(),
          ],
        ),
      ),
    );
  }
}

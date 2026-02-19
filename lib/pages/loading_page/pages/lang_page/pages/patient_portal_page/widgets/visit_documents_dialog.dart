import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/number_translator.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/patient_portal_page/widgets/image_viewer_card.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:provider/provider.dart';

class VisitDocumentsDialog extends StatelessWidget {
  const VisitDocumentsDialog({super.key, required this.docs});
  final List<PatientDocumentWithDocumentType>? docs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.documents,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: MediaQuery.widthOf(context) - 50,
        height: MediaQuery.heightOf(context) - 100,
        child: Consumer<PxLocale>(
          builder: (context, l, _) {
            while (docs == null) {
              return const CentralLoading();
            }

            return ListView.builder(
              itemCount: docs!.length,
              itemBuilder: (context, index) {
                final _item = docs![index];
                if (!_item.documentType.is_allowed_on_portal) {
                  return const SizedBox();
                }
                return Card.outlined(
                  elevation: 6,
                  child: ExpansionTile(
                    title: Row(
                      spacing: 8,
                      children: [
                        SizedBox(width: 10),
                        SmBtn(
                          child: Text('${index + 1}'.toArabicNumber(context)),
                        ),
                        Text(
                          l.isEnglish
                              ? _item.documentType.name_en
                              : _item.documentType.name_ar,
                        ),
                      ],
                    ),

                    children: [
                      InteractiveViewer(
                        child: ImageViewerCard(
                          url: _item.document_url,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Divider(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

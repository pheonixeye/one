import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/doctor_items/doctor_doument_type.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageSourceAndDocumentType {
  final DoctorDocumentTypeItem document_type;
  final ImageSource imageSource;

  ImageSourceAndDocumentType({
    required this.document_type,
    required this.imageSource,
  });
}

class ImageSourceAndDocumentTypeDialog extends StatefulWidget {
  const ImageSourceAndDocumentTypeDialog({super.key});

  @override
  State<ImageSourceAndDocumentTypeDialog> createState() =>
      _ImageSourceAndDocumentTypeDialogState();
}

class _ImageSourceAndDocumentTypeDialogState
    extends State<ImageSourceAndDocumentTypeDialog> {
  ImageSource? _imageSource;
  DoctorDocumentTypeItem? _document_type;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctorProfileItems<DoctorDocumentTypeItem>, PxLocale>(
      builder: (context, a, l, _) {
        while (a.data == null) {
          return const CentralLoading();
        }
        while (a.data is ApiErrorResult) {
          return CentralError(
            code: (a.data as ApiErrorResult).errorCode,
            toExecute: a.retry,
          );
        }
        final _data =
            (a.data as ApiDataResult<List<DoctorDocumentTypeItem>>).data;
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.pickImageSourceAndDocumentType)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      leading: const SmBtn(),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.pickImageSource),
                      ),
                      subtitle: FormField<ImageSource?>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (field) {
                          return RadioGroup<ImageSource>(
                            groupValue: _imageSource,
                            onChanged: (val) {
                              setState(() {
                                _imageSource = val;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                ...ImageSource.values.map((e) {
                                  return RadioListTile(
                                    title: Text(switch (e) {
                                      ImageSource.camera => context.loc.camera,
                                      ImageSource.gallery => context.loc.file,
                                    }),
                                    value: e,
                                  );
                                }),
                                if (field.hasError)
                                  Text(
                                    field.errorText ?? '',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        validator: (value) {
                          if (_imageSource == null) {
                            return context.loc.pickImageSource;
                          }
                          return null;
                        },
                        errorBuilder: (context, errorText) {
                          return Text(errorText);
                        },
                      ),
                    ),
                  ),
                ),
                Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      leading: SmBtn(onPressed: null, key: UniqueKey()),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.pickDocumentType),
                      ),
                      subtitle: FormField<DoctorDocumentTypeItem?>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (field) {
                          return RadioGroup<DoctorDocumentTypeItem>(
                            groupValue: _document_type,
                            onChanged: (val) {
                              setState(() {
                                _document_type = val;
                              });
                            },
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._data.map((e) {
                                  return RadioListTile<DoctorDocumentTypeItem>(
                                    title: Text(
                                      l.isEnglish ? e.name_en : e.name_ar,
                                    ),
                                    value: e,
                                  );
                                }),
                                if (field.hasError)
                                  Text(
                                    field.errorText ?? '',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        validator: (value) {
                          if (_document_type == null) {
                            return context.loc.pickDocumentType;
                          }
                          return null;
                        },
                        errorBuilder: (context, errorText) {
                          return Text(errorText);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final _d = ImageSourceAndDocumentType(
                    document_type: _document_type!,
                    imageSource: _imageSource!,
                  );
                  Navigator.pop(context, _d);
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(Icons.check, color: Colors.green.shade100),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}

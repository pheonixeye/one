import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/blob_file.dart';
import 'package:one/providers/px_blobs.dart';
import 'package:one/utils/sound_helper.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/image_view_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class FilesSection extends StatelessWidget {
  const FilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxBlobs>(
      builder: (context, b, _) {
        while (b.result == null || b.files.isEmpty) {
          return const SizedBox(
            height: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: LinearProgressIndicator(),
            ),
          );
        }
        while (b.result is ApiErrorResult) {
          final _err = (b.result as ApiErrorResult).errorCode;
          return CentralError(
            code: _err,
            toExecute: () async {
              await b.retry();
            },
          );
        }
        final _data = (b.result as ApiDataResult<List<BlobFile>>).data;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(child: Text(context.loc.notificationSound)),
                          IconButton.outlined(
                            onPressed: () async {
                              final _sound =
                                  b.files[BlobNames.notification_sound
                                      .toString()];
                              if (_sound != null) {
                                await SoundHelper.playBytes(
                                  AudioPlayer(),
                                  _sound,
                                );
                              }
                            },
                            icon: const Icon(Icons.play_arrow),
                          ),
                        ],
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SmBtn(
                        tooltip: context.loc.pickNotificationSound,
                        key: UniqueKey(),
                        onPressed: () async {
                          final _result = await FilePicker.platform.pickFiles(
                            dialogTitle: context.loc.pickNotificationSound,
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['mp3'],
                            withData: true,
                          );
                          if (_result == null) {
                            return;
                          }
                          final _soundBytes = _result.files.first.bytes;
                          final _soundFileName = _result.files.first.name;
                          if (_soundBytes == null) {
                            return;
                          }
                          if (context.mounted) {
                            final _id = _data
                                .firstWhere(
                                  (e) =>
                                      e.name ==
                                      BlobNames.notification_sound.toString(),
                                )
                                .id;
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await b.updateBlobFile(
                                  _id,
                                  file_bytes: _soundBytes,
                                  filename: _soundFileName,
                                );
                              },
                            );
                          }
                        },
                        child: const Icon(Icons.upload_file),
                      ),
                    ),
                    subtitle: const Divider(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(child: Text(context.loc.appLogo)),
                          IconButton.outlined(
                            onPressed: () async {
                              final _logo =
                                  b.files[BlobNames.app_logo.toString()];
                              if (_logo != null) {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ImageViewDialog(imageBytes: _logo);
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.image_search),
                          ),
                        ],
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SmBtn(
                        tooltip: context.loc.pickAppLogo,
                        onPressed: () async {
                          final _result = await FilePicker.platform.pickFiles(
                            dialogTitle: context.loc.pickAppLogo,
                            allowMultiple: false,
                            type: FileType.image,
                            withData: true,
                          );
                          if (_result == null) {
                            return;
                          }
                          final _logoBytes = _result.files.first.bytes;
                          final _logoFileName = _result.files.first.name;
                          if (_logoBytes == null) {
                            return;
                          }
                          if (context.mounted) {
                            final _id = _data
                                .firstWhere(
                                  (e) =>
                                      e.name == BlobNames.app_logo.toString(),
                                )
                                .id;
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await b.updateBlobFile(
                                  _id,
                                  file_bytes: _logoBytes,
                                  filename: _logoFileName,
                                );
                              },
                            );
                          }
                        },
                        child: const Icon(Icons.upload_file),
                      ),
                    ),
                    subtitle: const Divider(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

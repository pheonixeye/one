import 'dart:typed_data';

import 'package:one/assets/assets.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/widgets/color_picker_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ShowWhichSide {
  front(0),
  back(1),
  side(2);

  final int i;

  const ShowWhichSide(this.i);

  String get asset => switch (this) {
    ShowWhichSide.front => AppAssets.body_front,
    ShowWhichSide.back => AppAssets.body_back,
    ShowWhichSide.side => AppAssets.body_side,
  };

  static ShowWhichSide next(ShowWhichSide value) {
    return switch (value) {
      ShowWhichSide.front => back,
      ShowWhichSide.back => side,
      ShowWhichSide.side => front,
    };
  }
}

class VisualSheetDialog extends StatefulWidget {
  const VisualSheetDialog({super.key, required this.visitData});
  final VisitData visitData;

  @override
  State<VisualSheetDialog> createState() => _VisualSheetDialogState();
}

class _VisualSheetDialogState extends State<VisualSheetDialog> {
  late final _controller = DrawingController();
  Uint8List? _backgroudImage;
  ShowWhichSide _showWhichSide = ShowWhichSide.front;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.drawingSheet,
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: '\n'),
                  TextSpan(
                    text: '(${widget.visitData.patient.name})',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
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
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: DrawingBoard(
          defaultToolsBuilder: (Type t, _) {
            return DrawingBoard.defaultTools(t, _controller)
              ..insert(
                0,
                DefToolItem(
                  icon: _backgroudImage == null
                      ? Icons.image
                      : Icons.image_not_supported,
                  isActive: false,
                  onTap: _backgroudImage == null
                      ? () async {
                          final _result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                            withData: true,
                          );

                          if (_result != null) {
                            setState(() {
                              _backgroudImage = _result.files.first.bytes;
                            });
                          }
                        }
                      : () {
                          setState(() {
                            _backgroudImage = null;
                          });
                        },
                ),
              )
              ..insert(
                1,
                DefToolItem(
                  icon: Icons.rotate_left,
                  isActive: false,
                  onTap: () {
                    setState(() {
                      _showWhichSide = ShowWhichSide.next(_showWhichSide);
                    });
                  },
                ),
              )
              ..insert(
                2,
                DefToolItem(
                  icon: Icons.color_lens,
                  isActive: false,
                  onTap: () async {
                    final _color = await showDialog<Color?>(
                      context: context,
                      builder: (context) {
                        return ColorPickerDialog();
                      },
                    );
                    if (_color == null) {
                      return;
                    }
                    _controller.setStyle(color: _color);
                  },
                ),
              )
              //todo: add hand tool
              ..insert(
                3,
                DefToolItem(
                  icon: FontAwesomeIcons.hand,
                  isActive: t == EmptyContent,
                  onTap: () {
                    _controller.setPaintContent(EmptyContent());
                  },
                ),
              );
          },
          controller: _controller,
          alignment: Alignment.center,
          background: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: _backgroudImage != null
                    ? MemoryImage(_backgroudImage!)
                    : AssetImage(_showWhichSide.asset),
                fit: BoxFit.contain,
              ),
            ),
          ),
          showDefaultActions: true,
          showDefaultTools: true,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            final _data = await _controller.getImageData();
            if (_data != null) {
              final _bytes = Uint8List.sublistView(_data);
              if (context.mounted) {
                Navigator.pop(context, _bytes);
              }
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
  }
}

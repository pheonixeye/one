import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one/models/clinic/prescription_details.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/models/visit_data/visit_form_item.dart';
import 'package:one/models/visit_prescription_state.dart';
import 'package:one/utils/shared_prefs.dart';
import 'package:screenshot/screenshot.dart';

enum PrescriptionView { regular, forms }

class PxVisitPrescriptionState extends ChangeNotifier {
  PxVisitPrescriptionState({required this.clinicId}) {
    init();
    //todo: Implement hive caching instead of session caching
  }

  final String clinicId;

  static const _prescriptionState = 'prescription_state';

  late final ScreenshotController _screenshotController1 =
      ScreenshotController();
  ScreenshotController get screenshotControllerWithImage =>
      _screenshotController1;

  late final ScreenshotController _screenshotController2 =
      ScreenshotController();
  ScreenshotController get screenshotControllerWithoutImage =>
      _screenshotController2;

  VisitPrescriptionState? _state;
  VisitPrescriptionState? get state => _state;

  void init() async {
    final strJson = await asyncPrefs.getString(_prescriptionState);
    if (strJson != null) {
      final decoded = jsonDecode(strJson) as Map<String, dynamic>;
      _state = VisitPrescriptionState(
        clinicId: clinicId,
        items: (decoded[clinicId] as List<dynamic>)
            .map((e) => VisitPrescriptionItem.fromJson(e))
            .toList(),
      );
      notifyListeners();
    } else {
      _state = VisitPrescriptionState(
        clinicId: clinicId,
      );
      notifyListeners();
    }
  }

  Future<void> saveConfiguration() async {
    if (_state != null) {
      final _encoded = jsonEncode(_state);
      await asyncPrefs.setString(_prescriptionState, _encoded);
    }
  }

  void toggleVisibility(String key) {
    final _item = _state?.getItemByKey(key);
    if (_item != null) {
      _state?.updateStateItemByKey(
        key,
        _item.copyWith(
          isVisible: !_item.isVisible,
        ),
      );
      notifyListeners();
    }
  }

  void toggleVisibilityByValue(String key, bool value) {
    final _item = _state?.getItemByKey(key);
    if (_item != null) {
      _state?.updateStateItemByKey(
        key,
        _item.copyWith(
          isVisible: value,
        ),
      );
      notifyListeners();
    }
  }

  void updateItemOffset(String key, Offset offset) {
    final _item = _state?.getItemByKey(key);
    if (_item != null) {
      _state?.updateStateItemByKey(
        key,
        _item.copyWith(
          xCoord: offset.dx,
          yCoord: offset.dy,
        ),
      );
      notifyListeners();
    }
  }

  void resetItemOffset(String key) {
    final _itemDetail = PrescriptionDetails.initial().details[key];
    if (_itemDetail != null) {
      final _item = _state?.getItemByKey(key);
      if (_item != null) {
        _state?.updateStateItemByKey(
          key,
          _item.copyWith(
            xCoord: _itemDetail.x_coord,
            yCoord: _itemDetail.y_coord,
          ),
        );
        notifyListeners();
      }
    }
  }

  void increaseItemFontSize(String key) {
    final _item = _state?.getItemByKey(key);
    if (_item != null) {
      _state?.updateStateItemByKey(
        key,
        _item.copyWith(
          fontSize: _item.fontSize + 1,
        ),
      );
      notifyListeners();
    }
  }

  void decreaseItemFontSize(String key) {
    final _item = _state?.getItemByKey(key);
    if (_item != null) {
      _state?.updateStateItemByKey(
        key,
        _item.copyWith(
          fontSize: _item.fontSize - 1,
        ),
      );
      notifyListeners();
    }
  }

  PrescriptionView _view = PrescriptionView.regular;
  PrescriptionView get view => _view;

  void toggleView() {
    _view = _view == PrescriptionView.regular
        ? PrescriptionView.forms
        : PrescriptionView.regular;
    notifyListeners();
  }

  List<SingleFieldData>? _formItems;
  List<SingleFieldData>? get formItems => _formItems;

  PkForm? _selectedForm;
  PkForm? get selectedForm => _selectedForm;

  void selectFormItems(List<SingleFieldData>? items, PkForm? form) {
    _formItems = items;
    _selectedForm = form;
    notifyListeners();
  }

  CrossAxisAlignment _formItemsCrossAxisAlignment = CrossAxisAlignment.center;
  CrossAxisAlignment get formItemsCrossAxisAlignment =>
      _formItemsCrossAxisAlignment;

  TextAlign _formItemsTextAlign = TextAlign.center;
  TextAlign get formItemsTextAlign => _formItemsTextAlign;

  void toggleAxisAlignment() {
    final _index = _axisAlignments.indexOf(_formItemsCrossAxisAlignment);
    try {
      _formItemsCrossAxisAlignment = _axisAlignments[_index + 1];
      notifyListeners();
    } catch (e) {
      _formItemsCrossAxisAlignment = _axisAlignments[0];
      notifyListeners();
    }
  }

  void toggleTextAlignment() {
    final _index = _textAlignments.indexOf(_formItemsTextAlign);
    try {
      _formItemsTextAlign = _textAlignments[_index + 1];
      notifyListeners();
    } catch (e) {
      _formItemsTextAlign = _textAlignments[0];
      notifyListeners();
    }
  }

  double _formItemsVerticalScale = 1;
  double get formItemsVerticalScale => _formItemsVerticalScale;
  double _formItemsHorizontalScale = 1;
  double get formItemsHorizontalScale => _formItemsHorizontalScale;

  Offset _formItemsOffset = Offset(0, 0);
  Offset get formItemsOffset => _formItemsOffset;

  void updateFormItemsScale(double xScale, yScale) {
    _formItemsHorizontalScale = xScale;
    _formItemsVerticalScale = yScale;
    notifyListeners();
  }

  void updateFormItemsOffset(Offset value) {
    _formItemsOffset = value;
    notifyListeners();
  }
}

final _axisAlignments = [
  CrossAxisAlignment.center,
  CrossAxisAlignment.start,
  CrossAxisAlignment.end,
];

final _textAlignments = [TextAlign.center, TextAlign.right, TextAlign.left];

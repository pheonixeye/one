import 'package:flutter/material.dart';
import 'package:one/models/clinic/prescription_details.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/models/visit_data/visit_form_item.dart';
import 'package:screenshot/screenshot.dart';

enum PrescriptionView { regular, forms }

class PxVisitPrescriptionState extends ChangeNotifier {
  PxVisitPrescriptionState() {
    init();
    //TODO: Implement hive caching instead of session caching
  }

  static final Map<String, Offset> _offsetsSessionCache = {};

  static final Map<String, double> _fontSizedSessionCache = {};

  late final ScreenshotController _screenshotController1 =
      ScreenshotController();
  ScreenshotController get screenshotControllerWithImage =>
      _screenshotController1;

  late final ScreenshotController _screenshotController2 =
      ScreenshotController();
  ScreenshotController get screenshotControllerWithoutImage =>
      _screenshotController2;

  Map<String, bool> _visitPrescriptionVisibility = {};
  Map<String, bool> get visitPrescriptionVisibility =>
      _visitPrescriptionVisibility;

  Map<String, Offset> _visitPrescriptionItemsOffset = {};
  Map<String, Offset> get visitPrescriptionItemsOffset =>
      _visitPrescriptionItemsOffset;

  Map<String, double> _visitPrescriptionItemsFontSize = {};
  Map<String, double> get visitPrescriptionItemsFontSize =>
      _visitPrescriptionItemsFontSize;

  void init() {
    _visitPrescriptionVisibility = Map.fromEntries(
      PrescriptionDetails.initial().details.keys.map((e) {
        return MapEntry(e, true);
      }),
    );
    _visitPrescriptionItemsOffset = Map.fromEntries(
      PrescriptionDetails.initial().details.entries.map((e) {
        if (_offsetsSessionCache[e.key] != null) {
          return MapEntry(e.key, _offsetsSessionCache[e.key]!);
        } else {
          return MapEntry(e.key, Offset(e.value.x_coord, e.value.y_coord));
        }
      }),
    );
    _visitPrescriptionItemsFontSize = Map.fromEntries(
      PrescriptionDetails.initial().details.entries.map((e) {
        if (_fontSizedSessionCache[e.key] != null) {
          return MapEntry(e.key, _fontSizedSessionCache[e.key]!);
        } else {
          return MapEntry(e.key, 14);
        }
      }),
    );
    notifyListeners();
  }

  void toggleVisibility(String key) {
    _visitPrescriptionVisibility[key] = !_visitPrescriptionVisibility[key]!;
    notifyListeners();
  }

  void updateItemOffset(String key, Offset offset) {
    _visitPrescriptionItemsOffset[key] = offset;
    notifyListeners();
    _offsetsSessionCache[key] = offset;
  }

  void increaseItemFontSize(String key) {
    if (_visitPrescriptionItemsFontSize[key] != null) {
      _visitPrescriptionItemsFontSize[key] =
          _visitPrescriptionItemsFontSize[key]! + 1;
      notifyListeners();
      _fontSizedSessionCache[key] = _visitPrescriptionItemsFontSize[key]!;
    }
  }

  void decreaseItemFontSize(String key) {
    if (_visitPrescriptionItemsFontSize[key] != null) {
      _visitPrescriptionItemsFontSize[key] =
          _visitPrescriptionItemsFontSize[key]! - 1;
      notifyListeners();
      _fontSizedSessionCache[key] = _visitPrescriptionItemsFontSize[key]!;
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

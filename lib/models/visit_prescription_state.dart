// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:one/models/clinic/prescription_details.dart';

class VisitPrescriptionState extends Equatable {
  late final List<VisitPrescriptionItem>? _items;
  final String clinicId;

  VisitPrescriptionState({
    required this.clinicId,
    List<VisitPrescriptionItem>? items,
  }) {
    if (items == null) {
      _items = PrescriptionDetails.initial().details.entries.map((entry) {
        final _index = PrescriptionDetails.initial().details.keys
            .toList()
            .indexOf(entry.key);

        return VisitPrescriptionItem(
          key: entry.key,
          isVisible: true,
          fontSize: 16,
          xCoord: 0,
          yCoord: (75 * _index).toDouble(),
        );
      }).toList();
    } else {
      _items = items;
    }
  }

  void updateStateItemByKey(String key, VisitPrescriptionItem value) {
    if (_items != null) {
      final item = _items.firstWhere((e) => e.key == key);
      final index = _items.indexOf(item);
      _items[index] = value;
    }
  }

  VisitPrescriptionItem? getItemByKey(String key) {
    if (_items != null) {
      return _items.firstWhere((e) => e.key == key);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return _items != null
        ? {
            clinicId: [..._items.map((e) => e.toJson())],
          }
        : {
            clinicId: [],
          };
  }

  factory VisitPrescriptionState.fromJson(
    Map<String, dynamic> map,
    String clinic_id,
  ) {
    return VisitPrescriptionState(
      clinicId: clinic_id,
      items: (map[clinic_id] as List<dynamic>)
          .map((e) => VisitPrescriptionItem.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [_items];
}

class VisitPrescriptionItem extends Equatable {
  final String key;
  final bool isVisible;
  final double fontSize;
  final double xCoord;
  final double yCoord;
  const VisitPrescriptionItem({
    required this.key,
    required this.isVisible,
    required this.fontSize,
    required this.xCoord,
    required this.yCoord,
  });

  VisitPrescriptionItem copyWith({
    String? key,
    bool? isVisible,
    double? fontSize,
    double? xCoord,
    double? yCoord,
  }) {
    return VisitPrescriptionItem(
      key: key ?? this.key,
      isVisible: isVisible ?? this.isVisible,
      fontSize: fontSize ?? this.fontSize,
      xCoord: xCoord ?? this.xCoord,
      yCoord: yCoord ?? this.yCoord,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'isVisible': isVisible,
      'fontSize': fontSize,
      'xCoord': xCoord,
      'yCoord': yCoord,
    };
  }

  factory VisitPrescriptionItem.fromJson(Map<String, dynamic> map) {
    return VisitPrescriptionItem(
      key: map['key'] as String,
      isVisible: map['isVisible'] as bool,
      fontSize: map['fontSize'] as double,
      xCoord: map['xCoord'] as double,
      yCoord: map['yCoord'] as double,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      key,
      isVisible,
      fontSize,
      xCoord,
      yCoord,
    ];
  }
}

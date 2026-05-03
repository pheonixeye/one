import 'package:equatable/equatable.dart';

enum PortalView {
  no_view,
  book_view,
  patient_view;

  factory PortalView.fromString(String? value) {
    return switch (value) {
      'new' => book_view,
      'old' => patient_view,
      _ => no_view,
    };
  }
  @override
  String toString() => name.split('.').last;
}

class PortalQuery extends Equatable {
  final PortalView? view;
  final String? org_id;
  final String? doc_id;
  final String? patient_id;

  const PortalQuery({
    required this.view,
    required this.org_id,
    required this.doc_id,
    required this.patient_id,
  });

  PortalQuery copyWith({
    PortalView? view,
    String? org_id,
    String? doc_id,
    String? patient_id,
  }) {
    return PortalQuery(
      view: view ?? this.view,
      org_id: org_id ?? this.org_id,
      doc_id: doc_id ?? this.doc_id,
      patient_id: patient_id ?? this.patient_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'view': view.toString(),
      'org_id': org_id,
      'doc_id': doc_id,
      'patient_id': patient_id,
    };
  }

  factory PortalQuery.fromJson(Map<String, dynamic> map) {
    return PortalQuery(
      view: PortalView.fromString(map['view'] as String),
      org_id: map['org_id'] as String,
      doc_id: map['doc_id'] as String,
      patient_id: map['patient_id'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    view,
    org_id,
    doc_id,
    patient_id,
  ];
}

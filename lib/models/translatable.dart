// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TypedTranslatable extends Equatable {
  final String en;
  final String ar;
  final Type type;

  const TypedTranslatable({
    required this.en,
    required this.ar,
    required this.type,
  });

  @override
  List<Object> get props => [
    en,
    ar,
    type,
  ];
}

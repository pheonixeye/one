// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Translatable extends Equatable {
  final String en;
  final String ar;

  const Translatable({
    required this.en,
    required this.ar,
  });

  @override
  List<Object> get props => [en, ar];
}

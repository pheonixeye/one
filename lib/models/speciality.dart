import 'package:equatable/equatable.dart';

class Speciality extends Equatable {
  final String name_en;
  final String name_ar;
  final String id;
  final String image;

  const Speciality({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'image': image,
    };
  }

  factory Speciality.fromJson(Map<String, dynamic> map) {
    return Speciality(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      image: map['image'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name_en, name_ar, id, image];
}

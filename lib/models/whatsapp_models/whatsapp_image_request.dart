import 'package:equatable/equatable.dart';

class WhatsappImageRequest extends Equatable {
  final String phone;
  final String caption;
  final bool view_once;
  final List<int> image;
  final bool compress;
  final bool is_forwarded;

  const WhatsappImageRequest({
    required this.phone,
    required this.caption,
    this.view_once = false,
    required this.image,
    this.compress = true,
    this.is_forwarded = false,
  });

  WhatsappImageRequest copyWith({
    String? phone,
    String? caption,
    bool? view_once,
    List<int>? image,
    bool? compress,
    bool? is_forwarded,
  }) {
    return WhatsappImageRequest(
      phone: phone ?? this.phone,
      caption: caption ?? this.caption,
      view_once: view_once ?? this.view_once,
      image: image ?? this.image,
      compress: compress ?? this.compress,
      is_forwarded: is_forwarded ?? this.is_forwarded,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'phone': '2$phone',
      'caption': caption,
      'view_once': view_once.toString(),
      'compress': compress.toString(),
      'is_forwarded': is_forwarded.toString(),
    };
  }

  factory WhatsappImageRequest.fromJson(Map<String, dynamic> map) {
    return WhatsappImageRequest(
      phone: map['phone'] as String,
      caption: map['caption'] as String,
      view_once: map['view_once'] as bool,
      image: map['image'] as List<int>,
      compress: map['compress'] as bool,
      is_forwarded: map['is_forwarded'] as bool,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      phone,
      caption,
      view_once,
      image,
      compress,
      is_forwarded,
    ];
  }
}

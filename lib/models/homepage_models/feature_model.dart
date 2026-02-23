import 'package:equatable/equatable.dart';

class Feature extends Equatable {
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int color;

  const Feature({
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.color,
  });

  @override
  List<Object?> get props => [
        titleEn,
        titleAr,
        descriptionEn,
        descriptionAr,
        color,
      ];

  factory Feature.access() {
    return const Feature(
      titleEn: "All Device Access",
      titleAr: "الدخول من اي جهاز",
      descriptionEn: "Basic Login From Any Internet Connected Device.",
      descriptionAr: "الدخول من اي جهاز متصل بالانترنت",
      color: 0xff,
    );
  }

  factory Feature.prescription() {
    return const Feature(
      titleEn: "Electronic Prescription",
      titleAr: "الروشتة الالكترونية",
      descriptionEn: "Printing Prescription Over Clinic Printed Papers.",
      descriptionAr: "طباعة الروشتة علي ورق الروشتة الخاص بالعيادة",
      color: 0xff,
    );
  }

  factory Feature.notifications() {
    return const Feature(
      titleEn: "Notifications",
      titleAr: "نظام التنبيهات",
      descriptionEn:
          "Notifications Over Patient Related Events & in Clinic Calls.",
      descriptionAr:
          "تنبيهات بعمليات المرضي من حجز و حضور و نظام نداء داخل العيادة",
      color: 0xff,
    );
  }

  factory Feature.addImages() {
    return const Feature(
      titleEn: "Add Image To Visit",
      titleAr: "اضافة صور لزيارات المرضي",
      descriptionEn:
          "You Can Use Your Connected Device To Add Images Or Documents to A Patient Visit.",
      descriptionAr: "يمكن اضافة صور لزيارات المرضي عن طريق الجهاز المتصل.",
      color: 0xff,
    );
  }
}

// ignore: constant_identifier_names
const List<Feature> FEATURES = [
  Feature(
    titleEn: "Easy Access",
    titleAr: "التحكم السهل",
    descriptionEn:
        "ProKliniK App Provides Easy Access Over Any Device, be it Mobile, Desktop Or Tablet Thus Ensuring That Your Patient / Clinic Data is Available at All The Times.",
    descriptionAr:
        "يوفر تطبيق بروكلينيك سهولة الوصول عبر أي جهاز، سواء كان ذلك الجهاز المحمول أو سطح المكتب أو الجهاز اللوحي، مما يضمن توفر بيانات المريض / العيادة الخاصة بك في جميع الأوقات.",
    color: 0xff7701FF,
  ),
  Feature(
    titleEn: "Medical Form Builder",
    titleAr: "بناء نماذج طبية مخصصة",
    descriptionEn:
        "ProKliniK Provides an easy Drag and Drop Interface to Design Your Medical / Clinic Forms Thus Making it Compatible With All Medical Specialities Without Any Limitation To The Data The Doctor Wishes To Add.",
    descriptionAr:
        "يوفر تطبيق بروكلينيك امكانية عمل نماذج خاصة بالبيانات الطبية بطريقة الادراج مما يجعله متوافق مع كل التخصصات الطبية بدون حد للبيانات التي يمكن ان يضيفها الطبيب.",
    color: 0xff005FE4,
  ),
  Feature(
    titleEn: "Electronic Prescription",
    titleAr: "الروشتة الالكترونية",
    descriptionEn:
        "Prescribing Medications, Adding Lab And Radiology Requests is Radically Easier With ProKliniK's Interface, The Prescription is Highly Customizable With Templates Ready Suiting Your Needs, Even Printing on Your a5 Prescription Papers is Available Out of The Box.",
    descriptionAr:
        "وصف الادوية و طلب التحاليل الطبية و الاشاعات اسهل مع واجهة نظام بروكلينيك. تعديل الروشتة بنظام الادراج و يمكن استخدام النماذج المتوفرة حسب حاجتك, و بامكانك ايضا طباعة الروشتة علي ورق الروشتة الخاص بعيادتك بدون عناء.",
    color: 0xff02A147,
  ),
  Feature(
    titleEn: "Notification System",
    titleAr: "نظام التنبيهات",
    descriptionEn:
        "ProKliniK's Notification System Understands The Doctor's Needs And Priorities, It Handles Patient Related Events With Diligence And Percision Thus Minimizing Missed Or Unordered Appointments. With a Builtin In Clinic Calls You Won't Even Have To Ring A Bell.",
    descriptionAr:
        "يفهم نظام الإشعارات الخاص ببروكلينيك احتياجات الطبيب وأولوياته، ويتعامل مع الأحداث المتعلقة بالمريض بعناية ودقة وبالتالي يقلل من المواعيد المفقودة أو غير المرتبة. مع مكالمات العيادة المدمجة، لن تضطر حتى إلى قرع الجرس.",
    color: 0xffEDF5FF,
  ),
  Feature(
    titleEn: "BookKeeping System",
    titleAr: "نظام حسابات شامل",
    descriptionEn:
        "BookKeeping is a Major Concern When Comparing Electronic Medical Records Systems. With a Detailed yet Simple Interface, ProKliniK Provides A Comprehensive View Of Any Aspect Of Your Clinic's Financial Management.",
    descriptionAr:
        "تعد الحسابات مصدر قلق كبير عند مقارنة أنظمة السجلات الطبية الإلكترونية. من خلال واجهة تفصيلية وبسيطة، يوفر بروكلينيك رؤية شاملة لأي جانب من جوانب الإدارة المالية لعيادتك.",
    color: 0xff4E627C,
  ),
];

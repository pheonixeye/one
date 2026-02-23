import 'package:equatable/equatable.dart';

class Faq extends Equatable {
  final String qEn;
  final String qAr;
  final String aEn;
  final String aAr;

  const Faq({
    required this.qEn,
    required this.qAr,
    required this.aEn,
    required this.aAr,
  });

  @override
  List<Object?> get props => [
        qEn,
        qAr,
        aEn,
        aAr,
      ];
}

const List<Faq> faqs = [
  Faq(
    qEn: "What Is ProKliniK ?",
    qAr: "هو ايه نظام بروكلينيك ؟",
    aEn:
        "ProKliniK is Made Up of Two Main Parts / Sectors. First, A Clinic Management Software That is Completely Online and Cloud Based, And Second, A Doctor Reservation Portal Where Patients Can Book Appointments With The Doctors Online.",
    aAr:
        "يتكون بروكلينيك من جزأين / قطاعين رئيسيين. أولاً، برنامج إدارة العيادات عبر الإنترنت بالكامل وقائم على السحابة، وثانيًا، بوابة حجز الأطباء حيث يمكن للمرضى حجز مواعيد مع الأطباء عبر الإنترنت.",
  ),
  Faq(
    qEn: "What are the benefits of ProKliniK ?",
    qAr: "ما هي مميزات نظام بروكلينيك ؟",
    aEn: """
Accessibility: Access patient records from anywhere with an internet connection, improving collaboration and remote care. ProKliniK allows you to see your patients wherever they are, be it during home visits or while they are traveling.
Security: ProKliniK utilizes industry-standard security measures like encryption and access controls to safeguard patient data. You can be confident that your patients' information is protected.
Scalability: As your practice grows, you can easily add users or storage space within ProKliniK without expensive hardware upgrades. ProKliniK scales with your needs.
Automatic Updates: With ProKliniK, you never have to worry about updating your software. The vendor handles system updates automatically, ensuring you always have the latest features and security patches.
Cost-Effectiveness: ProKliniK eliminates upfront costs for hardware and IT staff, often leading to lower overall ownership costs. You can focus on providing excellent patient care without worrying about IT headaches.
    """,
    aAr: """
إمكانية الوصول: يمكنك الوصول إلى سجلات المرضى من أي مكان باستخدام اتصال بالإنترنت، مما يؤدي إلى تحسين التعاون والرعاية عن بعد. يتيح لك بروكلينيك رؤية مرضاك أينما كانوا، سواء كان ذلك أثناء الزيارات المنزلية أو أثناء سفرهم.
الأمان: يستخدم بروكلينيك تدابير أمنية متوافقة مع معايير الصناعة مثل التشفير وعناصر التحكم في الوصول لحماية بيانات المريض. يمكنك أن تكون واثقًا من أن معلومات مرضاك محمية.
قابلية التوسع: مع نمو ممارستك، يمكنك بسهولة إضافة مستخدمين أو مساحة تخزين داخل بروكلينيك دون ترقيات الأجهزة باهظة الثمن. موازين بروكلينيك تناسب احتياجاتك.
التحديثات التلقائية: مع بروكلينيك، لا داعي للقلق أبدًا بشأن تحديث برامجك. يتعامل البائع مع تحديثات النظام تلقائيًا، مما يضمن حصولك دائمًا على أحدث الميزات وتصحيحات الأمان.
فعالية التكلفة: تعمل بروكلينيك على التخلص من التكاليف الأولية للأجهزة وموظفي تكنولوجيا المعلومات، مما يؤدي غالبًا إلى انخفاض تكاليف الملكية الإجمالية. يمكنك التركيز على تقديم رعاية ممتازة للمرضى دون القلق بشأن مشكلات تكنولوجيا المعلومات.
    """,
  ),
  Faq(
    qEn: "Is ProKliniK Secure ?",
    qAr: "هل نظام بروكلينيك امن ؟",
    aEn:
        "ProKliniK is compliant with regulations to ensure patient data privacy and security.  We employ robust security measures like encryption, access controls, and regular audits to protect your data.",
    aAr:
        "يتوافق بروكلينيك مع الوائح  لضمان خصوصية وأمن بيانات المرضى. نحن نستخدم تدابير أمنية قوية مثل التشفير وضوابط الوصول وعمليات التدقيق المنتظمة لحماية بياناتك.",
  ),
  Faq(
    qEn: "How can I access ProKliniK ?",
    qAr: "كيف يمكنني الدخول إلى بروكلينيك ؟",
    aEn:
        "ProKliniK is a web-based system, accessible through any standard web browser on a computer, tablet, or even a smartphone. You can also download our mobile app for an even more convenient experience, allowing you to access patient records on the go.",
    aAr:
        "بروكلينيك هو نظام قائم على الويب، ويمكن الوصول إليه من خلال أي متصفح ويب قياسي على جهاز كمبيوتر أو جهاز لوحي أو حتى هاتف ذكي. يمكنك أيضًا تنزيل تطبيق الهاتف المحمول الخاص بنا للحصول على تجربة أكثر ملاءمة، مما يسمح لك بالوصول إلى سجلات المرضى أثناء التنقل.",
  ),
  Faq(
    qEn: "What about Downtimes ?",
    qAr: "ماذا عن أوقات التوقف ؟",
    aEn:
        "ProKliniK strives for exceptional uptime, but occasional outages can occur.  We have a proven track record of reliability and a comprehensive disaster recovery plan to minimize downtime impact. In the unlikely event of an outage, you can be assured our team is working diligently to restore access as quickly as possible.",
    aAr:
        "تسعى بروكلينيك جاهدة لتحقيق وقت تشغيل استثنائي، ولكن قد يحدث انقطاع في الخدمة من حين لآخر. لدينا سجل حافل من الموثوقية وخطة شاملة للتعافي من الكوارث لتقليل تأثير وقت التوقف عن العمل. في حالة حدوث انقطاع غير متوقع، يمكنك التأكد من أن فريقنا يعمل بجد لاستعادة الوصول في أسرع وقت ممكن.",
  ),
  Faq(
    qEn: "Is ProKliniK right for my Clinic ?",
    qAr: "هل بروكلينيك مناسب لعيادتي ؟",
    aEn:
        "ProKliniK can benefit practices of all sizes. Consider your budget, technical expertise, and the importance of remote access when making your decision. ProKliniK offers a scalable and secure solution that can grow with your practice, improve collaboration among your staff, and enhance patient care.",
    aAr:
        "بإمكان بروكلينيك افادة العيادات بكافة أحجامها. ضع في اعتبارك ميزانيتك وخبرتك الفنية وأهمية الوصول عن بعد عند اتخاذ قرارك. تقدم بروكلينيك حلاً آمنًا وقابلاً للتطوير يمكن أن ينمو مع ممارستك، ويحسن التعاون بين موظفيك، ويعزز رعاية المرضى..",
  ),
];

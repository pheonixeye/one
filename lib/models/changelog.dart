// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChangelogEntry extends Equatable {
  final String ar;
  final String en;

  const ChangelogEntry({
    required this.ar,
    required this.en,
  });

  @override
  List<Object> get props => [
        ar,
        en,
      ];
}

class Changelog extends Equatable {
  final String version;
  final List<ChangelogEntry> entries;

  const Changelog({
    required this.version,
    required this.entries,
  });

  @override
  List<Object> get props => [
        version,
        entries,
      ];

  factory Changelog.v001() {
    return Changelog(
      version: '0.0.1',
      entries: [
        ChangelogEntry(
          ar: 'الاصدار الاول',
          en: 'Initial Release',
        ),
      ],
    );
  }
  factory Changelog.v002() {
    return Changelog(
      version: '0.0.2',
      entries: [
        ChangelogEntry(
          ar: 'اكتمال تنفيذ مستندات المريض.',
          en: 'Patient Documents Implementation Complete.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة زر التحديث في صفحة الزيارات اليومية.',
          en: 'Added Refresh Button In Today Visits Page.',
        ),
      ],
    );
  }

  factory Changelog.v003() {
    return Changelog(
      version: '0.0.3',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة تقويم لمراجعة الزيارات الشهرية.',
          en: 'Added Calender For Monthly Visits Review.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة طباعة الإيصالات للزيارات.',
          en: 'Added Reciept Printing For Visits.',
        ),
      ],
    );
  }
  factory Changelog.v004() {
    return Changelog(
      version: '0.0.4',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة ورقة الرسم إلى صفحة النماذج في زيارات اليوم، يمكنك الآن استخدام أي صورة / صور افتراضية كخلفية للرسم / التعيين فوقها وحفظ هذه الصورة كجزء من مستندات المريض.',
          en: 'Added Drawing Sheet To Forms Page In Today Visits, You Can Now Use Any Image / Default Images As A Background For Drawing / Mapping Over It And Save This Image As A part Of The Patient Documents.',
        ),
      ],
    );
  }
  factory Changelog.v0044() {
    return Changelog(
      version: '0.0.4+4',
      entries: [
        ChangelogEntry(
          ar: 'اصلاح خطا برمجي يمنع الزيارت من الفتح بعد تغيير مواعيد العيادات',
          en: 'Hotfix: Visits Not Opening',
        ),
        ChangelogEntry(
          ar: 'تم اضافة امكانية طباعة ملف اكسيل بالزيارات مع حساب ايرادات الزيارات',
          en: 'Added Printing An Excel File With Visits & Calculate Visits Income.',
        ),
      ],
    );
  }

  factory Changelog.v0045() {
    return Changelog(
      version: '0.0.4+5',
      entries: [
        ChangelogEntry(
          ar: 'اصلاح خطا برمجي يمنع اضافة النموذج المرسوم',
          en: 'Hotfix: Patient Documents Not Being Added Correctly',
        ),
      ],
    );
  }
  factory Changelog.v005() {
    return Changelog(
      version: '0.0.5',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة مؤشر يشير إلى أن جدول العيادة مشغول أثناء إضافة زيارة جديدة.',
          en: 'Added Indicator That a Clinic Schedule Is Occupied While Adding a New Visit.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة تكامل خادم WhatsApp، يمكنك الآن إرسال بطاقة هوية المريض عبر WhatsApp مباشرة.',
          en: 'Added Whatsapp Server Integration, You Can Now Send The Patient Id Card Via Whatsapp Directly.',
        ),
      ],
    );
  }
  factory Changelog.v006() {
    return Changelog(
      version: '0.0.6',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة القدرة على تغيير موعد الزيارة في زيارات اليوم.',
          en: 'Added The Ability To Change Visit Schedule In Today Visits.',
        ),
        ChangelogEntry(
          ar: 'يمكنك الآن إضافة الخصومات مباشرة إلى الزيارة في صفحة زيارات اليوم.',
          en: 'You Can Now Add Disounts Direclty To A Visit In Today Visits Page.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة حالة تقدم الزيارة الجديدة بناءً على طلب الدكتور أحمد => "ملغاة".',
          en: 'A New Visit Progress Status Is Added As Requsted By Doctor Ahmed => "Canceled".',
        ),
      ],
    );
  }
  factory Changelog.v007() {
    return Changelog(
      version: '0.0.7',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة الإشعارات إلى التطبيق، يمكنك الآن إرسال واستقبال الإشعارات داخل التطبيق',
          en: 'Added Notifications To The App, You Can Now Send And Recieve Notifications In-App',
        ),
      ],
    );
  }

  factory Changelog.v008() {
    return Changelog(
      version: '0.0.8',
      entries: [
        ChangelogEntry(
          ar: 'إصلاح: تعطل النموذج التشريحي المرئي بعد دورات متعددة',
          en: 'Fix : Visual Anatomical Model Crashing After Multiple Rotations',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة ميزة النشاط للمستخدمين للسماح بإلغاء تنشيط الحسابات ومنع تسجيل الدخول إلى التطبيق دون حذف الحساب',
          en: 'Added Activity Feature To Users To Allow Deactivating Accounts And Prevent Login To The Application Without Deleting The Account',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة اسم للمستخدمين / ميزة تحرير الاسم',
          en: 'Added Name To Users / Name Edit Feature',
        ),
        ChangelogEntry(
          ar: 'السماح بفتح الزيارات القديمة من صفحة الزيارات',
          en: 'Allow Opening Older Visit From Visits Page',
        ),
        ChangelogEntry(
          ar: 'إصلاح: تغيير المستخدمين في العيادة عند التحديث',
          en: 'Fix : Clinic Changing Users On Update',
        ),
        ChangelogEntry(
          ar: 'إمكانية إضافة أو إزالة الأطباء من العيادة عبر حساب "SuperAdmin"',
          en: 'Can Add / Remove Doctors From Clinic Via The "SuperAdmin" Account ',
        ),
        ChangelogEntry(
          ar: 'إصلاح: تحميل الزيارات البطيء عند البحث في صفحة الزيارات',
          en: 'Fix : Slow Visits Loading When Searching In Visits Page',
        ),
        ChangelogEntry(
          ar: 'يمكنك الآن طباعة/حفظ/إرسال/عرض المستندات من صفحة الزيارات',
          en: 'Can Now Print/Save/Send/View Documents From Visits Page',
        ),
        ChangelogEntry(
          ar: 'إصلاح: إعادة تحميل شريط الخصومات عدة مرات',
          en: 'Fix : Discounts Bar Reloading Multiple Times',
        ),
        ChangelogEntry(
          ar: 'إصلاح: إعادة نشر خادم WhatsApp - (قيد الاختبار)',
          en: 'Fix: WhatsApp Server Redeployed - (Under Testing)',
        ),
        ChangelogEntry(
          ar: 'فلترة الزيارات حسب العيادة أو الطبيب',
          en: 'Filtering Visits By Clinic Or Doctor',
        ),
      ],
    );
  }

  factory Changelog.v0081() {
    return Changelog(
      version: '0.0.8+1',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة عرض مُركز لصفحة المحاسبة',
          en: 'added focused view to bookkeeping page',
        ),
        ChangelogEntry(
          ar: 'إصلاح: عدم حساب عدد الزيارات لكل وردية عند عدم العثور على أي زيارات في تاريخ محدد',
          en: 'fix: visits per shift not calculating when no visits are found on a specific date',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة تاكيد عند اضافة نفس المريض في نفس العيادة و التاريخ',
          en: 'added duplicate patient/visit/clinic/date prompt',
        ),
        ChangelogEntry(
          ar: 'تغيير اظهار اسماء عمليات الحسابات بناء علي لغة البرنامج',
          en: 'show translated bookkeeping names',
        ),
        ChangelogEntry(
          ar: 'إصلاح: عدم تنفيذ البحث عن طريق استعلام هاتف المريض بشكل صحيح',
          en: 'fix: searching by patient phone query not executing correctly',
        ),
      ],
    );
  }

  factory Changelog.v0082() {
    return Changelog(
      version: '0.0.8+2',
      entries: [
        ChangelogEntry(
          ar: 'اضافة امكانية تغيير لوجو البرنامج و صوت التنبيه',
          en: 'can now change notification sound and application logo',
        ),
        ChangelogEntry(
          ar: 'اعادة بناء واجهة اعادة المحاولة عند فشل طلب عبر الشبكة',
          en: 'rebuilt interface for when a network request fails',
        ),
        ChangelogEntry(
          ar: 'اصلاحات محدودة للواجهات',
          en: 'minor visual ui improvements',
        ),
        ChangelogEntry(
          ar: 'اضافة امكانية تغيير بيانات الايصال الاساسية من صفحة الاعدادات',
          en: 'you can now change the reciept details for each clinic',
        ),
      ],
    );
  }
}

final List<Changelog> CHANGELOG = [
  Changelog.v0082(),
  Changelog.v0081(),
  Changelog.v008(),
  Changelog.v007(),
  Changelog.v006(),
  Changelog.v005(),
  Changelog.v0045(),
  Changelog.v0044(),
  Changelog.v004(),
  Changelog.v003(),
  Changelog.v002(),
  Changelog.v001(),
];

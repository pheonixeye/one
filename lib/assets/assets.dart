class AppAssets {
  const AppAssets();

  ///image files
  static const String icon = 'assets/images/icon.png';
  static const String bg = 'assets/images/bg.webp';
  static const String bgSvg = 'assets/images/bg-svg.svg';
  static const String err = 'assets/images/404.svg';
  static const String construction = 'assets/images/const-svg.svg';
  static const String registerAvatar = 'assets/images/register-avatar.webp';
  static const String errorIcon = 'assets/images/error.png';
  static const String body_front = 'assets/images/body_front.webp';
  static const String body_back = 'assets/images/body_back.webp';
  static const String body_side = 'assets/images/body_side.webp';

  ///json files
  static const String specialities = "assets/json/specialities.json";

  ///font_files
  static const String ibm_base = 'assets/fonts/IBM/font-Regular-400.ttf';
  static const String ibm_bold = 'assets/fonts/IBM/font-Bold-700.ttf';

  ///doctor_profile_setup
  static const String drugs = 'assets/images/profile_setup/drugs.png';
  static const String labs = 'assets/images/profile_setup/labs.png';
  static const String procedures = 'assets/images/profile_setup/procedures.png';
  static const String radiology = 'assets/images/profile_setup/radiology.png';
  static const String supplies = 'assets/images/profile_setup/supplies.png';

  ///subscription_icons
  static const String monthly = 'assets/images/subscription_icons/monthly.svg';
  static const String halfAnnual =
      'assets/images/subscription_icons/half annual.svg';
  static const String annual = 'assets/images/subscription_icons/annual.svg';

  ///after purchase thankyou
  static const String after_purchase = 'assets/images/after_purchase.svg';

  ///central loading images
  static String loaders(int index) => 'assets/images/loaders/$index.jpg';

  ///notification sound
  static const String notification_sound = 'sounds/notification.mp3';
}

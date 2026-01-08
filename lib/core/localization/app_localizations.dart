import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @homepage.
  ///
  /// In en, this message translates to:
  /// **'HomePage'**
  String get homepage;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'This Page Seems To Be Moved Or Not Available At The Moment, Kindly Try Again Later.'**
  String get errorText;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @todayVisits.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Visits'**
  String get todayVisits;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get register;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'A Doctor\'s Second Brain and Companion.'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ProKliniK HealthCare CRM is a Powerful Tool to Manage Your Workday and Keep in Touch With Your Patients.'**
  String get heroSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginTag.
  ///
  /// In en, this message translates to:
  /// **'Connect with Your Patients, Simplify Your Schedule, and Grow Your Practice.'**
  String get loginTag;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgotPassword;

  /// No description provided for @notRegisteredYet.
  ///
  /// In en, this message translates to:
  /// **'Not Registered Yet ?'**
  String get notRegisteredYet;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create An Account'**
  String get createAccount;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get enterEmailAddress;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Address'**
  String get invalidEmailAddress;

  /// No description provided for @registerTag.
  ///
  /// In en, this message translates to:
  /// **'Join ProKliniK Today and Empower Your Practice with Better Patient Care and Meaningful Growth.'**
  String get registerTag;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get enterConfirmPassword;

  /// No description provided for @speciality.
  ///
  /// In en, this message translates to:
  /// **'Speciality'**
  String get speciality;

  /// No description provided for @selectSpeciality.
  ///
  /// In en, this message translates to:
  /// **'Select Speciality'**
  String get selectSpeciality;

  /// No description provided for @alreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already Registered ?'**
  String get alreadyRegistered;

  /// No description provided for @passwordsNotMatching.
  ///
  /// In en, this message translates to:
  /// **'Password Not Matching.'**
  String get passwordsNotMatching;

  /// No description provided for @passwordEightLetters.
  ///
  /// In en, this message translates to:
  /// **'Password Length Should Be Longer Than 8 Characters.'**
  String get passwordEightLetters;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved @Proklinik Medical Software'**
  String get allRightsReserved;

  /// No description provided for @professionalMessage.
  ///
  /// In en, this message translates to:
  /// **'We look forward to helping you easily manage your healthcare appointments. If you have any feedback on how we can improve, feel free to share it with us. We value your input as we continuously work to enhance our platform.'**
  String get professionalMessage;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A Verification Message Was Sent To Your Email Address.'**
  String get verificationEmailSent;

  /// No description provided for @thankyouForRegistering.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ProKliniK! We’re excited to have you on board.'**
  String get thankyouForRegistering;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A Password Reset Message Was Sent To Your Email Address.'**
  String get passwordResetEmailSent;

  /// No description provided for @englishName.
  ///
  /// In en, this message translates to:
  /// **'English Name'**
  String get englishName;

  /// No description provided for @arabicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Name'**
  String get arabicName;

  /// No description provided for @enterEnglishName.
  ///
  /// In en, this message translates to:
  /// **'Enter English Name'**
  String get enterEnglishName;

  /// No description provided for @enterValidEnglishNameOfTwoUnits.
  ///
  /// In en, this message translates to:
  /// **'Enter Your First, Middle & Last Names in English'**
  String get enterValidEnglishNameOfTwoUnits;

  /// No description provided for @enterArabicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Name'**
  String get enterArabicName;

  /// No description provided for @enterValidArabicNameOfTwoUnits.
  ///
  /// In en, this message translates to:
  /// **'Enter Your First, Middle & Last Names in Arabic'**
  String get enterValidArabicNameOfTwoUnits;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get phone;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Mobile Number - 11 Digits.'**
  String get enterValidPhoneNumber;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @myPatients.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get myPatients;

  /// No description provided for @noPatientsFound.
  ///
  /// In en, this message translates to:
  /// **'No Patients Found.'**
  String get noPatientsFound;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @addNewPatient.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient'**
  String get addNewPatient;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterPatientName.
  ///
  /// In en, this message translates to:
  /// **'Enter Patient Name'**
  String get enterPatientName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterPatientPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Patient Mobile Number'**
  String get enterPatientPhone;

  /// No description provided for @enterValidPatientPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Patient Mobile Number - 11 digits'**
  String get enterValidPatientPhone;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectPatientDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select Patient Date Of Birth'**
  String get selectPatientDateOfBirth;

  /// No description provided for @searchByPatientNameorMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Search By Patient Name or Mobile Number'**
  String get searchByPatientNameorMobileNumber;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @findPatient.
  ///
  /// In en, this message translates to:
  /// **'Find Patient'**
  String get findPatient;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @editPatientData.
  ///
  /// In en, this message translates to:
  /// **'Edit Patient Data'**
  String get editPatientData;

  /// No description provided for @previousPatientVisits.
  ///
  /// In en, this message translates to:
  /// **'Previous Patient Visits'**
  String get previousPatientVisits;

  /// No description provided for @patientActions.
  ///
  /// In en, this message translates to:
  /// **'Patient Actions'**
  String get patientActions;

  /// No description provided for @quickVisit.
  ///
  /// In en, this message translates to:
  /// **'Quick Visit'**
  String get quickVisit;

  /// No description provided for @addNewVisit.
  ///
  /// In en, this message translates to:
  /// **'Add New Visit'**
  String get addNewVisit;

  /// No description provided for @scheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Schedule Appointment'**
  String get scheduleAppointment;

  /// No description provided for @attachForm.
  ///
  /// In en, this message translates to:
  /// **'Attach Form'**
  String get attachForm;

  /// No description provided for @editFormData.
  ///
  /// In en, this message translates to:
  /// **'Edit Form Data'**
  String get editFormData;

  /// No description provided for @detachForm.
  ///
  /// In en, this message translates to:
  /// **'Detach Form'**
  String get detachForm;

  /// No description provided for @patientForms.
  ///
  /// In en, this message translates to:
  /// **'Patient Forms'**
  String get patientForms;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// No description provided for @myClinics.
  ///
  /// In en, this message translates to:
  /// **'My Clinics'**
  String get myClinics;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscription;

  /// No description provided for @forms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get forms;

  /// No description provided for @bookkeeping.
  ///
  /// In en, this message translates to:
  /// **'Bookkeeping'**
  String get bookkeeping;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addNewForm.
  ///
  /// In en, this message translates to:
  /// **'Add New Form'**
  String get addNewForm;

  /// No description provided for @editForm.
  ///
  /// In en, this message translates to:
  /// **'Edit Form'**
  String get editForm;

  /// No description provided for @englishFormName.
  ///
  /// In en, this message translates to:
  /// **'English Form Name'**
  String get englishFormName;

  /// No description provided for @arabicFormName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Form Name'**
  String get arabicFormName;

  /// No description provided for @enterEnglishFormName.
  ///
  /// In en, this message translates to:
  /// **'Enter English Form Name'**
  String get enterEnglishFormName;

  /// No description provided for @enterArabicFormName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Form Name'**
  String get enterArabicFormName;

  /// No description provided for @noFormsFound.
  ///
  /// In en, this message translates to:
  /// **'No Forms Found'**
  String get noFormsFound;

  /// No description provided for @addNewField.
  ///
  /// In en, this message translates to:
  /// **'Add New Field'**
  String get addNewField;

  /// No description provided for @deleteForm.
  ///
  /// In en, this message translates to:
  /// **'Delete Form'**
  String get deleteForm;

  /// No description provided for @formFields.
  ///
  /// In en, this message translates to:
  /// **'Form Fields'**
  String get formFields;

  /// No description provided for @fieldValues.
  ///
  /// In en, this message translates to:
  /// **'Field Values'**
  String get fieldValues;

  /// No description provided for @commaSeparatedValues.
  ///
  /// In en, this message translates to:
  /// **'Separate Values by a (-) sign'**
  String get commaSeparatedValues;

  /// No description provided for @editFieldName.
  ///
  /// In en, this message translates to:
  /// **'Edit Field Name'**
  String get editFieldName;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldName;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Field Type'**
  String get fieldType;

  /// No description provided for @fieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'Try Making The Field Name Remarkable'**
  String get fieldNameHint;

  /// No description provided for @enterFieldName.
  ///
  /// In en, this message translates to:
  /// **'Enter Field Name'**
  String get enterFieldName;

  /// No description provided for @promptDialog.
  ///
  /// In en, this message translates to:
  /// **'Prompt Dialog'**
  String get promptDialog;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteFormField.
  ///
  /// In en, this message translates to:
  /// **'Delete Form Field'**
  String get deleteFormField;

  /// No description provided for @editFormFieldName.
  ///
  /// In en, this message translates to:
  /// **'Edit Form Field Name'**
  String get editFormFieldName;

  /// No description provided for @confirmDeleteForm.
  ///
  /// In en, this message translates to:
  /// **'This Action Will Delete This Form And All Data Related To It\'s Entries, Are You Sure ?'**
  String get confirmDeleteForm;

  /// No description provided for @confirmDeleteFormField.
  ///
  /// In en, this message translates to:
  /// **'This Action Will Delete This Field From This Form And All Data Related To It\'s Entries, This Action Is Irreversible, Are You Sure ?'**
  String get confirmDeleteFormField;

  /// No description provided for @fillForm.
  ///
  /// In en, this message translates to:
  /// **'Fill Form'**
  String get fillForm;

  /// No description provided for @noFormIsSelected.
  ///
  /// In en, this message translates to:
  /// **'No Form Is Selected.'**
  String get noFormIsSelected;

  /// No description provided for @errorDialog.
  ///
  /// In en, this message translates to:
  /// **'Error Dialog'**
  String get errorDialog;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get appLanguage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutPrompt.
  ///
  /// In en, this message translates to:
  /// **'Leaving So Soon ? Are You Sure ?'**
  String get logoutPrompt;

  /// No description provided for @addNewClinic.
  ///
  /// In en, this message translates to:
  /// **'Add New Clinic'**
  String get addNewClinic;

  /// No description provided for @editClinic.
  ///
  /// In en, this message translates to:
  /// **'Update Clinic Info'**
  String get editClinic;

  /// No description provided for @englishClinicName.
  ///
  /// In en, this message translates to:
  /// **'English Clinic Name'**
  String get englishClinicName;

  /// No description provided for @enterEnglishClinicName.
  ///
  /// In en, this message translates to:
  /// **'Enter English Clinic Name'**
  String get enterEnglishClinicName;

  /// No description provided for @arabicClinicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Clinic Name'**
  String get arabicClinicName;

  /// No description provided for @enterArabicClinicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Clinic Name'**
  String get enterArabicClinicName;

  /// No description provided for @consultationFees.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fees'**
  String get consultationFees;

  /// No description provided for @enterConsultationFees.
  ///
  /// In en, this message translates to:
  /// **'Enter Consultation Fees'**
  String get enterConsultationFees;

  /// No description provided for @followupFees.
  ///
  /// In en, this message translates to:
  /// **'Followup Fees'**
  String get followupFees;

  /// No description provided for @procedureFees.
  ///
  /// In en, this message translates to:
  /// **'Procedure Fees'**
  String get procedureFees;

  /// No description provided for @enterProcedureFees.
  ///
  /// In en, this message translates to:
  /// **'Enter Procedure Fees'**
  String get enterProcedureFees;

  /// No description provided for @enterFollowupFees.
  ///
  /// In en, this message translates to:
  /// **'Enter Followup Fees'**
  String get enterFollowupFees;

  /// No description provided for @followupDuration.
  ///
  /// In en, this message translates to:
  /// **'Followup Duration (Days)'**
  String get followupDuration;

  /// No description provided for @enterFollowupDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter Followup Duration In (Days)'**
  String get enterFollowupDuration;

  /// No description provided for @isMain.
  ///
  /// In en, this message translates to:
  /// **'Is Primary Clinic'**
  String get isMain;

  /// No description provided for @noClinicsFound.
  ///
  /// In en, this message translates to:
  /// **'No Clinics Found.'**
  String get noClinicsFound;

  /// No description provided for @toogleClinicActivity.
  ///
  /// In en, this message translates to:
  /// **'Toggle Clinic Activity'**
  String get toogleClinicActivity;

  /// No description provided for @clinicSchedule.
  ///
  /// In en, this message translates to:
  /// **'Clinic Schedule'**
  String get clinicSchedule;

  /// No description provided for @deleteClinic.
  ///
  /// In en, this message translates to:
  /// **'Delete Clinic'**
  String get deleteClinic;

  /// No description provided for @deleteClinicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Deleting This Clinic Will Remove All The Clinic Information And All Visits/Schedules Related To This Clinic In Different Parts Of The Application, This Action Is Irreversible, Are You Sure?'**
  String get deleteClinicPrompt;

  /// No description provided for @deletePrimaryClinicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete Primary Clinic ? Are You Sure ?'**
  String get deletePrimaryClinicPrompt;

  /// No description provided for @clinicDays.
  ///
  /// In en, this message translates to:
  /// **'Clinic Days'**
  String get clinicDays;

  /// No description provided for @dayShifts.
  ///
  /// In en, this message translates to:
  /// **'Day Shifts'**
  String get dayShifts;

  /// No description provided for @addClinicDay.
  ///
  /// In en, this message translates to:
  /// **'Add Clinic Day'**
  String get addClinicDay;

  /// No description provided for @addDayShift.
  ///
  /// In en, this message translates to:
  /// **'Add Day Shift'**
  String get addDayShift;

  /// No description provided for @noScheduleDaysFound.
  ///
  /// In en, this message translates to:
  /// **'No Working Days Were Added To This Clinic.'**
  String get noScheduleDaysFound;

  /// No description provided for @addWorkingWeekday.
  ///
  /// In en, this message translates to:
  /// **'Add Working Day'**
  String get addWorkingWeekday;

  /// No description provided for @shiftStartingTime.
  ///
  /// In en, this message translates to:
  /// **'Shift Starting Time'**
  String get shiftStartingTime;

  /// No description provided for @shiftEndingTime.
  ///
  /// In en, this message translates to:
  /// **'Shift Ending Time'**
  String get shiftEndingTime;

  /// No description provided for @noDayShiftsFound.
  ///
  /// In en, this message translates to:
  /// **'No Shifts Added Yet'**
  String get noDayShiftsFound;

  /// No description provided for @allowedNumberOfVisits.
  ///
  /// In en, this message translates to:
  /// **'Allowed Number Of Visits Per Shift'**
  String get allowedNumberOfVisits;

  /// No description provided for @visitsPerShift.
  ///
  /// In en, this message translates to:
  /// **'Visits Per Shift'**
  String get visitsPerShift;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @deleteShift.
  ///
  /// In en, this message translates to:
  /// **'Delete Shift'**
  String get deleteShift;

  /// No description provided for @deleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete Schedule'**
  String get deleteSchedule;

  /// No description provided for @deleteSchedulePrompt.
  ///
  /// In en, this message translates to:
  /// **'Deleting This Working Clinic Day Will Also Delete it\'s Shifts - This Action Is Irreversible - Are You Sure?'**
  String get deleteSchedulePrompt;

  /// No description provided for @clinicPrescription.
  ///
  /// In en, this message translates to:
  /// **'Clinic Prescription'**
  String get clinicPrescription;

  /// No description provided for @noPrescriptionFileFound.
  ///
  /// In en, this message translates to:
  /// **'No Prescription File Found'**
  String get noPrescriptionFileFound;

  /// No description provided for @addPrescriptionFile.
  ///
  /// In en, this message translates to:
  /// **'Add Prescription File'**
  String get addPrescriptionFile;

  /// No description provided for @deletePrescriptionFile.
  ///
  /// In en, this message translates to:
  /// **'Delete Prescription File'**
  String get deletePrescriptionFile;

  /// No description provided for @prescriptionMenu.
  ///
  /// In en, this message translates to:
  /// **'Prescription Menu'**
  String get prescriptionMenu;

  /// No description provided for @deletePrescriptionFilePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure About Deleting This Image File - All Prescription Related Settings Will Be Affected - Are You Sure ?'**
  String get deletePrescriptionFilePrompt;

  /// No description provided for @viewPdfPrescription.
  ///
  /// In en, this message translates to:
  /// **'View Pdf Version'**
  String get viewPdfPrescription;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// No description provided for @doctorDrugs.
  ///
  /// In en, this message translates to:
  /// **'Prescription Drugs'**
  String get doctorDrugs;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @laboratoryRequests.
  ///
  /// In en, this message translates to:
  /// **'Laboratory Requests'**
  String get laboratoryRequests;

  /// No description provided for @radiology.
  ///
  /// In en, this message translates to:
  /// **'Radiology'**
  String get radiology;

  /// No description provided for @procedures.
  ///
  /// In en, this message translates to:
  /// **'Doctor Procedures'**
  String get procedures;

  /// No description provided for @supplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get supplies;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchByEnglishOrArabicItemName.
  ///
  /// In en, this message translates to:
  /// **'Search By English Or Arabic Item Name'**
  String get searchByEnglishOrArabicItemName;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No Items Found.'**
  String get noItemsFound;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @englishItemName.
  ///
  /// In en, this message translates to:
  /// **'English Item Name'**
  String get englishItemName;

  /// No description provided for @arabicItemName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Item Name'**
  String get arabicItemName;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteItemPrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete This Item From Your Collection, Are You Sure ?'**
  String get deleteItemPrompt;

  /// No description provided for @drugFormAndConcentration.
  ///
  /// In en, this message translates to:
  /// **'Drug Form And Concentration'**
  String get drugFormAndConcentration;

  /// No description provided for @drugDefaultDoses.
  ///
  /// In en, this message translates to:
  /// **'Drug Default Doses'**
  String get drugDefaultDoses;

  /// No description provided for @labSpecialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Lab Special Instructions'**
  String get labSpecialInstructions;

  /// No description provided for @radiologyType.
  ///
  /// In en, this message translates to:
  /// **'Radiology Type'**
  String get radiologyType;

  /// No description provided for @radSpecialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Rad Special Instructions'**
  String get radSpecialInstructions;

  /// No description provided for @supplyItemUnit.
  ///
  /// In en, this message translates to:
  /// **'Supply Item Unit'**
  String get supplyItemUnit;

  /// No description provided for @reorderQuantity.
  ///
  /// In en, this message translates to:
  /// **'Reorder Quantity'**
  String get reorderQuantity;

  /// No description provided for @buyingPrice.
  ///
  /// In en, this message translates to:
  /// **'Buying Price'**
  String get buyingPrice;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get sellingPrice;

  /// No description provided for @notifyOnReorder.
  ///
  /// In en, this message translates to:
  /// **'Notify On Reorder'**
  String get notifyOnReorder;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage'**
  String get discountPercentage;

  /// No description provided for @drugConcentration.
  ///
  /// In en, this message translates to:
  /// **'Drug Concentration'**
  String get drugConcentration;

  /// No description provided for @drugForm.
  ///
  /// In en, this message translates to:
  /// **'Drug Form'**
  String get drugForm;

  /// No description provided for @drugUnit.
  ///
  /// In en, this message translates to:
  /// **'Drug Unit'**
  String get drugUnit;

  /// No description provided for @supplyItemUnitEn.
  ///
  /// In en, this message translates to:
  /// **'English Supply Storage Unit'**
  String get supplyItemUnitEn;

  /// No description provided for @supplyItemUnitAr.
  ///
  /// In en, this message translates to:
  /// **'Arabic Supply Storage Unit'**
  String get supplyItemUnitAr;

  /// No description provided for @noSubscriptionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Subscriptions Found'**
  String get noSubscriptionsFound;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Active Plan'**
  String get currentPlan;

  /// No description provided for @activationDate.
  ///
  /// In en, this message translates to:
  /// **'Activation Date'**
  String get activationDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @subscriptionStatus.
  ///
  /// In en, this message translates to:
  /// **'Subscription Status'**
  String get subscriptionStatus;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No Active Subscription'**
  String get noActiveSubscriptions;

  /// No description provided for @purchaseSubscription.
  ///
  /// In en, this message translates to:
  /// **'Purchase Subscription'**
  String get purchaseSubscription;

  /// No description provided for @inGracePeriod.
  ///
  /// In en, this message translates to:
  /// **'In Grace Period'**
  String get inGracePeriod;

  /// No description provided for @errorOneSubscriptionIsActive.
  ///
  /// In en, this message translates to:
  /// **'Atleast One Subscription Is Active, Cannot Proceed.'**
  String get errorOneSubscriptionIsActive;

  /// No description provided for @billingAddress.
  ///
  /// In en, this message translates to:
  /// **'Billing Address'**
  String get billingAddress;

  /// No description provided for @enterBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Billing Address'**
  String get enterBillingAddress;

  /// No description provided for @enterBillingAddressInArabic.
  ///
  /// In en, this message translates to:
  /// **'Enter Billing Address In Arabic'**
  String get enterBillingAddressInArabic;

  /// No description provided for @selectSubscription.
  ///
  /// In en, this message translates to:
  /// **'Select Subscription'**
  String get selectSubscription;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @generatePaymentLink.
  ///
  /// In en, this message translates to:
  /// **'Generate Payment Link'**
  String get generatePaymentLink;

  /// No description provided for @orderDescription.
  ///
  /// In en, this message translates to:
  /// **'Order Description'**
  String get orderDescription;

  /// No description provided for @subscriptionPrice.
  ///
  /// In en, this message translates to:
  /// **'Subscription Price'**
  String get subscriptionPrice;

  /// No description provided for @taxPercentage.
  ///
  /// In en, this message translates to:
  /// **'Tax Percentage'**
  String get taxPercentage;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get orderTotal;

  /// No description provided for @taxTotal.
  ///
  /// In en, this message translates to:
  /// **'Tax Total'**
  String get taxTotal;

  /// No description provided for @youSave.
  ///
  /// In en, this message translates to:
  /// **'You Save'**
  String get youSave;

  /// No description provided for @vatExclusive.
  ///
  /// In en, this message translates to:
  /// **'All Prices Are VAT% Exclusive'**
  String get vatExclusive;

  /// No description provided for @paymentLink.
  ///
  /// In en, this message translates to:
  /// **'Payment Link'**
  String get paymentLink;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paymentLinkGenerated.
  ///
  /// In en, this message translates to:
  /// **'Payment Link Generated'**
  String get paymentLinkGenerated;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @thankyouForYourPurchase.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has been successfully activated. You now have full access to all the features designed to help you manage appointments, patient records, billing, and more — all in one place.'**
  String get thankyouForYourPurchase;

  /// No description provided for @pickClinic.
  ///
  /// In en, this message translates to:
  /// **'Pick Clinic'**
  String get pickClinic;

  /// No description provided for @pickClinicSchedule.
  ///
  /// In en, this message translates to:
  /// **'Pick Visit Day'**
  String get pickClinicSchedule;

  /// No description provided for @pickClinicScheduleShift.
  ///
  /// In en, this message translates to:
  /// **'Pick Clinic Shift'**
  String get pickClinicScheduleShift;

  /// No description provided for @pickVisitDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Visit Date'**
  String get pickVisitDate;

  /// No description provided for @pickVisitType.
  ///
  /// In en, this message translates to:
  /// **'Pick Visit Type'**
  String get pickVisitType;

  /// No description provided for @pickVisitStatus.
  ///
  /// In en, this message translates to:
  /// **'Pick Visit Status'**
  String get pickVisitStatus;

  /// No description provided for @pickPatientProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'Pick Patient Progress'**
  String get pickPatientProgressStatus;

  /// No description provided for @noVisitsFoundForToday.
  ///
  /// In en, this message translates to:
  /// **'No Visits Found For Today'**
  String get noVisitsFoundForToday;

  /// No description provided for @attendanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Attendance Status'**
  String get attendanceStatus;

  /// No description provided for @progressStatus.
  ///
  /// In en, this message translates to:
  /// **'Progress Status'**
  String get progressStatus;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @dayVisitCount.
  ///
  /// In en, this message translates to:
  /// **'Visit Count'**
  String get dayVisitCount;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @visitForms.
  ///
  /// In en, this message translates to:
  /// **'Visit Forms'**
  String get visitForms;

  /// No description provided for @visitDrugs.
  ///
  /// In en, this message translates to:
  /// **'Visit Drugs'**
  String get visitDrugs;

  /// No description provided for @visitLabs.
  ///
  /// In en, this message translates to:
  /// **'Visit Labs'**
  String get visitLabs;

  /// No description provided for @visitRads.
  ///
  /// In en, this message translates to:
  /// **'Visit Rads'**
  String get visitRads;

  /// No description provided for @visitProcedures.
  ///
  /// In en, this message translates to:
  /// **'Visit Procedures'**
  String get visitProcedures;

  /// No description provided for @visitSupplies.
  ///
  /// In en, this message translates to:
  /// **'Visit Supplies'**
  String get visitSupplies;

  /// No description provided for @detachFormPrompt.
  ///
  /// In en, this message translates to:
  /// **'This Action Will Detach This Form And All Data Related To It\'s Entries Will Be Deleted, Are You Sure ?'**
  String get detachFormPrompt;

  /// No description provided for @drugDose.
  ///
  /// In en, this message translates to:
  /// **'Drug Dose'**
  String get drugDose;

  /// No description provided for @saveToDefaultDoses.
  ///
  /// In en, this message translates to:
  /// **'Save To Default Doses'**
  String get saveToDefaultDoses;

  /// No description provided for @noDoseSelected.
  ///
  /// In en, this message translates to:
  /// **'No Dose Selected'**
  String get noDoseSelected;

  /// No description provided for @doseSelected.
  ///
  /// In en, this message translates to:
  /// **'Dose Selected'**
  String get doseSelected;

  /// No description provided for @attachLabResult.
  ///
  /// In en, this message translates to:
  /// **'Attach Lab Result'**
  String get attachLabResult;

  /// No description provided for @attachRadResult.
  ///
  /// In en, this message translates to:
  /// **'Attach Radiology Result'**
  String get attachRadResult;

  /// No description provided for @visitPrescription.
  ///
  /// In en, this message translates to:
  /// **'Visit Prescription'**
  String get visitPrescription;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @printPrescription.
  ///
  /// In en, this message translates to:
  /// **'Print Prescription'**
  String get printPrescription;

  /// No description provided for @toggleFormsView.
  ///
  /// In en, this message translates to:
  /// **'Toggle Forms View'**
  String get toggleFormsView;

  /// No description provided for @visitNotAttended.
  ///
  /// In en, this message translates to:
  /// **'Visit Not Attended'**
  String get visitNotAttended;

  /// No description provided for @inventorySupplies.
  ///
  /// In en, this message translates to:
  /// **'Inventory Supplies'**
  String get inventorySupplies;

  /// No description provided for @newSupplyMovement.
  ///
  /// In en, this message translates to:
  /// **'New Supply Movement'**
  String get newSupplyMovement;

  /// No description provided for @editSupplyMovement.
  ///
  /// In en, this message translates to:
  /// **'Edit Supply Movement'**
  String get editSupplyMovement;

  /// No description provided for @pickSupplyItem.
  ///
  /// In en, this message translates to:
  /// **'Pick Supply Item'**
  String get pickSupplyItem;

  /// No description provided for @movementDirection.
  ///
  /// In en, this message translates to:
  /// **'Movement Direction'**
  String get movementDirection;

  /// No description provided for @movementReason.
  ///
  /// In en, this message translates to:
  /// **'Movement Reason'**
  String get movementReason;

  /// No description provided for @enterMovementReason.
  ///
  /// In en, this message translates to:
  /// **'Enter Movement Reason'**
  String get enterMovementReason;

  /// No description provided for @movementQuantity.
  ///
  /// In en, this message translates to:
  /// **'Movement Quantity (Number Of Items)'**
  String get movementQuantity;

  /// No description provided for @enterMovementQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter Movement Quantity'**
  String get enterMovementQuantity;

  /// No description provided for @movementAmount.
  ///
  /// In en, this message translates to:
  /// **'Movement Amount (Total Price Of Items)'**
  String get movementAmount;

  /// No description provided for @enterMovementAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Movement Amount'**
  String get enterMovementAmount;

  /// No description provided for @pickSourceClinic.
  ///
  /// In en, this message translates to:
  /// **'Pick Source Clinic'**
  String get pickSourceClinic;

  /// No description provided for @pickDestinationClinic.
  ///
  /// In en, this message translates to:
  /// **'Pick Destination Clinic'**
  String get pickDestinationClinic;

  /// No description provided for @noSupplyMovementsFound.
  ///
  /// In en, this message translates to:
  /// **'No Supply Movements Found In Given Duration'**
  String get noSupplyMovementsFound;

  /// No description provided for @addedBy.
  ///
  /// In en, this message translates to:
  /// **'Added By'**
  String get addedBy;

  /// No description provided for @supplyItemsMovement.
  ///
  /// In en, this message translates to:
  /// **'Supply Items Movements'**
  String get supplyItemsMovement;

  /// No description provided for @clinicInventory.
  ///
  /// In en, this message translates to:
  /// **'Clinic Inventory'**
  String get clinicInventory;

  /// No description provided for @addItemsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Add Items With Count'**
  String get addItemsWithCount;

  /// No description provided for @enterInitialItemAvailableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter Initial Item Available Quantity'**
  String get enterInitialItemAvailableQuantity;

  /// No description provided for @pickStartingDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Starting Date'**
  String get pickStartingDate;

  /// No description provided for @pickEndingDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Ending Date'**
  String get pickEndingDate;

  /// No description provided for @availableSupplyItemsQuantities.
  ///
  /// In en, this message translates to:
  /// **'Available Supply Items Quantities'**
  String get availableSupplyItemsQuantities;

  /// No description provided for @transferQuantity.
  ///
  /// In en, this message translates to:
  /// **'Transfer Quantity'**
  String get transferQuantity;

  /// No description provided for @removeSupplyItemAmountFirst.
  ///
  /// In en, this message translates to:
  /// **'Remove Supply Item Amount First'**
  String get removeSupplyItemAmountFirst;

  /// No description provided for @availableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Available Quantity'**
  String get availableQuantity;

  /// No description provided for @noAvailableQuantity.
  ///
  /// In en, this message translates to:
  /// **'No Available Quantity'**
  String get noAvailableQuantity;

  /// No description provided for @supplyItem.
  ///
  /// In en, this message translates to:
  /// **'Supply Item'**
  String get supplyItem;

  /// No description provided for @clinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinic;

  /// No description provided for @relatedVisitId.
  ///
  /// In en, this message translates to:
  /// **'Related Visit Id'**
  String get relatedVisitId;

  /// No description provided for @autoAdd.
  ///
  /// In en, this message translates to:
  /// **'Auto Add'**
  String get autoAdd;

  /// No description provided for @movementDate.
  ///
  /// In en, this message translates to:
  /// **'Movement Date'**
  String get movementDate;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @printSupplyMovements.
  ///
  /// In en, this message translates to:
  /// **'Print Supply Movements'**
  String get printSupplyMovements;

  /// No description provided for @noBookkeepingEntriesFoundInSelectedDate.
  ///
  /// In en, this message translates to:
  /// **'No Bookkeeping Entries Found In Selected Date'**
  String get noBookkeepingEntriesFoundInSelectedDate;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @operation.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get operation;

  /// No description provided for @bkType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bkType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @bookkeepingBalance.
  ///
  /// In en, this message translates to:
  /// **'Bookkeeping Balance'**
  String get bookkeepingBalance;

  /// No description provided for @durationBalance.
  ///
  /// In en, this message translates to:
  /// **'Duration Balance'**
  String get durationBalance;

  /// No description provided for @printBookkeepingReport.
  ///
  /// In en, this message translates to:
  /// **'Print Bookkeeping Report'**
  String get printBookkeepingReport;

  /// No description provided for @addBookkeepingEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Bookkeeping Entry'**
  String get addBookkeepingEntry;

  /// No description provided for @operationName.
  ///
  /// In en, this message translates to:
  /// **'Operation Name'**
  String get operationName;

  /// No description provided for @amountInPounds.
  ///
  /// In en, this message translates to:
  /// **'Amount In EGP'**
  String get amountInPounds;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @patientMovementProgress.
  ///
  /// In en, this message translates to:
  /// **'Patient Movement Progress'**
  String get patientMovementProgress;

  /// No description provided for @noVisitsFoundForSelectedDateRange.
  ///
  /// In en, this message translates to:
  /// **'No Visits Found For Selected Date Range'**
  String get noVisitsFoundForSelectedDateRange;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @visitDate.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get visitDate;

  /// No description provided for @clinicShift.
  ///
  /// In en, this message translates to:
  /// **'Clinic Shift'**
  String get clinicShift;

  /// No description provided for @visitType.
  ///
  /// In en, this message translates to:
  /// **'Visit Type'**
  String get visitType;

  /// No description provided for @visitData.
  ///
  /// In en, this message translates to:
  /// **'Visit Data'**
  String get visitData;

  /// No description provided for @patientCard.
  ///
  /// In en, this message translates to:
  /// **'Patient Card'**
  String get patientCard;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QrCode'**
  String get scanQrCode;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @sendViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send Via Whatsapp'**
  String get sendViaWhatsapp;

  /// No description provided for @assistantAccounts.
  ///
  /// In en, this message translates to:
  /// **'Assistant Accounts'**
  String get assistantAccounts;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @clinics.
  ///
  /// In en, this message translates to:
  /// **'Clinics'**
  String get clinics;

  /// No description provided for @addAssistantAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Assistant Account'**
  String get addAssistantAccount;

  /// No description provided for @cannotChangeAccountType.
  ///
  /// In en, this message translates to:
  /// **'Cannot Change Account Type'**
  String get cannotChangeAccountType;

  /// No description provided for @pickDoctor.
  ///
  /// In en, this message translates to:
  /// **'Select Attending Doctor'**
  String get pickDoctor;

  /// No description provided for @unAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Un Authorized'**
  String get unAuthorized;

  /// No description provided for @accountNotAuthorizedToPerformAction.
  ///
  /// In en, this message translates to:
  /// **'Your Account Is Not Authorized To Perform This Action.'**
  String get accountNotAuthorizedToPerformAction;

  /// No description provided for @notAnAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Not An Admin Account'**
  String get notAnAdminAccount;

  /// No description provided for @noVisitsFoundForThisPatient.
  ///
  /// In en, this message translates to:
  /// **'No Visits Found For This Patient'**
  String get noVisitsFoundForThisPatient;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @patientDocuments.
  ///
  /// In en, this message translates to:
  /// **'Patient Documents'**
  String get patientDocuments;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @attachDocument.
  ///
  /// In en, this message translates to:
  /// **'Attach Document'**
  String get attachDocument;

  /// No description provided for @pickImageSourceAndDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Pick Image Source And Document Type'**
  String get pickImageSourceAndDocumentType;

  /// No description provided for @pickImageSource.
  ///
  /// In en, this message translates to:
  /// **'Pick Image Source'**
  String get pickImageSource;

  /// No description provided for @pickDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Pick Document Type'**
  String get pickDocumentType;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @visitsCalender.
  ///
  /// In en, this message translates to:
  /// **'Visits Calender'**
  String get visitsCalender;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @printReciept.
  ///
  /// In en, this message translates to:
  /// **'Print Reciept'**
  String get printReciept;

  /// No description provided for @changeLog.
  ///
  /// In en, this message translates to:
  /// **'Change Log'**
  String get changeLog;

  /// No description provided for @addDrawingSheet.
  ///
  /// In en, this message translates to:
  /// **'Add Drawing Sheet'**
  String get addDrawingSheet;

  /// No description provided for @drawingSheet.
  ///
  /// In en, this message translates to:
  /// **'Drawing Sheet'**
  String get drawingSheet;

  /// No description provided for @pickDrawingColor.
  ///
  /// In en, this message translates to:
  /// **'Pick Drawing Color'**
  String get pickDrawingColor;

  /// No description provided for @exportToExcel.
  ///
  /// In en, this message translates to:
  /// **'Export To Excel'**
  String get exportToExcel;

  /// No description provided for @whatsappSettings.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp Settings'**
  String get whatsappSettings;

  /// No description provided for @connectWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Connect Whatsapp'**
  String get connectWhatsapp;

  /// No description provided for @whatsappDevices.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp Devices'**
  String get whatsappDevices;

  /// No description provided for @showConnectedwhatsappDevices.
  ///
  /// In en, this message translates to:
  /// **'Show Connected whatsapp Devices'**
  String get showConnectedwhatsappDevices;

  /// No description provided for @noConnectedDevices.
  ///
  /// In en, this message translates to:
  /// **'No Connected Devices'**
  String get noConnectedDevices;

  /// No description provided for @conntectedToWhatsappServer.
  ///
  /// In en, this message translates to:
  /// **'Conntected To Whatsapp Server'**
  String get conntectedToWhatsappServer;

  /// No description provided for @notConntectedToWhatsappServer.
  ///
  /// In en, this message translates to:
  /// **'Not Conntected To Whatsapp Server'**
  String get notConntectedToWhatsappServer;

  /// No description provided for @patientVisits.
  ///
  /// In en, this message translates to:
  /// **'Patient Visits'**
  String get patientVisits;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @addDiscount.
  ///
  /// In en, this message translates to:
  /// **'Add Discount'**
  String get addDiscount;

  /// No description provided for @removeDiscount.
  ///
  /// In en, this message translates to:
  /// **'Remove Discount'**
  String get removeDiscount;

  /// No description provided for @discountInPounds.
  ///
  /// In en, this message translates to:
  /// **'Discount In Pounds'**
  String get discountInPounds;

  /// No description provided for @noDiscountApplied.
  ///
  /// In en, this message translates to:
  /// **'No Discounts Applied'**
  String get noDiscountApplied;

  /// No description provided for @rescheduleVisitShift.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Visit Shift'**
  String get rescheduleVisitShift;

  /// No description provided for @sameShiftSelected.
  ///
  /// In en, this message translates to:
  /// **'Same Shift Selected'**
  String get sameShiftSelected;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @addNewNotification.
  ///
  /// In en, this message translates to:
  /// **'Add New Notification'**
  String get addNewNotification;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Title'**
  String get notificationTitle;

  /// No description provided for @notificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Notification Message'**
  String get notificationMessage;

  /// No description provided for @saveToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save To Favorites'**
  String get saveToFavorites;

  /// No description provided for @doctorAccounts.
  ///
  /// In en, this message translates to:
  /// **'Doctor Accounts'**
  String get doctorAccounts;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No Doctor Accounts Found'**
  String get noDoctorsFound;

  /// No description provided for @toogleAccountActivityPrompt.
  ///
  /// In en, this message translates to:
  /// **'Toggle Account Activity ? This May Disable This User\'s Ability To Log Into The System - Are You Sure ?'**
  String get toogleAccountActivityPrompt;

  /// No description provided for @editAccountName.
  ///
  /// In en, this message translates to:
  /// **'Edit Account Name'**
  String get editAccountName;

  /// No description provided for @openVisit.
  ///
  /// In en, this message translates to:
  /// **'Open Visit'**
  String get openVisit;

  /// No description provided for @needSuperAdminPermission.
  ///
  /// In en, this message translates to:
  /// **'Need \'SuperAdmin\' Permission'**
  String get needSuperAdminPermission;

  /// No description provided for @addNewDoctorAccount.
  ///
  /// In en, this message translates to:
  /// **'Add New Doctor Account'**
  String get addNewDoctorAccount;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'InActive'**
  String get inactive;

  /// No description provided for @clinicDoctors.
  ///
  /// In en, this message translates to:
  /// **'Clinic Doctors'**
  String get clinicDoctors;

  /// No description provided for @cannotRemoveSelfFromClinicWhileLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Cannot Remove Self From Clinic While LoggedIn'**
  String get cannotRemoveSelfFromClinicWhileLoggedIn;

  /// No description provided for @removeDoctorFromClinicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove Doctor Access To This Clinic ? Are You Sure ?'**
  String get removeDoctorFromClinicPrompt;

  /// No description provided for @toogleAccountActivity.
  ///
  /// In en, this message translates to:
  /// **'Toggle Account Activity'**
  String get toogleAccountActivity;

  /// No description provided for @cannotDeactivateSuperAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Cannot Deactivate \'SuperAdmin\' Account'**
  String get cannotDeactivateSuperAdminAccount;

  /// No description provided for @viewDocument.
  ///
  /// In en, this message translates to:
  /// **'View Document'**
  String get viewDocument;

  /// No description provided for @filterVisits.
  ///
  /// In en, this message translates to:
  /// **'Filter Visits'**
  String get filterVisits;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @operationsDetails.
  ///
  /// In en, this message translates to:
  /// **'Operations Details'**
  String get operationsDetails;

  /// No description provided for @operationTime.
  ///
  /// In en, this message translates to:
  /// **'Operation Time'**
  String get operationTime;

  /// No description provided for @duplicateVisitPrompt.
  ///
  /// In en, this message translates to:
  /// **'This Patient Has A Visit In The Same Clinic On The Same Date - Do You Wish To Proceed ?'**
  String get duplicateVisitPrompt;

  /// No description provided for @addFormBeforeEditing.
  ///
  /// In en, this message translates to:
  /// **'Kindly Add The Form Before Editing'**
  String get addFormBeforeEditing;

  /// No description provided for @notificationSound.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// No description provided for @pickNotificationSound.
  ///
  /// In en, this message translates to:
  /// **'Pick Notification Sound'**
  String get pickNotificationSound;

  /// No description provided for @appLogo.
  ///
  /// In en, this message translates to:
  /// **'App Logo'**
  String get appLogo;

  /// No description provided for @pickAppLogo.
  ///
  /// In en, this message translates to:
  /// **'Pick App Logo'**
  String get pickAppLogo;

  /// No description provided for @recieptSettings.
  ///
  /// In en, this message translates to:
  /// **'Reciept Settings'**
  String get recieptSettings;

  /// No description provided for @storedReciepts.
  ///
  /// In en, this message translates to:
  /// **'Stored Reciepts'**
  String get storedReciepts;

  /// No description provided for @addRecieptInfo.
  ///
  /// In en, this message translates to:
  /// **'Add Reciept Info'**
  String get addRecieptInfo;

  /// No description provided for @recieptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reciept Subtitle'**
  String get recieptSubtitle;

  /// No description provided for @recieptFooter.
  ///
  /// In en, this message translates to:
  /// **'Reciept Footer'**
  String get recieptFooter;

  /// No description provided for @recieptAddress.
  ///
  /// In en, this message translates to:
  /// **'Reciept Address'**
  String get recieptAddress;

  /// No description provided for @recieptPhone.
  ///
  /// In en, this message translates to:
  /// **'Reciept Phone'**
  String get recieptPhone;

  /// No description provided for @addNewRecieptInfo.
  ///
  /// In en, this message translates to:
  /// **'Add New Reciept Info'**
  String get addNewRecieptInfo;

  /// No description provided for @recieptTitle.
  ///
  /// In en, this message translates to:
  /// **'Reciept Title'**
  String get recieptTitle;

  /// No description provided for @enterRecieptTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Reciept Title'**
  String get enterRecieptTitle;

  /// No description provided for @enterValidTitleForReciept.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Title For The Reciept'**
  String get enterValidTitleForReciept;

  /// No description provided for @enterRecieptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Reciept Subtitle'**
  String get enterRecieptSubtitle;

  /// No description provided for @enterValidSubtitleForReciept.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Subtitle For The Reciept'**
  String get enterValidSubtitleForReciept;

  /// No description provided for @enterRecieptAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Reciept Address'**
  String get enterRecieptAddress;

  /// No description provided for @enterValidAddressForReciept.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Address For The Reciept'**
  String get enterValidAddressForReciept;

  /// No description provided for @enterRecieptFooter.
  ///
  /// In en, this message translates to:
  /// **'Enter Reciept Footer'**
  String get enterRecieptFooter;

  /// No description provided for @enterValidFooterForReciept.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Footer Text For The Reciept'**
  String get enterValidFooterForReciept;

  /// No description provided for @enterRecieptPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Reciept Phone Number'**
  String get enterRecieptPhone;

  /// No description provided for @enterValidPhoneForReciept.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Phone Number For The Reciept'**
  String get enterValidPhoneForReciept;

  /// No description provided for @noRecieptInfoFound.
  ///
  /// In en, this message translates to:
  /// **'No Selected Reciept Info Found On This Device'**
  String get noRecieptInfoFound;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

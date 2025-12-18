import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/model_url_ext.dart';
import 'package:one/models/app_constants/_app_constants.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/speciality.dart';
import 'package:one/models/user/user.dart';
import 'package:one/models/user/user_with_password.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_speciality.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddDoctorAccountDialog extends StatefulWidget {
  const AddDoctorAccountDialog({super.key});

  @override
  State<AddDoctorAccountDialog> createState() => _AddDoctorAccountDialogState();
}

class _AddDoctorAccountDialogState extends State<AddDoctorAccountDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _phoneController;

  final ValueNotifier<Speciality?> _speciality = ValueNotifier(null);
  final ValueNotifier<bool> _obscurePasswords = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _nameEnController = TextEditingController();
    _nameArController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAppConstants, PxLocale>(
      builder: (context, a, l, _) {
        while (a.constants == null) {
          return CentralLoading();
        }
        while (a.constants is ApiErrorResult) {
          final _err = a.constants as ApiErrorResult<AppConstants>;
          return CentralError(code: _err.errorCode, toExecute: a.retry);
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(context.loc.addNewDoctorAccount)),
              SizedBox(width: 10),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(context.loc.speciality),
                  ),
                  subtitle: Consumer<PxSpec>(
                    builder: (context, s, _) {
                      return ValueListenableBuilder(
                        valueListenable: _speciality,
                        builder: (context, value, child) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<Speciality>(
                              isExpanded: true,
                              hint: Text(context.loc.selectSpeciality),
                              alignment: Alignment.center,
                              items: s.specialities?.map((e) {
                                return DropdownMenuItem<Speciality>(
                                  alignment: Alignment.center,
                                  value: e,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      CachedNetworkImage(
                                        imageUrl: e.imageUrl,
                                        height: 50,
                                        width: 50,
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                              return CupertinoActivityIndicator();
                                            },
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          l.isEnglish ? e.name_en : e.name_ar,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (spec) {
                                _speciality.value = spec;
                              },
                              value: _speciality.value,
                              validator: (value) {
                                if (value == null) {
                                  return context.loc.selectSpeciality;
                                }
                                return null;
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(context.loc.englishName),
                  ),
                  subtitle: TextFormField(
                    controller: _nameEnController,
                    decoration: const InputDecoration(
                      hintText: 'Mohammed - Ali - Ahmed',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterEnglishName;
                      }
                      if (value.split(' ').length < 2) {
                        return context.loc.enterValidEnglishNameOfTwoUnits;
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(context.loc.arabicName),
                  ),
                  subtitle: TextFormField(
                    controller: _nameArController,
                    decoration: const InputDecoration(
                      hintText: 'محمد - على - احمد',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterArabicName;
                      }
                      if (value.split(' ').length < 2) {
                        return context.loc.enterValidArabicNameOfTwoUnits;
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(context.loc.phone),
                  ),
                  subtitle: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: '01##-####-###',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterPhoneNumber;
                      }
                      if (value.length != 11) {
                        return context.loc.enterValidPhoneNumber;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(context.loc.email),
                  ),
                  subtitle: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'example@domain.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterEmailAddress;
                      }
                      if (!EmailValidator.validate(value)) {
                        return context.loc.invalidEmailAddress;
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(context.loc.password),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            _obscurePasswords.value = !_obscurePasswords.value;
                          },
                          child: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ],
                    ),
                  ),
                  subtitle: ValueListenableBuilder(
                    valueListenable: _obscurePasswords,
                    builder: (context, value, child) {
                      return TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(hintText: '********'),
                        obscureText: value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.loc.enterPassword;
                          }
                          if (value.length < 8) {
                            return context.loc.passwordEightLetters;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(context.loc.confirmPassword),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            _obscurePasswords.value = !_obscurePasswords.value;
                          },
                          child: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ],
                    ),
                  ),
                  subtitle: ValueListenableBuilder(
                    valueListenable: _obscurePasswords,
                    builder: (context, value, child) {
                      return TextFormField(
                        controller: _passwordConfirmController,
                        decoration: const InputDecoration(hintText: '********'),
                        obscureText: _obscurePasswords.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.loc.enterConfirmPassword;
                          }
                          if (value != _passwordController.text) {
                            return context.loc.passwordsNotMatching;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final _user = User(
                    id: '',
                    email: _emailController.text,
                    name: _nameArController.text,
                    account_type: a.doctorAccountType,
                    app_permissions: [a.admin],
                    verified: false,
                    is_active: true,
                  );

                  final UserWithPassword _userWithPassword = UserWithPassword(
                    user: _user,
                    password: _passwordController.text,
                    confirmPassword: _passwordConfirmController.text,
                  );

                  final _doctor = Doctor(
                    id: '',
                    name_en: _nameEnController.text,
                    name_ar: _nameArController.text,
                    phone: _phoneController.text,
                    speciality: _speciality.value!,
                    email: _emailController.text,
                  );

                  final _data = UserWithPasswordAndDoctorAccount(
                    userWithPassword: _userWithPassword,
                    doctor: _doctor,
                  );

                  Navigator.pop(context, _data);
                }
              },
              label: Text(context.loc.confirm),
              icon: Icon(Icons.check, color: Colors.green.shade100),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}

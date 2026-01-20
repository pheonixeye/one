import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/_app_constants.dart';
import 'package:one/models/user/user.dart';
import 'package:one/models/user/user_with_password.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAssistantAccountDialog extends StatefulWidget {
  const AddAssistantAccountDialog({super.key});

  @override
  State<AddAssistantAccountDialog> createState() =>
      _AddAssistantAccountDialogState();
}

class _AddAssistantAccountDialogState extends State<AddAssistantAccountDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  bool _obscurePasswords = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxAppConstants>(
      builder: (context, a, _) {
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
              Expanded(child: Text(context.loc.addAssistantAccount)),
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
                    child: Text(context.loc.arabicName),
                  ),
                  subtitle: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'محمد احمد'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterArabicName;
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
                            setState(() {
                              _obscurePasswords = !_obscurePasswords;
                            });
                          },
                          child: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ],
                    ),
                  ),
                  subtitle: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: '********'),
                    obscureText: _obscurePasswords,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterPassword;
                      }
                      if (value.length < 8) {
                        return context.loc.passwordEightLetters;
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
                        Text(context.loc.confirmPassword),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _obscurePasswords = !_obscurePasswords;
                            });
                          },
                          child: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ],
                    ),
                  ),
                  subtitle: TextFormField(
                    controller: _passwordConfirmController,
                    decoration: const InputDecoration(hintText: '********'),
                    obscureText: _obscurePasswords,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc.enterConfirmPassword;
                      }
                      if (value != _passwordController.text) {
                        return context.loc.passwordsNotMatching;
                      }
                      return null;
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
                  final _account = User(
                    id: '',
                    email: _emailController.text,
                    name: _nameController.text,
                    org_id: '${context.read<PxAuth>().organization?.id}',
                    account_type: a.assistantAccountType,
                    app_permissions: [a.user],
                    verified: false,
                    is_active: true,
                  );

                  final UserWithPassword _data = UserWithPassword(
                    user: _account,
                    password: _passwordController.text,
                    confirmPassword: _passwordConfirmController.text,
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

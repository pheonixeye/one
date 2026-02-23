import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:one/core/api/home_form_api.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/homepage_models/form_submission_model.dart';

class FormContact extends StatefulWidget {
  const FormContact({super.key});

  @override
  State<FormContact> createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  //todo: RESPONSIVE

  final formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _resetState() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,

      ///contact form
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 850,
        ),
        child: Card.outlined(
          elevation: 6,
          color: Colors.amber.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      context.loc.contact,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(context.loc.plansToPowerBus),
                  ),
                  ListTile(
                    title: Text("${context.loc.fullName} *"),
                    subtitle: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterName;
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("${context.loc.email} *"),
                    subtitle: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || !EmailValidator.validate(value)) {
                          return context.loc.enterEmail;
                        }

                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("${context.loc.phone} *"),
                    subtitle: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterPhone;
                        }
                        if (value.length != 11) {
                          return context.loc.validatePhone;
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("${context.loc.helpYouWith} *"),
                    subtitle: SizedBox(
                      height: context.isMobile ? 150 : 200,
                      child: TextFormField(
                        controller: _messageController,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.loc.enterMessage;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.all(context.isMobile ? 8 : 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                //todo: submit form
                                final sub = FormSubmission(
                                  username: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  message: _messageController.text,
                                );
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await HomeFormApi().submitForm(sub);
                                    _resetState();
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                context.isMobile ? 16 : 24.0,
                              ),
                              child: Text(context.loc.contact),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

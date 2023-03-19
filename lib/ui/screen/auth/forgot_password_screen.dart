import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/auth_view.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "HerYer",
                            style: TextStyle(
                                fontSize: theme.textTheme.titleLarge!.fontSize,
                                color: theme.colorScheme.onPrimary,
                                fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: "Park",
                            style: TextStyle(
                                fontSize: theme.textTheme.titleLarge!.fontSize,
                                color: theme.colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          } else {
                            if (!value.contains("@") || !value.contains(".")) {
                              return "Please enter an email";
                            } else {
                              email = value;
                            }
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Email address",
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          prefixIcon: const Icon(
                            MdiIcons.emailOutline,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Consumer<AuthView>(
                        builder: (BuildContext context, value, Widget? child) {
                          if (value.authProcess == AuthProcess.idle) {
                            return Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await value
                                        .sendPasswordResetEmail(email)
                                        .then((result) {
                                      if (result is String) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "We sent an email to reset your password.",
                                            ),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  "Reset Password",
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

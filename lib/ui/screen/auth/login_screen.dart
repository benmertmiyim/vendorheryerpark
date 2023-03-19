
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/auth_view.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
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
                        textInputAction: TextInputAction.next,
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else {
                            password = value;
                          }
                          return null;
                        },
                        autofocus: false,
                        obscureText: _passwordVisible,
                        textInputAction: TextInputAction.done,

                        decoration: InputDecoration(

                          hintText: "Password",
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
                            MdiIcons.lockOutline,
                            size: 22,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            child: Icon(
                              _passwordVisible
                                  ? MdiIcons.eyeOutline
                                  : MdiIcons.eyeOffOutline,
                              size: 22,
                            ),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(0),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Consumer<AuthView>(
                        builder: (BuildContext context, value, Widget? child) {
                          if (value.authProcess == AuthProcess.idle) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await value
                                        .signInWithEmailAndPassword(
                                            email, password)
                                        .then((res) {
                                      if (res is String) {
                                        if(res == "vendorToCustomer"){
                                          //showDialog(
                                          //    context: context, builder: (BuildContext context) => VendorToCustomerWidget(email: email),);
                                        }else{
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(res,),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  "Login",
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
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password ?",
                          ),
                        ),
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

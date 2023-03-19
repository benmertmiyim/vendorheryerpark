import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/auth_view.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final formKey = GlobalKey<FormState>();
  String code = "";
  late AuthView authView;
  late CountdownTimerController controller;
  late int endTime;

  @override
  void initState() {
    startAgain();
    super.initState();
  }

  void startAgain(){
    endTime = DateTime.now().millisecondsSinceEpoch +
        const Duration(minutes: 2).inMilliseconds;
    controller =
        CountdownTimerController(endTime: endTime,);
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    authView = Provider.of<AuthView>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text("Phone Verification",),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                          text: authView.employee!.employeePhoneNumber,),
                    ],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(  "CODE: ${authView.messageCode}" ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: PinCodeTextField(
                  pinTheme: PinTheme(
                    activeColor: Theme.of(context).colorScheme.primary,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    inactiveColor: Theme.of(context).colorScheme.primary,

                  ),
                  appContext: context,
                  backgroundColor: Theme.of(context).backgroundColor,
                  length: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {},
                  validator: (String? value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "Please enter the code";
                    } else {
                      code = value;
                      return null;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            authView.authProcess == AuthProcess.idle ? SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await authView.verifyCode(code).then((value){
                      if(!value){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Verification failed",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    });
                  }
                },
                child: const Text(
                  "Verify",
                ),
              ),
            ): const Center(child: CircularProgressIndicator(),),
            const SizedBox(height: 8,),
            CountdownTimer(
              controller: controller,
              widgetBuilder: (_, CurrentRemainingTime? time) {
                if (time == null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the code? ",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () async {
                          startAgain();
                          await authView.sendCode(authView.employee!.employeePhoneNumber).then((value){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Code resent",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          });
                        },
                        child: const Text(
                          "Resend Code",
                        ),
                      ),
                    ],
                  );
                }
                return Text(
                    'You can send again code in ${time.min != null ? ("${time.min}:") : ""}${time.sec} seconds');
              },
            ),
          ],
        ),
      ),
    );
  }
}

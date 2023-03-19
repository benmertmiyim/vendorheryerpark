import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/ui/screen/auth/login_screen.dart';
import 'package:vendor/ui/screen/auth/phone_verification_screen.dart';
import 'package:vendor/ui/screen/main/main_screen.dart';
import 'package:vendor/ui/screen/main/vendor_selector/vendor_select.dart';
import 'package:vendor/ui/screen/splash/splash_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthView authView = Provider.of<AuthView>(context);

    if (authView.authState == AuthState.landing) {
      return const SplashScreen();
    } else {
      if (authView.authState == AuthState.unauthorized) {
        return const LoginScreen();
      } else if(authView.authState == AuthState.phone){
        return const PhoneVerificationScreen();
      } else{
        if(authView.employee!.vendors!.length == 1){
          if(authView.selectedVendor == null) {
            authView.changeVendor(authView.employee!.vendors![0].vendorId);
            return const SplashScreen();
          } else {
            return const MainScreen();
          }
        }else{
          if(authView.selectedVendor == null && authView.authProcess == AuthProcess.idle){
            return const VendorSelectScreen();
          }else{
            if(authView.selectedVendor == null && authView.authProcess == AuthProcess.busy){
              return const SplashScreen();
            }else{
              return const MainScreen();
            }
          }
        }
      }
    }
  }
}

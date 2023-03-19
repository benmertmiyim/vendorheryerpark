import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(),
            Column(
              children: [
                Text.rich(

                  TextSpan(children: [
                    TextSpan(
                      text: "HerYer",
                      style: TextStyle(
                        fontSize: 32,
                          color: theme.colorScheme.onBackground,
                          fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text: "Park",
                      style: TextStyle(
                          fontSize: 32,
                          color: theme.colorScheme.secondary,
                          fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                const CircularProgressIndicator(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Version ${packageInfo.version}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

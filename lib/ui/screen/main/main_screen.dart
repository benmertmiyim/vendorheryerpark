import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/ui/screen/main/dashboard_screen.dart';
import 'package:vendor/ui/screen/main/notification_screen.dart';
import 'package:vendor/ui/screen/main/other_screen.dart';
import 'package:vendor/ui/screen/main/scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ScannerScreen(),
    OtherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    AuthView authView = Provider.of<AuthView>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: "HerYer",
              style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: "Park",
              style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LineIcons.bell),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: authView.employee!.vendors!.length == 1 ? Container():  FloatingActionButton(
        onPressed: () {
          authView.selectedVendor = null;
          authView.clear();
        },
        child: const Icon(MdiIcons.selectionMultipleMarker),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GNav(
              gap: 8,
              iconSize: 24,
              activeColor: theme.colorScheme.onPrimary,
              tabBackgroundColor: theme.colorScheme.primary,
              color: theme.colorScheme.onBackground.withAlpha(220),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 300),
              tabs: [
                GButton(
                  icon: MdiIcons.viewDashboardOutline,
                  text: 'Home',
                ),
                GButton(
                  icon: MdiIcons.cameraOutline,
                  text: 'Scanner',
                ),
                GButton(
                  icon: MdiIcons.storeSettingsOutline,
                  text: 'Settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (i) {
                setState(() {
                  _selectedIndex = i;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

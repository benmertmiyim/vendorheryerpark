import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/model/enum.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/ui/screen/main/notification_screen.dart';

class VendorSelectScreen extends StatefulWidget {
  const VendorSelectScreen({Key? key}) : super(key: key);

  @override
  State<VendorSelectScreen> createState() => _VendorSelectScreenState();
}

class _VendorSelectScreenState extends State<VendorSelectScreen> {
  late AuthView authView;

  @override
  Widget build(BuildContext context) {
    authView = Provider.of<AuthView>(context);
    final ThemeData theme = Theme.of(context);

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
              key: Key('bell'),
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
          ]),
      body: authView.authProcess == AuthProcess.idle
          ? ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: authView.employee!.vendors!.length,
              itemBuilder: (c, i) {
                return ListTile(

                  title: Text(
                      authView.employee!.vendors![i].parkName),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Permission: ${permissionToString(authView.employee!.vendors![i].permission)}"),
                      Text(
                          "Adress: ${authView.employee!.vendors![i].address}"),
                    ],
                  ),
                  trailing: authView.employee!.vendors![i].active
                      ? const Icon(
                          MdiIcons.lockOpenOutline,
                          color: Colors.green,
                        )
                      : Icon(
                          MdiIcons.lockOutline,
                          color: Colors.red,
                        ),
                  onTap: () async {
                    await authView
                        .changeVendor(authView.employee!.vendors![i].vendorId);
                    authView.selectedVendor!.permission = authView.employee!.vendors![i].permission;
                  },
                );
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

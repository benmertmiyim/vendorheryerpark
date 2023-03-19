import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/ui/components/info_widget.dart';
import 'package:vendor/ui/screen/main/park_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late AuthView authView;


  @override
  Widget build(BuildContext context) {
    authView = Provider.of<AuthView>(context);

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Park Status",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                authView.authProcess == AuthProcess.idle
                    ? Switch(
                        value: authView.selectedVendor!.active,
                        onChanged: (bool value) {
                          authView.employee!.vendors!.where((element) => element.vendorId == authView.selectedVendor!.vendorId).first.active = value;
                          authView.changeStatus(!authView.selectedVendor!.active,authView.selectedVendor!.vendorId);
                        },
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          primary: false,
          crossAxisCount: 2,
          children: <Widget>[
            InfoWidget(
              color: Colors.blue,
              number: authView.todayParkCount.toString(),
              description: "Today Total Parks",
              page: ParkDetailScreen( query: '',),
            ),
            InfoWidget(
              color: Colors.green,
              number: authView.activePark.length.toStringAsFixed(0),
              description: "Active Parks",
              page: ParkDetailScreen( query: 'process',),
            ),
            InfoWidget(
              color: Colors.orange,
              number: authView.approvalPark.length.toStringAsFixed(0),
              description: "Awaiting Approval",
              page: ParkDetailScreen( query: 'approval',),
            ),
            InfoWidget(
              color: Colors.red,
              number: authView.todayDeniedPark.length.toStringAsFixed(0),
              description: "Today Rejected Parks",
              page: ParkDetailScreen( query: 'denied',),
            ),
            InfoWidget(
              color: Colors.yellow,
              number: "${authView.todayEarnings.toStringAsFixed(0)} ₺",
              description: "Today's Earnings",
              page: ParkDetailScreen( query: '',),
            ),
          ],
        ),
      ],
    );
  }
}

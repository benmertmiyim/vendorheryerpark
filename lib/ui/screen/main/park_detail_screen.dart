import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/model/enum.dart';
import 'package:vendor/core/model/park_history_model.dart';
import 'package:vendor/core/service/auth_service.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParkDetailScreen extends StatelessWidget {
  final String query;

  const ParkDetailScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthView authView = Provider.of<AuthView>(context);

    return Scaffold(
      appBar: AppBar(
        title:Text(AppLocalizations.of(context).park_detail_screen_detail),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: AuthService()
              .getParkHistory(authView.selectedVendor!.vendorId, query),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<ParkHistory> parks = snapshot.data as List<ParkHistory>;
              if(parks.isNotEmpty){
                return ListView.builder(
                  itemCount: parks.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      title: Text(parks[i].customerName),
                      subtitle: Text(DateFormat('dd MMM yy - kk:mm')
                          .format(parks[i].requestTime),),
                      trailing: parks[i].status == StatusEnum.completed ? Text("${parks[i].totalPrice!.toStringAsFixed(2)}₺"):Text(""),
                    );
                  },
                );
              }else{
                return Center(
                  child: Text(AppLocalizations.of(context).notification_screen_no_notifications),
                );
              }
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }

          }),
    );
  }
}
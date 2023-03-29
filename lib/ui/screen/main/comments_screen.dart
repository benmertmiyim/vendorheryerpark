import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/model/comment_model.dart';
import 'package:vendor/core/service/auth_service.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/ui/components/comments_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthView authView = Provider.of<AuthView>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).comments_screen_ratings),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: AuthService().getComments(authView.selectedVendor!.vendorId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<RateModel> rates = snapshot.data as List<RateModel>;
              if(rates.isNotEmpty){
                return ListView.builder(
                  itemCount: rates.length,
                  itemBuilder: (context, i){
                    return CommentWidget(rateModel: rates[i],);
                  },
                );
              }else{
                return Center(
                  child: Text(AppLocalizations.of(context).comments_screen_no_rates),
                );
              }
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}

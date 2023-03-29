import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/model/enum.dart';
import 'package:vendor/core/service/auth_service.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/extensions/phone_extension.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/components/tile_widget.dart';
import 'package:vendor/ui/screen/main/comments_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({Key? key}) : super(key: key);

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  String openHour = "";
  String closeHour = "";
  final openKey = GlobalKey<FormState>();
  final closeKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthView authView = Provider.of<AuthView>(context);
    openHour = authView.selectedVendor!.openTime;
    closeHour = authView.selectedVendor!.closeTime;

    if (authView.authProcess == AuthProcess.idle) {
      if (authView.selectedVendor != null) {
        return ListView(
          children: [
            Column(
              children: [
                TileWidget(
                  subTitle: authView.selectedVendor!.parkName,
                  title: AppLocalizations.of(context).other_screen_park_name,
                ),
                TileWidget(
                  subTitle: authView.selectedVendor!.address,
                  title: AppLocalizations.of(context).other_screen_park_address,
                ),
                TileWidget(
                  subTitle: authView.employee!.employeeNameSurname,
                  title: AppLocalizations.of(context).other_screen_employee_name,
                ),
                TileWidget(
                  subTitle: authView.employee!.employeeEmail,
                  title: AppLocalizations.of(context).other_screen_employee_email,
                ),
                TileWidget(
                  subTitle:
                  permissionToString(authView.selectedVendor!.permission!),
                  title: AppLocalizations.of(context).other_screen_employee_permission,
                ),
                TileWidget(
                  subTitle: authView.employee!.employeePhoneNumber,
                  title: AppLocalizations.of(context).other_screen_employee_phone,
                ),
                TileWidget(
                  subTitle: authView.selectedVendor!.vendorId,
                  title: AppLocalizations.of(context).other_screen_vendor_id,
                ),
                TileWidget(
                  subTitle: authView.selectedVendor!.rating.toStringAsFixed(2),
                  title: AppLocalizations.of(context).other_screen_total_rating,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TileWidget(
                        subTitle: openHour,
                        title: AppLocalizations.of(context).other_screen_open_time,
                        onClick: authView.selectedVendor!.permission == PermissionEnum.owner ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Form(
                                      key: openKey,
                                      child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.length < 5) {
                                              return AppLocalizations.of(context).other_screen_please_enter_hour;
                                            } else {
                                              openHour = value;
                                            }
                                            return null;
                                          },
                                          controller: MaskedTextController(
                                              mask: '--:--'),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            hintText: "00:00",
                                            label: Text(AppLocalizations.of(context).other_screen_hour),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                borderSide: BorderSide.none),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                borderSide: BorderSide.none),
                                            filled: true,
                                            prefixIcon: Icon(
                                              MdiIcons.hours24,
                                              size: 22,
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                          )),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (openKey.currentState!
                                              .validate()) {
                                            AuthService()
                                                .setOpenHour(
                                                openHour,
                                                authView.selectedVendor!
                                                    .vendorId)
                                                .then((res) {
                                              authView.selectedVendor!
                                                  .openTime = openHour;
                                              authView.authProcess =
                                                  AuthProcess.idle;
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(context).other_screen_okay,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } : (){},
                      ),
                    ),
                    Expanded(
                      child: TileWidget(
                          subTitle: closeHour,
                          title: AppLocalizations.of(context).other_screen_close_time,
                          onClick: authView.selectedVendor!.permission ==
                              PermissionEnum.owner
                              ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Form(
                                        key: closeKey,
                                        child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 5) {
                                                return AppLocalizations.of(context).other_screen_please_enter_hour;
                                              } else {
                                                closeHour = value;
                                              }
                                              return null;
                                            },
                                            controller:
                                            MaskedTextController(
                                                mask: '--:--'),
                                            keyboardType:
                                            TextInputType.number,
                                            textInputAction:
                                            TextInputAction.done,
                                            decoration:
                                            InputDecoration(
                                              hintText: "00:00",
                                              label: Text(AppLocalizations.of(context).other_screen_hour),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  ),
                                                  borderSide:
                                                  BorderSide.none),
                                              enabledBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .all(
                                                    Radius.circular(
                                                        8.0),
                                                  ),
                                                  borderSide:
                                                  BorderSide
                                                      .none),
                                              focusedBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .all(
                                                    Radius.circular(
                                                        8.0),
                                                  ),
                                                  borderSide:
                                                  BorderSide
                                                      .none),
                                              filled: true,
                                              prefixIcon: Icon(
                                                MdiIcons.hours24,
                                                size: 22,
                                              ),
                                              isDense: true,
                                              contentPadding:
                                              EdgeInsets.all(0),
                                            )),
                                      ),
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (closeKey.currentState!
                                                .validate()) {
                                              AuthService()
                                                  .setCloseHour(
                                                  closeHour,
                                                  authView
                                                      .selectedVendor!
                                                      .vendorId)
                                                  .then((res) {
                                                authView.selectedVendor!
                                                    .closeTime =
                                                    closeHour;
                                                authView.authProcess =
                                                    AuthProcess.idle;
                                                Navigator.of(context)
                                                    .pop();
                                              });
                                            }
                                          },
                                          child: Text(
                                            AppLocalizations.of(context).other_screen_okay,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                              : () {}),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TileWidget(
                        subTitle: authView.selectedVendor!.security
                            .toStringAsFixed(2),
                        title: AppLocalizations.of(context).other_screen_security,
                      ),
                    ),
                    Expanded(
                      child: TileWidget(
                        subTitle: authView.selectedVendor!.accessibility
                            .toStringAsFixed(2),
                        title: AppLocalizations.of(context).other_screen_accessibility,
                      ),
                    ),
                    Expanded(
                      child: TileWidget(
                        subTitle: authView.selectedVendor!.serviceQuality
                            .toStringAsFixed(2),
                        title: AppLocalizations.of(context).other_screen_service,
                      ),
                    ),
                  ],
                ),
                TileWidget(
                  subTitle:
                  "${authView.selectedVendor!.latitude} - ${authView.selectedVendor!.longitude}",
                  title: AppLocalizations.of(context).other_screen_location,
                ),
                authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                  subTitle: authView.selectedVendor!.iban,
                  title: "IBAN",
                )
                    : Container(),
                authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                  subTitle: authView.selectedVendor!.vkn,
                  title: "VKN",
                )
                    : Container(),
                /*authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                        title: "Image List",
                        onClick: () {
                          /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletHistoryScreen(),
                      ),
                    );*/
                        },
                      )
                    : Container(),*/
                authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                  title: AppLocalizations.of(context).other_screen_price_list,
                  onClick: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PriceScreen(),
                      ),
                    );*/
                  },
                )
                    : Container(),
                TileWidget(
                  title: AppLocalizations.of(context).other_screen_comments,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommentsScreen(),
                      ),
                    );
                  },
                ),
                /*authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                        title: "Wallet History",
                        onClick: () {
                          /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletHistoryScreen(),
                      ),
                    );*/
                        },
                      )
                    : Container(),*/
                authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                  title: AppLocalizations.of(context).other_screen_employee_list,
                  onClick: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletHistoryScreen(),
                      ),
                    );*/
                  },
                )
                    : Container(),
                TileWidget(
                  title: AppLocalizations.of(context).other_screen_support,
                  subTitle: "+850 123 12 12",
                ),
                TileWidget(
                  title: AppLocalizations.of(context).other_screen_logout,
                  onClick: () async {
                    Navigator.pop(context);
                    await authView.signOut().then((value) {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const MyApp(),
                        ),
                            (_) => true,
                      );
                    });
                  },
                  isLogout: true,
                ),
              ],
            ),
          ],
        );
      } else {
        return Text(AppLocalizations.of(context).other_screen_no_data);
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
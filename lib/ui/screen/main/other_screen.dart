import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/model/enum.dart';
import 'package:vendor/core/service/auth_service.dart';
import 'package:vendor/core/view/auth_view.dart';
import 'package:vendor/core/view/notification_view.dart';
import 'package:vendor/extensions/phone_extension.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/components/tile_widget.dart';
import 'package:vendor/ui/screen/main/comments_screen.dart';

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
                  title: "Park Name",
                ),
                TileWidget(
                  subTitle: authView.selectedVendor!.address,
                  title: "Park Address",
                ),
                TileWidget(
                  subTitle: authView.employee!.employeeNameSurname,
                  title: "Employee Name",
                ),
                TileWidget(
                  subTitle: authView.employee!.employeeEmail,
                  title: "Employee Email",
                ),
                TileWidget(
                  subTitle:
                      permissionToString(authView.selectedVendor!.permission!),
                  title: "Employee Permission",
                ),
                TileWidget(
                  subTitle: authView.employee!.employeePhoneNumber,
                  title: "Employee Phone",
                ),
                TileWidget(
                  subTitle: authView.selectedVendor!.vendorId,
                  title: "Vendor ID",
                ),
                TileWidget(
                  subTitle: authView.selectedVendor!.rating.toStringAsFixed(2),
                  title: "Total Rating",
                ),
                Row(
                  children: [
                    Expanded(
                      child: TileWidget(
                        subTitle: openHour,
                        title: "Open Time",
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
                                              return 'Please enter hour';
                                            } else {
                                              openHour = value;
                                            }
                                            return null;
                                          },
                                          controller: MaskedTextController(
                                              mask: '--:--'),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                            hintText: "00:00",
                                            label: Text("Hour"),
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
                                        child: const Text(
                                          "Okey",
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
                          title: "Close Time",
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
                                                      return 'Please enter hour';
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
                                                      const InputDecoration(
                                                    hintText: "00:00",
                                                    label: Text("Hour"),
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
                                                child: const Text(
                                                  "Okey",
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
                        title: "Security",
                      ),
                    ),
                    Expanded(
                      child: TileWidget(
                        subTitle: authView.selectedVendor!.accessibility
                            .toStringAsFixed(2),
                        title: "Accessibility",
                      ),
                    ),
                    Expanded(
                      child: TileWidget(
                        subTitle: authView.selectedVendor!.serviceQuality
                            .toStringAsFixed(2),
                        title: "Service",
                      ),
                    ),
                  ],
                ),
                TileWidget(
                  subTitle:
                      "${authView.selectedVendor!.latitude} - ${authView.selectedVendor!.longitude}",
                  title: "Location",
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
                authView.selectedVendor!.permission == PermissionEnum.owner
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
                    : Container(),
                authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                        title: "Price List",
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
                  title: "Comments",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommentsScreen(),
                      ),
                    );
                  },
                ),
                authView.selectedVendor!.permission == PermissionEnum.owner
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
                    : Container(),
                authView.selectedVendor!.permission == PermissionEnum.owner
                    ? TileWidget(
                        title: "Employee List",
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
                const TileWidget(
                  title: "Support",
                  subTitle: "+850 123 12 12",
                ),
                TileWidget(
                  title: "Logout",
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
        return const Text("No Data");
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

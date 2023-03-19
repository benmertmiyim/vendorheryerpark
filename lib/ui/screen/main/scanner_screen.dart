import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vendor/core/view/auth_view.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AuthView authView;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }


  @override
  Widget build(BuildContext context) {
    authView = Provider.of<AuthView>(context);

    var scanArea = MediaQuery.of(context).size.width / 2;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea,
          ),
        ),
        Center(
          child: authView.authProcess == AuthProcess.busy
              ? Wrap(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Processing...")
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.pauseCamera();
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        controller.pauseCamera();
      });

      await authView
          .sendRequest(authView.selectedVendor!.vendorId, scanData.code!)
          .then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child:
                        Text(value.toString(),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              controller.resumeCamera();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Okey",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });


    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:integration_test/integration_test.dart';


import 'package:vendor/main.dart' as app;
import 'package:line_icons/line_icon.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vendor/ui/components/tile_widget.dart';

void main() {


  group(' Group of Vendor Integration Tests ', () {

    testWidgets('-Integration Test Loading-', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpWidget(app.MyApp());


//LOGIN
      await tester.enterText(find.byKey(Key('email')), 'heryerpark@izelman.com.tr');
      await tester.enterText(find.byKey(Key('password')), '123456');
      await Future.delayed(Duration(seconds: 1)); // 1 sec delayed
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('enter')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('bell')));
      await tester.pumpAndSettle();

//CHOOSE PARKING LOTS
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pump();
      await Future.delayed(Duration(seconds: 1)); // 1 sec delayed
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 1));
      final firstListTile = find.byType(ListTile).first;
      await tester.tap(firstListTile);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 1));

//ACTIVE PARKS
      await tester.tap(find.byKey(Key('active')));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 1));
      final NavigatorState navigator1 = tester.state(find.byType(Navigator));
      await Future.delayed(Duration(seconds: 1));
      navigator1.pop();
      await Future.delayed(Duration(seconds: 1));
      await tester.pump();
      await Future.delayed(Duration(seconds: 2));
 //AWAITING

      await tester.tap(find.byKey(Key('awaiting')));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      final NavigatorState navigator2 = tester.state(find.byType(Navigator));
      await Future.delayed(Duration(seconds: 2));
      navigator2.pop();
      await Future.delayed(Duration(seconds: 2));
      await tester.pump();
      await Future.delayed(Duration(seconds: 2));

//REJECTED PARKING LOTS
      await tester.tap(find.byKey(Key('Rejected')));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 1));
      final NavigatorState navigator3 = tester.state(find.byType(Navigator));
      navigator3.pop();
      await Future.delayed(Duration(seconds: 1));
      await tester.pump();

//EARNINGS- HATALI EKRAN

     /* await tester.tap(find.byKey(Key('Earnings')));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 1));
      final NavigatorState navigator4 = tester.state(find.byType(Navigator));
      navigator4.pop();
      await Future.delayed(Duration(seconds: 1));
      await tester.pump();


      */


//SCANNER PAGE
      await tester.tap(find.byKey(Key('Scanner')));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.pump();



//PROFILE-SETTINGS PAGE
      await tester.tap(find.byKey(Key('Settings')));
      await tester.pumpAndSettle();



//OPEN TIME
      final listTile2 = find.byKey(Key('time'));
      expect(listTile2, findsOneWidget);
      await tester.tap(find.byKey(Key('time')));
      await tester.pump();



//HOURLY PRICE

      final hourlyField = find.byKey(Key("hourly"));
      await tester.tap(hourlyField);
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(hourlyField, "10:15");
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(find.text("Okey"));
      await tester.pump();



//RETURN HOME











      //CLOSE TIME

      /*final listTile3 = find.text("Close Time");
      expect(listTile3, findsOneWidget);
      await tester.tap(find.text('Close Time'));
      await tester.pump();
      final hourlyField1 = find.byKey(Key("hourly2"));
      await tester.tap(hourlyField1);
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(hourlyField1, "23:10");
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(find.text("Okey"));
      await tester.pump();



       */










    });

  });

}
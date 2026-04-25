import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:library_book/models/users.dart';
import 'package:library_book/screens/landing.dart';
import 'package:library_book/services/apis/admin.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/firebase_options.dart';
import 'credentials/login.dart';
import 'models/converter.dart';
import 'models/admin.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Management',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en', 'EN'),
      supportedLocales: [
        Locale('en', 'EN'),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AdminApis _adminApis = new AdminApis();
  final Routes _routes = new Routes();

  @override
  void initState() {
    // TODO: implement initState
    _adminApis.get().whenComplete(()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Future.delayed(Duration(seconds: 5), ()async {
        List _admin = adminModel.value.where((s) => s["email"] == prefs.getString('email') && converterModels.hexToString(s["pass"]) == prefs.getString('pass')).toList();
        if(_admin.isNotEmpty){
          usersModel.updateUser(data: _admin.first);
          _routes.navigator_pushreplacement(context, Landing());
        }else{
          _routes.navigator_pushreplacement(context, Login());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: 150,
              width: 150,
              image: AssetImage("assets/logos/ssu_logo.png"),
            ),
            Text("We innovate, We build, We serve",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(color:  colors.umber,)
          ],
        ),
      ),
    );
  }
}

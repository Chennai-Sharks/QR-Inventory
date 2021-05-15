import 'package:app/Utils/Utils.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/screens/auth_screen.dart';
import 'package:app/screens/loading_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:app/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

late FirebaseAnalytics firebaseAnalytics;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseAnalytics = FirebaseAnalytics();
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      builder: (context, child) {
        return Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
            title: 'No Name',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: TextTheme(
                bodyText1: TextStyle(),
                bodyText2: TextStyle(),
              ).apply(
                bodyColor: Utils.primaryFontColor,
                displayColor: Colors.blue,
              ),
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting ? LoadingScreen() : AuthScreen(),
                  ),
          ),
        );
      },
    );
  }
}

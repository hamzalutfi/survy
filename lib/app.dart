import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/features/splash.dart';

import 'utils/constants/colors.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "PTSansNarrow",
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: primaryColor,
          ),

          // primarySwatch: Colors.amber
          primarySwatch: const MaterialColor(
            0xffF49F1C,
            <int, Color>{
              50: primaryColor,
              100: primaryColor,
              200: primaryColor,
              300: primaryColor,
              400: primaryColor,
              500: primaryColor,
              600: primaryColor,
              700: primaryColor,
              800: primaryColor,
              900: primaryColor,
            },
          )),
      title: 'Wego',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: SplashPage(key: widget.key),
    );
  }
}

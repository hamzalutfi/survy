import 'package:flutter/material.dart';

enum ViewMode {edit, create}

class EndPoints {
  static String BASE_URL = "https://holol.online";

  static String SUBMIT_VERIFICATION = "/api/store";
}

Future<void> logoutDialog(
    BuildContext context, Function onSubmit) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Logout',
            style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w200),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onSubmit();
                }),
          ],
        );
      });
}

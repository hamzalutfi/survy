import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/features/auth/pages/login_screen.dart';
import 'package:wego/features/select_user_type.dart';
import 'package:wego/features/verify_account/verify_account_page.dart';
import 'package:wego/utils/constants/colors.dart';
import 'package:wego/utils/constants/shared_keys.dart';
import 'package:wego/utils/widgets/background_widget.dart';

import '../entities/user_entity.dart';
import 'auth/pages/register_screen.dart';
import 'main_page/main_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late dynamic sharedPreferences;

  initializeShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    checkingUserStatus();
    initializeShared();
  }

  checkingUserStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500))
        .then((value) async {
      /// TODO (checking user logged in or not and move the user to the correct flow.

      bool? isLoggedIn =
          await sharedPreferences.getBool(SharedKeys.IS_LOGGED_IN);
      if (isLoggedIn == null) {
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SelectUserTypePage()),
            (route) => false);*/
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen(0)),
                (route) => false);
      } else {
        String? servicesSP =
            await sharedPreferences.getString(SharedKeys.SERVICES_TYPE);
        List<String> services = [];
        if (servicesSP != null) {
          services = SharedKeys.decode(servicesSP);
        }
        String? locationsSP =
            await sharedPreferences.getString(SharedKeys.LOCATIONS);
        List<String> locations = [];
        if (locationsSP != null) {
          locations = SharedKeys.decode(locationsSP);
        }
        UserEntity currentUser = UserEntity(
          token: await sharedPreferences.getString(SharedKeys.UID),
          firstName: await sharedPreferences.getString(SharedKeys.FIRST_NAME),
          lastName: await sharedPreferences.getString(SharedKeys.LAST_NAME),
          email: await sharedPreferences.getString(SharedKeys.EMAIL),
          accountStatus:
              await sharedPreferences.getString(SharedKeys.ACCOUNT_STATUS),
          type: await sharedPreferences.getInt(SharedKeys.TYPE),
          servicesType: services,
          locations: locations,
          profileURL: await sharedPreferences.getString(SharedKeys.ACCOUNT_STATUS),
        );

        print("---> currentUser = ${currentUser.toString()}");

        getUserStatus(currentUser.email).then((value) {
          if (value != null) {
            currentUser.accountStatus = value['accountStatus'];
            if (value['accountStatus'] == "unverified" ||
                value['accountStatus'] == "rejected" ||
                value['accountStatus'] == "pending") {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyAccountPage(currentUser)),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(currentUser)),
                  (route) => false);
            }
          } else {
            print("--> null");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Center(
              child: Hero(
            tag: 'splash_tag',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.5,
                //   height: MediaQuery.of(context).size.width * 0.5,
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //           image:
                //               AssetImage('assets/images/icons/service.png'))),
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                Text(
                  "SERVY",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "WELCOME",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Future getUserStatus(email) async {
    print("----> email = $email");
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var item in allData) {
      if (item['email'] == email) {
        return item;
      }
    }
  }
}

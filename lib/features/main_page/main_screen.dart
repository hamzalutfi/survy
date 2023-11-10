import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/auth/pages/login_screen.dart';
import 'package:wego/features/main_page/widgets/main_offer_widget.dart';
import 'package:wego/features/messanger/stuff/messanger_services.dart';
import 'package:wego/features/profile/pages/profile_screen.dart';
import 'package:wego/features/my_offers/my_offers_page.dart';
import 'package:wego/features/search_about_service/pages/searching_service_screen.dart';
import 'package:wego/features/select_user_type.dart';
import 'package:wego/utils/mixin/flush_bar_mixin.dart';
import 'package:wego/utils/widgets/background_widget.dart';
import '../../colors.dart';
import '../../utils/constants/shared_keys.dart';
import '../../utils/services/get_profile_photo.dart';
import '../messanger/pages/massenger_screen.dart';
import '../messanger/pages/messages_screen.dart';
import '../verify_account/verify_account_page.dart';

class MainScreen extends StatefulWidget {
  UserEntity currentUser;

  MainScreen(this.currentUser);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver, FlushBarMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late dynamic sharedPreferences;
  MessengerServices messengerServices = MessengerServices();
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Users');
  late StreamSubscription<QuerySnapshot>? _eventsSubscription;

  initializeShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("currentUser = ${widget.currentUser.type}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeShared();
    _handleAccountStatus();
  }

  _handleAccountStatus() {
    _eventsSubscription = _collectionRef.snapshots().listen((snapshot) {
      snapshot.docs.forEach((change) {
        print("Main = chageggege");
        if (change['email'] == widget.currentUser.email) {
          if (change['accountStatus'] == "unverified" ||
              change['accountStatus'] == "rejected") {
            sharedPreferences.setString(
                SharedKeys.ACCOUNT_STATUS, change['accountStatus']);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VerifyAccountPage(widget.currentUser)),
                (route) => false);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventsSubscription?.cancel();
  }

  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isBg = state == AppLifecycleState.paused;
    final isClosed = state == AppLifecycleState.detached;
    final isScreen = state == AppLifecycleState.resumed;

    isBg || isScreen == true || isClosed == false
        ? setState(() {
            // SET ONLINE
            print("ONLINE");
          })
        : setState(() {
            //SET  OFFLINE
            print("OFFLINE");
          });
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: getMainDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
        ),
      ),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Column(
            children: [
              Column(
                children: [
                  widget.currentUser.accountStatus == "unverified"
                      ? Container(
                          height: 35,
                          width: width,
                          color: getTypeColor(widget.currentUser.type),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.white, size: 18),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "You didn't verify your account!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "verify",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    child: Row(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              height: height * 0.1,
                              width: width * 0.1,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightColor,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.menu,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                'Mr.${widget.currentUser.firstName.toUpperCase()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 28, color: lightColor),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Current status:',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: lightColor,
                                    fontFamily: "PTSansNarrow"),
                                children: [
                                  TextSpan(
                                      text: ' online',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontFamily: "PTSansNarrow")),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: getTypeColor(widget.currentUser.type),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      bottom: 2.0,
                                      right: 6.0,
                                      left: 6.0),
                                  child: Text(
                                      getTypeString(widget.currentUser.type),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MessengerScreen(widget.currentUser)));
                          },
                          child: Image.asset(
                            'assets/images/icons/chat (1).png',
                            height: height * 0.07,
                            width: width * 0.07,
                          ),
                        ),
                      ],
                    ),
                  ),
                  (widget.currentUser != null && widget.currentUser.type != 0)
                      ? InkWell(
                          child: Container(
                            width: width,
                            height: height * 0.07,
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'What\'s on your mind?',
                                    style: TextStyle(
                                      color: Colors.white38,
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    'assets/images/icons/right-arrows.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchingServiceScreen(widget.currentUser),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("public_offers")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    var items = snapshot.data == null
                        ? []
                        : snapshot.data!.docs
                            .where((element) => !element.id
                                .toString()
                                .startsWith(widget.currentUser.token))
                            .toList();
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()),
                      );
                    } else if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          "No offers found!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(
                              future: ProfilePhotoService.getUserPhoto(items[index]['email']),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return MainOfferWidget(
                                  items[index],
                                  isLoadingPhoto: !snapshot.hasData,
                                  profileURL: snapshot.data == null
                                      ? ""
                                      : snapshot.data,
                                  onChatTapped: () async {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => MessengerScreen(
                                    //             widget.currentUser)));

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MessagesScreen(
                                                  currentUser:
                                                      widget.currentUser,
                                                  entryPoint:
                                                      EntryPoint.externalPoint,
                                                  email: items[index]['email'],
                                                )));
                                  },
                                );
                              },
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getMainDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              "SERVY APP",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(color: Colors.grey),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            title: Text("Offers",
                style: TextStyle(color: primaryColor, fontSize: 20)),
            trailing: Icon(Icons.offline_bolt, color: primaryColor),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyOffersPage(widget.currentUser)));
            },
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile",
                    style: TextStyle(color: primaryColor, fontSize: 20)),
                widget.currentUser.locations.isEmpty
                    ? const Text(
                        "Add your supported locations to appear in results!",
                        style: TextStyle(color: Colors.red, fontSize: 12))
                    : Container(),
              ],
            ),
            trailing: Icon(Icons.person, color: primaryColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(widget.currentUser),
                ),
              ).then((value) {
                if (value != null && (value as Map)['update'] != null) {
                  setState(() {
                    widget.currentUser = value['update'];
                  });
                }
              });
              print("");
            },
          ),
          ListTile(
            title: const Text("Logout",
                style: TextStyle(color: Colors.red, fontSize: 20)),
            trailing: const Icon(Icons.power_settings_new, color: Colors.red),
            onTap: () {
              sharedPreferences.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(0)),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Color getTypeColor(int type) {
    switch (type) {
      case 0:
        return Colors.blue;
      case 1:
        return primaryColor;
      default:
        return Colors.purple;
    }
  }

  String getTypeString(int type) {
    switch (type) {
      case 0:
        return "Service Consumer";
      case 1:
        return "Service Producer";
      default:
        return "Both";
    }
  }
}

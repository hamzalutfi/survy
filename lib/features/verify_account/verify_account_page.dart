import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/verify_account/pick_image_sheet.dart';
import 'package:wego/utils/constants/colors.dart';
import 'package:wego/utils/constants/constants.dart';
import 'package:wego/utils/widgets/background_widget.dart';
import '../../utils/constants/shared_keys.dart';
import '../../utils/mixin/flush_bar_mixin.dart';
import '../../utils/widgets/dashed_widget.dart';
import '../main_page/main_screen.dart';
import '../select_user_type.dart';

class VerifyAccountPage extends StatefulWidget {
  final UserEntity userEntity;

  VerifyAccountPage(this.userEntity);

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage>
    with FlushBarMixin {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Users');
  late StreamSubscription<QuerySnapshot>? _eventsSubscription;

  File? frontIdFile;
  File? backIdFile;
  File? profileImage;
  late dynamic sharedPreferences;

  bool errorFront = false;
  bool errorBack = false;
  bool errorProfile = false;

  late Dio dio;

  bool isVerifying = false;

  late Reference ref;

  @override
  void initState() {
    super.initState();
    ref = FirebaseStorage.instance.ref().child("/profiles").child(
        "/${widget.userEntity.email}/profile_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().toString()}");
    dio = Dio(
      BaseOptions(
        connectTimeout: Duration(milliseconds: 75000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.plain,
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        responseHeader: true,
        requestHeader: true,
        request: true,
      ),
    );
    initializeShared();
    _handleAccountStatus();
  }

  initializeShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _handleAccountStatus() {
    _eventsSubscription = _collectionRef.snapshots().listen((snapshot) {
      snapshot.docs.forEach((change) {
        print("---> change = ${change.toString()}");
        if (change['email'] == widget.userEntity.email) {
          if (change['accountStatus'] == "verified") {
            print("---> change = ${change['accountStatus']}");
            widget.userEntity.accountStatus = "verified";
            sharedPreferences.setString(
                SharedKeys.ACCOUNT_STATUS, change['accountStatus']);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(widget.userEntity)),
                (route) => false);
            doneFlushBar(
                backgroundColor: primaryColor,
                context: context,
                duration: Duration(seconds: 2),
                onChangeStatus: (status) {},
                onHidden: () {},
                title: 'Verified!',
                message: 'Congratulations, your account has been verified.');
          } else {
            setState(() {
              widget.userEntity.accountStatus = change['accountStatus'];
            });
          }
        }
      });
    });
    // _collectionRef.snapshots().listen((querySnapshot) {
    //   querySnapshot.docs.forEach((change) {
    //     if (change['email'] == widget.userEntity.email) {
    //       if (change['accountStatus'] == "verified") {
    //         widget.userEntity.accountStatus = "verified";
    //         sharedPreferences.setString(
    //             SharedKeys.ACCOUNT_STATUS, change['accountStatus']);
    //         Navigator.pushAndRemoveUntil(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => MainScreen(widget.userEntity)),
    //             (route) => false);
    //         doneFlushBar(
    //             backgroundColor: primaryColor,
    //             context: context,
    //             duration: Duration(seconds: 2),
    //             onChangeStatus: (status) {},
    //             onHidden: () {},
    //             title: 'Verified!',
    //             message: 'Congratulations, your account has been verified.');
    //       } else {
    //         setState(() {
    //           widget.userEntity.accountStatus = change['accountStatus'];
    //         });
    //       }
    //     }
    //   });
    // });
    if (widget.userEntity.accountStatus == "pending") {}
  }

  @override
  void dispose() {
    super.dispose();
    _eventsSubscription?.cancel();
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
          SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                widget.userEntity.accountStatus == "rejected"
                    ? Container(
                        // height: 35,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.white, size: 18),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "Your verification request has been rejected, please re-verify your account!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 20.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Text(
                                  "VERIFY ACCOUNT",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Text(
                                  "${widget.userEntity.email}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                          widget.userEntity.accountStatus.toLowerCase() ==
                                  "pending"
                              ? Container(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                )
                              : Container()
                        ],
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      widget.userEntity.accountStatus == "pending"
                          ? pendingWidget()
                          : Column(
                              children: [
                                getIdImagePickerWidget(
                                    isBackId: false,
                                    onPressed: () {
                                      _showSheetModalWidget(type: "front");
                                    }),
                                SizedBox(
                                  height: 16.0,
                                ),
                                getIdImagePickerWidget(
                                    isBackId: true,
                                    onPressed: () {
                                      _showSheetModalWidget(type: "back");
                                    }),
                                SizedBox(
                                  height: 16.0,
                                ),
                                getProfileImagePickerWidget(),
                                SizedBox(
                                  height: 25.0,
                                ),
                              ],
                            ),
                      verifyButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pendingWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/stopwatch.png',
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.5),
          SizedBox(
            height: 16,
          ),
          Text(
              "The account in review section, it will be verified in 48 hours!",
              style: TextStyle(color: primaryColor)),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget getIdImagePickerWidget(
      {required bool isBackId, required Function onPressed}) {
    if (!isBackId) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: DashedRect(
              color: errorFront ? Colors.red : primaryColor,
              strokeWidth: 2.0,
              gap: 2.5,
              child: TextButton(
                onPressed: () => onPressed(),
                child: (frontIdFile != null)
                    ? Center(
                        child: Image.file(
                          frontIdFile!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.18,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 20,
                            color: primaryColor,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "Pick image of your ID (Front Side)",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      ),
              )));
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: DashedRect(
              color: errorBack ? Colors.red : primaryColor,
              strokeWidth: 2.0,
              gap: 2.5,
              child: TextButton(
                onPressed: () => onPressed(),
                child: (backIdFile != null)
                    ? Center(
                        child: Image.file(
                          backIdFile!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.18,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 20,
                            color: primaryColor,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "Pick image of your ID (Back Side)",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      ),
              )));
    }
  }

  Widget getProfileImagePickerWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.30,
        height: MediaQuery.of(context).size.width * 0.30,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: DashedRect(
          color: errorProfile ? Colors.red : primaryColor,
          strokeWidth: 2.0,
          gap: 2.5,
          child: TextButton(
            onPressed: () {
              _showSheetModalWidget(type: "profile");
            },
            child: profileImage != null
                ? Center(
                    child: Image.file(
                      profileImage!,
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.30,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Icon(Icons.camera_enhance_outlined,
                        color: primaryColor, size: 30),
                  ),
          ),
        ),
      ),
    );
  }

  verifyButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            logoutDialog(context, () async {
              await sharedPreferences.clear();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => SelectUserTypePage()));
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.40,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                color: textFieldColor,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Center(
                child: Text(
              "Logout",
              style: TextStyle(color: subBlackLight),
            )),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              errorFront = false;
              errorBack = false;
              errorProfile = false;
            });
            if ((widget.userEntity.accountStatus == "unverified" ||
                    widget.userEntity.accountStatus == "rejected") &&
                isVerifying == false) {
              if (frontIdFile == null) {
                setState(() {
                  errorFront = true;
                });
              } else if (backIdFile == null) {
                setState(() {
                  errorBack = true;
                });
              } else if (profileImage == null) {
                setState(() {
                  errorProfile = true;
                });
              } else {
                submitVerification();
              }
            } else {}
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.40,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                color: widget.userEntity.accountStatus == "unverified" ||
                        widget.userEntity.accountStatus == "rejected"
                    ? primaryColor
                    : primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Center(
                child: isVerifying
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.5,
                      )
                    : Text(
                        widget.userEntity.accountStatus == "unverified" ||
                                widget.userEntity.accountStatus == "rejected"
                            ? "Verify"
                            : "Pending",
                        style: TextStyle(color: Colors.white),
                      )),
          ),
        ),
      ],
    );
  }

  submitVerification() async {
    setState(() {
      isVerifying = true;
    });
    try {
      FormData formData = await FormData.fromMap({
        "photo": await MultipartFile.fromFile(profileImage!.path,
            filename: profileImage!.path.split('/').last),
        "picIdF": await MultipartFile.fromFile(frontIdFile!.path,
            filename: frontIdFile!.path.split('/').last),
        "picIdS": await MultipartFile.fromFile(backIdFile!.path,
            filename: backIdFile!.path.split('/').last),
        "uid": widget.userEntity.token,
        "email": widget.userEntity.email
      });
      final result = await dio.post(
          EndPoints.BASE_URL + EndPoints.SUBMIT_VERIFICATION,
          data: formData);
      dynamic data = json.decode(result.data);
      print("------> data = ${data.toString()}");
      if (data != null && data['status'] == 200) {
        print("-----> done");
        /*await ref.putFile(profileImage!);
        String imageURL = "";
        await ref.getDownloadURL().then((value) {
          setState(() {
            imageURL = value;
          });
        });*/
        FirebaseFirestore.instance
            .collection('Users')
            .doc("${widget.userEntity.token}")
            .update({'accountStatus': "pending", "profileURL": ""});
        setState(() {
          isVerifying = false;
        });
      }
    } catch (e) {
      print("----> e = ${e.toString()}");
      setState(() {
        isVerifying = false;
      });
      exceptionFlushBar(
          onHidden: () {},
          onChangeStatus: (s) {},
          duration: Duration(seconds: 2),
          context: context,
          message: 'Server error!');
    }
  }

  _showSheetModalWidget({required String type}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        backgroundColor: primaryColor,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: PickImageSheet(onSelectImage: (file) {
              if (file != null) {
                switch (type) {
                  case "front":
                    setState(() {
                      frontIdFile = file;
                    });
                    break;
                  case "back":
                    setState(() {
                      backIdFile = file;
                    });
                    break;
                  default:
                    setState(() {
                      profileImage = file;
                    });
                    break;
                }
              }
            }),
          );
        });
  }
}

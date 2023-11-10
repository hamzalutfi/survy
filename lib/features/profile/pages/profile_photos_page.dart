import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/colors.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/utils/constants/shared_keys.dart';

import '../../../utils/widgets/background_widget.dart';
import '../../../utils/widgets/dashed_widget.dart';
import '../../../utils/widgets/image_loader_widget.dart';
import '../../verify_account/pick_image_sheet.dart';

class ProfilePhotosPage extends StatefulWidget {
  final UserEntity userEntity;

  ProfilePhotosPage(this.userEntity);

  @override
  State<ProfilePhotosPage> createState() => _ProfilePhotosPageState();
}

class _ProfilePhotosPageState extends State<ProfilePhotosPage> {
  String? profileImageURL;
  late Reference ref;

  List photos = [];
  bool isLoading = false;
  bool isChangingPhoto = false;
  late dynamic sharedPreferences;

  initializeShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initializeShared();
    ref = FirebaseStorage.instance.ref().child("/profiles").child(
        "/${widget.userEntity.email}/profile_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().toString()}");
    getUserProfile();
    getUserGalleryPhotos();
  }

  getUserProfile() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('Users');
    final doc = await _collectionRef.doc(widget.userEntity.token).get();
    print("-----> doc = ${doc.toString()}");
    print("-----> doc = ${doc['profileURL']}");
    setState(() {
      profileImageURL = doc['profileURL'];
    });
  }

  getUserGalleryPhotos() async {
    photos = await fetchImages();
    print("-----> photos = ${photos.toString()}");
  }

  Future<List<Map<String, dynamic>>> fetchImages() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child("/profiles")
        .child("/${widget.userEntity.email}")
        .list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      print('result is $fileUrl');

      files.add({
        'url': fileUrl,
        'path': file.fullPath,
        'isSelecting': false
        /*'uploaded_by': fileMeta.customMetadata['uploaded_by'] ?? 'Nobody',
        'description':
            fileMeta.customMetadata['description'] ?? 'No description'*/
      });
    });
    setState(() {
      isLoading = false;
    });
    return files;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Center(
                            child: Image.asset(
                              "assets/images/icons/left-arrow.png",
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gallery',
                          style: TextStyle(fontSize: 28, color: lightColor),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              child: Text(
                                'All your images that\'s you\'ve selected will be here.',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, color: subLightColor),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _showSheetModalWidget(isSetNewImage: false);
                                },
                                child: Icon(
                                  Icons.add_circle_sharp,
                                  color: primaryColor,
                                  size: 30,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.05,
                        ),
                        getProfileImagePickerWidget(),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        isLoading
                            ? CircularProgressIndicator()
                            : photos.length == 0
                                ? Text(
                                    "No photos found!",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : GridView.builder(
                                    itemCount: photos.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          if (!isChangingPhoto)
                                            changeProfileImage(
                                                photos[index]['url'], index);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          decoration: BoxDecoration(
                                              // color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          child: DashedRect(
                                              color: photos[index]['url'] ==
                                                      profileImageURL
                                                  ? Colors.blue
                                                  : primaryColor,
                                              strokeWidth: 2.0,
                                              gap: 2.5,
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.50,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.50,
                                                      child: ImageLoaderWidget(
                                                        photos[index]['url'],
                                                      ),
                                                    ),
                                                  ),
                                                  photos[index]['url'] ==
                                                          profileImageURL
                                                      ? Container(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          child: Center(
                                                            child: Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color:
                                                                    Colors.blue,
                                                                size: 50),
                                                          ),
                                                        )
                                                      : photos[index]
                                                              ['isSelecting']
                                                          ? Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                              color:
                                                                  Colors.blue,
                                                            ))
                                                          : Container()
                                                ],
                                              )),
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                  )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  changeProfileImage(String path, int index) async {
    setState(() {
      photos[index]['isSelecting'] = true;
      isChangingPhoto = true;
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc("${widget.userEntity.token}")
        .update({"profileURL": path});
    // await sharedPreferences.setString(SharedKeys.PROFILE_URL, path);
    // CollectionReference _collectionRef =
    //     FirebaseFirestore.instance.collection('public_offers');
    // QuerySnapshot querySnapshot = await _collectionRef.get();
    // for (var item in querySnapshot.docs) {
    //   if (item['email'] == widget.userEntity.email) {
    //     print("-----> yes = ${item['email']}");
    //     await FirebaseFirestore.instance
    //         .collection('public_offers')
    //         .doc(item.id)
    //         .update({"profileURL": path});
    //   }
    // }
    // QuerySnapshot userOffersQ = await FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(widget.userEntity.token)
    //     .collection('offers')
    //     .get();
    //
    // for (var item in userOffersQ.docs) {
    //   print("-----> item = ${item.id}");
    //   await FirebaseFirestore.instance
    //       .collection('Users')
    //       .doc(widget.userEntity.token)
    //       .collection('offers')
    //       .doc(item.id)
    //       .update({"profileURL": path});
    // }
    // for (int i = 0; i < photos.length; i++) {
    //   setState(() {
    //     photos[i]['isSelecting'] = false;
    //   });
    // }
    // setState(() {
    //   profileImageURL = path;
    //   isChangingPhoto = false;
    // });

    setState(() {
      profileImageURL = path;
      isChangingPhoto = false;
    });
  }

  Widget getProfileImagePickerWidget() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            height: MediaQuery.of(context).size.width * 0.50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: DashedRect(
              color: Colors.blue,
              strokeWidth: 2.0,
              gap: 2.5,
              child: TextButton(
                onPressed: () {
                  _showSheetModalWidget(isSetNewImage: true);
                },
                child: (profileImageURL != null && profileImageURL!.isNotEmpty)
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.width * 0.50,
                          child: ImageLoaderWidget(
                            profileImageURL!,
                            // width: MediaQuery.of(context).size.width * 0.50,
                            // height: MediaQuery.of(context).size.width * 0.50,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.camera_enhance_outlined,
                            color: Colors.blue, size: 30),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "It will be public for everyone.",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }

  _showSheetModalWidget({required bool isSetNewImage}) {
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
                if (isSetNewImage) {
                  setNewImageProfile(file);
                } else {
                  addNewImage(file);
                }
              }
            }),
          );
        });
  }

  setNewImageProfile(file) async {
    setState(() {
      isLoading = true;
    });
    await ref.putFile(file);
    String imageURL = "";
    await ref.getDownloadURL().then((value) {
      setState(() {
        imageURL = value;
        profileImageURL = value;
      });
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc("${widget.userEntity.token}")
        .update({"profileURL": imageURL});
    // sharedPreferences.setString(SharedKeys.PROFILE_URL, imageURL);
    // CollectionReference _collectionRef =
    //     FirebaseFirestore.instance.collection('public_offers');
    // QuerySnapshot querySnapshot = await _collectionRef.get();
    // for (var item in querySnapshot.docs) {
    //   if (item['email'] == widget.userEntity.email) {
    //     print("-----> yes = ${item['email']}");
    //     FirebaseFirestore.instance
    //         .collection('public_offers')
    //         .doc(item.id)
    //         .update({"profileURL": imageURL});
    //   }
    // }
    //
    // QuerySnapshot userOffersQ = await FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(widget.userEntity.token)
    //     .collection('offers')
    //     .get();
    //
    // for (var item in userOffersQ.docs) {
    //   print("-----> item = ${item.id}");
    //   await FirebaseFirestore.instance
    //       .collection('Users')
    //       .doc(widget.userEntity.token)
    //       .collection('offers')
    //       .doc(item.id)
    //       .update({"profileURL": imageURL});
    // }

    getUserGalleryPhotos();
  }

  addNewImage(file) async {
    setState(() {
      isLoading = true;
    });
    await ref.putFile(file);
    String imageURL = "";
    getUserGalleryPhotos();
  }
}

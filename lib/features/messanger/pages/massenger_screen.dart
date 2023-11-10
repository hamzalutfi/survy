import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/services/get_profile_photo.dart';
import '../../../utils/widgets/background_widget.dart';
import '../stuff/messanger_services.dart';
import '../widgets/messenger_tile_widget.dart';

class MessengerScreen extends StatefulWidget {
  final UserEntity currentUser;

  MessengerScreen(this.currentUser);

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  MessengerServices messengerServices = MessengerServices();

  late Stream rooms;

  @override
  void initState() {
    super.initState();
    messengerServices
        .getChatRoomsMember(widget.currentUser.email)
        .then((value) {
      setState(() {
        rooms = value;
      });
      print("----> rooms = ${rooms.length}");
      print("----> rooms = ${rooms.toString()}");
    });
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
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
                        Text(
                          'Messenger',
                          style: TextStyle(fontSize: 28, color: lightColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chat_rooms")
                        .where('users', arrayContains: widget.currentUser.email)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      var items =
                          snapshot.data == null ? [] : snapshot.data!.docs;
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
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FutureBuilder(
                                future: ProfilePhotoService.getUserPhoto(
                                    widget.currentUser.email ==
                                            items[index]['users'][0]
                                        ? '${items[index]['users'][1]}'
                                        : '${items[index]['users'][0]}'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return MessengerTileWidget(
                                    items[index],
                                    widget.currentUser,
                                    isLoadingPhoto: !snapshot.hasData,
                                    profileURL: snapshot.data == null
                                        ? ""
                                        : snapshot.data,
                                  );
                                },
                              );
                            });
                      }
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

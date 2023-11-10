import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';

import '../../../colors.dart';
import '../../../utils/services/get_profile_photo.dart';
import '../../../utils/widgets/background_widget.dart';
import '../../main_page/widgets/main_offer_widget.dart';
import '../../messanger/pages/messages_screen.dart';

class SpecificUserOffers extends StatefulWidget {
  final String specificUserId;
  final QueryDocumentSnapshot specificPerson;
  final UserEntity currentUser;

  const SpecificUserOffers({
    required this.specificUserId,
    required this.currentUser,
    required this.specificPerson,
  });

  @override
  State<SpecificUserOffers> createState() => _SpecificUserOffersState();
}

class _SpecificUserOffersState extends State<SpecificUserOffers> {
  @override
  void initState() {
    print("specificUserId---> ${widget.specificUserId}");
    super.initState();
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
              Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    child: Row(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightColor,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/icons/left-arrow.png",
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
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
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                widget.specificPerson['firstName'] +
                                    " " +
                                    widget.specificPerson['lastName'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 28, color: lightColor),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagesScreen(
                                          currentUser: widget.currentUser,
                                          entryPoint: EntryPoint.externalPoint,
                                          email: widget.specificPerson['email'],
                                        )));
                          },
                          child: Image.asset(
                            'assets/images/icons/chat.png',
                            height: height * 0.07,
                            width: width * 0.07,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users/${widget.specificUserId}/offers")
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
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(
                              future: ProfilePhotoService.getUserPhoto(items[index]['email']),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                return MainOfferWidget(
                                  items[index],
                                  isChating: false,
                                  isLoadingPhoto: !snapshot.hasData,
                                  profileURL: snapshot.data == null
                                      ? ""
                                      : snapshot.data,
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
}

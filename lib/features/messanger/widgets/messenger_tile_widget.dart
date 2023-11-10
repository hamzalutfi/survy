import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/colors.dart';

import '../../../entities/user_entity.dart';
import '../../../utils/widgets/image_loader_widget.dart';
import '../pages/messages_screen.dart';

class MessengerTileWidget extends StatelessWidget {
  final QueryDocumentSnapshot item;
  final UserEntity currentUser;
  final String profileURL;
  final bool isLoadingPhoto;

  MessengerTileWidget(this.item, this.currentUser,
      {required this.profileURL, required this.isLoadingPhoto});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: IntrinsicHeight(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: profileURL != null && profileURL.isNotEmpty
                          ? ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48), // Image radius
                                child: ImageLoaderWidget(
                                  profileURL,
                                  // fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isLoadingPhoto
                                      ? Colors.transparent
                                      : primaryColor),
                              child: Center(
                                  child: isLoadingPhoto
                                      ? Container(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1.5,
                                          ))
                                      : Icon(
                                          Icons.person,
                                          color: backGroundColor,
                                        )))),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.5,
                      child: Text(
                        currentUser.email == item['users'][0]
                            ? '${item['users'][1]}'
                            : '${item['users'][0]}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22,
                            color: subLightColor,
                            fontFamily: "PTSansNarrow"),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: width * 0.5,
                      child: Text(
                        '${item['last_message']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: lightColor,
                            fontFamily: "PTSansNarrow",
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'From:',
                        style: TextStyle(
                            fontSize: 16,
                            color: lightColor,
                            fontFamily: "PTSansNarrow"),
                        children: [
                          TextSpan(
                              text:
                                  ' ${DateTime.fromMicrosecondsSinceEpoch(item['last_date_messaging'] * 1000).toString().substring(0, 10)}',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: "PTSansNarrow",
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Container(
                      width: width * 0.1,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: const Center(
                          child: Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 17)),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessagesScreen(
                                    currentUser: currentUser,
                                    currentRoomItem: item,
                                    entryPoint: EntryPoint.messenger,
                                  )));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

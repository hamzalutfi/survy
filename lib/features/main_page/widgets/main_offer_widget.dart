import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/utils/widgets/image_loader_widget.dart';

import '../../../colors.dart';

class MainOfferWidget extends StatelessWidget {
  QueryDocumentSnapshot item;
  bool isChating;
  Function? onChatTapped;
  final String profileURL;
  final bool isLoadingPhoto;

  MainOfferWidget(this.item,
      {this.isChating = true,
      this.onChatTapped,
      required this.profileURL,
      required this.isLoadingPhoto});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isChating
                  ? Container()
                  : const SizedBox(
                      height: 8.0,
                    ),
              Row(
                children: [
                  Container(
                    height: 40.0,
                    width: 40.0,
                    child: Center(
                        child: /*item['profileURL'] != null &&
                                item['profileURL'].toString().isNotEmpty
                            ? Image.network(
                                item['profileURL'],
                                fit: BoxFit.cover,
                              )
                            : */

                            profileURL != null && profileURL.isNotEmpty
                                ? /*Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ImageLoaderWidget(
                                      profileURL,
                                      // fit: BoxFit.cover,
                                    ),
                                  )*/
                                ClipOval(
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
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1.5,
                                                ))
                                            : Icon(
                                                Icons.person,
                                                color: backGroundColor,
                                              )))),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mr.${item['owner_name']}',
                        style: TextStyle(fontSize: 20, color: lightColor),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'posted in:',
                          style: TextStyle(
                              fontSize: 12,
                              color: lightColor,
                              fontFamily: "PTSansNarrow"),
                          children: [
                            TextSpan(
                                text: ' ${item['created_at']}',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: "PTSansNarrow")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  isChating
                      ? InkWell(
                          onTap: () {
                            onChatTapped!();
                          },
                          child: Image.asset(
                            'assets/images/icons/chat.png',
                            height: height * 0.07,
                            width: width * 0.07,
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                '${item['content']}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/icons/dollar-symbol.png',
                    height: height * 0.07,
                    width: width * 0.07,
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Text(
                    '${item['budget']} \$',
                    style: const TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/icons/deadline.png',
                    height: height * 0.07,
                    width: width * 0.07,
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Text(
                    '${item['period']} Days',
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

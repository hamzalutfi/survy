import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';

import '../../../colors.dart';
import '../../../utils/widgets/image_loader_widget.dart';
import '../pages/specific_user_offers_page.dart';

class SearchResultPersonWidget extends StatelessWidget {
  final QueryDocumentSnapshot item;
  final UserEntity currentUser;
  final String profileURL;
  final bool isLoadingPhoto;

  const SearchResultPersonWidget(this.item, this.currentUser,
      {required this.profileURL, required this.isLoadingPhoto});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: IntrinsicHeight(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpecificUserOffers(
                  specificUserId: item.id,
                  specificPerson: item,
                  currentUser: currentUser,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      child: Center(
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
                    /*SizedBox(height: 50, width: 50, child: CircleAvatar()),*/
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mr.${item['firstName']}',
                        style: TextStyle(fontSize: 25, color: lightColor),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'joined in:',
                          style: TextStyle(
                              fontSize: 16,
                              color: lightColor,
                              fontFamily: "PTSansNarrow"),
                          children: [
                            TextSpan(
                                text: ' 2022-08-04',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: "PTSansNarrow")),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.48,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                            text: 'supports in:',
                            style: TextStyle(
                                fontSize: 16,
                                color: lightColor,
                                fontFamily: "PTSansNarrow"),
                            children: [
                              TextSpan(
                                  text:
                                      ' ${item['locations'].isNotEmpty ? item['locations'][0] + ".." : "-"}\n',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: "PTSansNarrow")),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'This service match this profile!',
                        style: TextStyle(fontSize: 16, color: primaryColor),
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
                            builder: (context) => SpecificUserOffers(
                              specificUserId: item.id,
                              specificPerson: item,
                              currentUser: currentUser,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

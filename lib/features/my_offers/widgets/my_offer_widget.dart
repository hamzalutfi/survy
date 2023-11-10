import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';

class MyOfferWidget extends StatelessWidget {
  QueryDocumentSnapshot item;
  Function (QueryDocumentSnapshot) onDelete;
  Function (QueryDocumentSnapshot) onEdit;

  MyOfferWidget(
      {required this.item, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                       /*CircleAvatar(
                        child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.black.withOpacity(0.6),
                            )),
                      ),*/

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    onEdit(item);
                  },
                  child: Container(
                    width: width * 0.495,
                    color: Colors.blue,
                    height: 40.0,
                    child: const Center(
                        child:
                            Text("Edit", style: TextStyle(color: Colors.white))),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    onDelete(item);
                  },
                  child: Container(
                    width: width * 0.495,
                    color: Colors.blueGrey,
                    height: 40.0,
                    child: const Center(
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

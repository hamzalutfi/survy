import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/features/my_offers/add_new_offer.dart';
import 'package:wego/features/my_offers/stuff/offer_services.dart';
import 'package:wego/features/my_offers/widgets/my_offer_widget.dart';

import '../../colors.dart';
import '../../entities/user_entity.dart';
import '../../utils/constants/constants.dart';
import '../../utils/widgets/background_widget.dart';
import '../main_page/widgets/main_offer_widget.dart';

class MyOffersPage extends StatefulWidget {
  final UserEntity currentUser;

  MyOffersPage(this.currentUser);

  @override
  State<MyOffersPage> createState() => _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage> {
  int lengthOffers = 0;
  OfferServices offerServices = OfferServices();

  @override
  void initState() {
    super.initState();
    print("====> ${"users/${widget.currentUser.token}/offers"}");
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
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                'My Offers',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 28, color: lightColor),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNewOffer(
                                          widget.currentUser,
                                          lengthOffers,
                                          ViewMode.create)));
                            },
                            child: Icon(
                              Icons.add,
                              color: lightColor,
                            ),
                          ),
                        ),
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
                      .collection("Users/${widget.currentUser.token}/offers")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    var items =
                        snapshot.data == null ? [] : snapshot.data!.docs;
                    lengthOffers = items.length;
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
                            return MyOfferWidget(
                              item: items[index],
                              onDelete: (item) {
                                _deleteOfferDialog(context, () {
                                  offerServices.deleteOffer(
                                      item, widget.currentUser);
                                });
                              },
                              onEdit: (item) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddNewOffer(
                                              widget.currentUser,
                                              lengthOffers,
                                              ViewMode.edit,
                                              itemForUpdate: item,
                                            )));
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

  Future<void> _deleteOfferDialog(
      BuildContext context, Function onSubmit) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Delete Offer',
              style: TextStyle(
                  fontSize: 17, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Are you sure you want to delete this offer?!",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w200),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                      fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSubmit();
                  }),
            ],
          );
        });
  }
}

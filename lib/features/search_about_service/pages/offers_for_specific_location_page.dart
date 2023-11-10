import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';

import '../../../colors.dart';
import '../../../utils/services/get_profile_photo.dart';
import '../../../utils/widgets/background_widget.dart';
import '../stuff/service_stuff.dart';
import '../widgets/search_result_person_widget.dart';

class OffersForSpecificLocationPage extends StatefulWidget {
  final String location;
  final UserEntity currentUser;

  const OffersForSpecificLocationPage(this.location, this.currentUser);

  @override
  State<OffersForSpecificLocationPage> createState() =>
      _OffersForSpecificLocationPageState();
}

class _OffersForSpecificLocationPageState
    extends State<OffersForSpecificLocationPage> {
  List searchResults = [];
  ServiceStuff serviceStuff = ServiceStuff();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchByLocationFunc(widget.location);
  }

  _searchByLocationFunc(String val) async {
    setState(() {
      isLoading = true;
    });
    searchResults = await serviceStuff.searchByLocation(
        location: widget.location, currentEmail: widget.currentUser.email);
    setState(() {
      isLoading = false;
    });
    print("---> searchResults = ${searchResults.toString()}");
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Text(
                            widget.location,
                            maxLines: 3,
                            style: TextStyle(fontSize: 20, color: lightColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Expanded(
                flex: 1,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : searchResults.isEmpty
                        ? Center(
                            child: Text("No offers found!",
                                style: TextStyle(
                                  color: primaryColor,
                                )),
                          )
                        : ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FutureBuilder(
                                future: ProfilePhotoService.getUserPhoto(
                                    searchResults[index]['email']),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return SearchResultPersonWidget(
                                    searchResults[index],
                                    widget.currentUser,
                                    isLoadingPhoto: !snapshot.hasData,
                                    profileURL: snapshot.data == null
                                        ? ""
                                        : snapshot.data,
                                  );
                                },
                              );
                            }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/search_about_service/pages/specific_user_offers_page.dart';
import 'package:wego/features/search_about_service/pages/location_suggestions_screen.dart';
import 'package:wego/features/search_about_service/stuff/service_stuff.dart';
import 'package:wego/features/search_about_service/widgets/search_result_person_widget.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/services/get_profile_photo.dart';
import '../../../utils/widgets/background_widget.dart';

class SearchingServiceScreen extends StatefulWidget {
  final UserEntity currentUser;

  SearchingServiceScreen(this.currentUser);

  @override
  State<SearchingServiceScreen> createState() => _SearchingServiceScreenState();
}

class _SearchingServiceScreenState extends State<SearchingServiceScreen> {
  final TextEditingController _searchingController = TextEditingController();
  ServiceStuff serviceStuff = ServiceStuff();
  bool isLoading = false;

  List searchResults = [];

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Text(
                          'Searching over service!',
                          style: TextStyle(fontSize: 28, color: lightColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      decoration: const BoxDecoration(
                        color: lightColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextField(
                              maxLines: 1,
                              controller: _searchingController,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter service name...',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: hintOfTextFieldColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              cursorColor: primaryColor,
                              onChanged: (val) {
                                _searchByServiceFunc(val);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              child: Container(
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: primaryColor,
                                  ),
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  )),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LocationSuggestionScreen(widget.currentUser),
                          ),
                        );
                      },
                      child: const Text(
                        'Search by location?',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : searchResults.isEmpty
                        ? Center(
                            child: Text("No results found!",
                                style: TextStyle(color: primaryColor)),
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

  _searchByServiceFunc(String val) async {
    setState(() {
      isLoading = true;
    });
    searchResults = await serviceStuff.searchByService(
        val: val, currentUserEmail: widget.currentUser.email);
    setState(() {
      isLoading = false;
    });
    print("---> searchResults = ${searchResults.toString()}");
  }
}

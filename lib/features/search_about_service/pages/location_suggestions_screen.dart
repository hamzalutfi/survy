import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/profile/stuff/location_services.dart';
import '../../../colors.dart';
import 'offers_for_specific_location_page.dart';

class LocationSuggestionScreen extends StatefulWidget {
  final UserEntity currentUser;


  LocationSuggestionScreen(this.currentUser);

  @override
  State<LocationSuggestionScreen> createState() =>
      _LocationSuggestionScreenState();
}

class _LocationSuggestionScreenState extends State<LocationSuggestionScreen> {
  List<Suggestion> result = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        leading: Container(
          color: primaryColor,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: TextFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by location...',
            hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          onChanged: (val) async {
            if (val.trim().isNotEmpty) {
              setState(() {
                isLoading = true;
              });
              result = await LocationSuggestions.fetchSuggestions(val, 'en');
              setState(() {
                isLoading = false;
              });
            }
          },
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
              width: width * 0.14,
              height: width * 0.12,
              color: primaryColor,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  )))
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : result.isEmpty
                ? Center(
                    child: Text("No suggestions found!",
                        style: TextStyle(color: primaryColor)),
                  )
                : ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OffersForSpecificLocationPage(
                                            result[index].description,
                                        widget.currentUser
                                        )));
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      result[index].description,
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
      ),
    );
  }
}

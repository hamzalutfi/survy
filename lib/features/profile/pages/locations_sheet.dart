import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wego/features/auth/widget/service_selectable_widget.dart';
import 'package:wego/utils/constants/colors.dart';
import 'package:wego/utils/widgets/input_text_field.dart';

import '../stuff/location_services.dart';

class LocationsSheetPage extends StatefulWidget {
  List<String> selectedLocations;
  final Function(List<String>) onSelect;

  LocationsSheetPage({required this.onSelect, required this.selectedLocations});

  @override
  State<LocationsSheetPage> createState() => _LocationsSheetPageState();
}

class _LocationsSheetPageState extends State<LocationsSheetPage> {
  List<String> locations = [];
  List<Suggestion> suggestions = [];
  TextEditingController _locationController = TextEditingController();
  bool isSuggestion = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(1, 1))],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          builder: (BuildContext context, ScrollController scrollController) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Container(
                              width: 80,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InputTextField(
                          onChanged: (val) async {
                            if(val.trim().isNotEmpty) {
                              setState(() {
                                isSuggestion = true;
                              });

                              suggestions =
                              await LocationSuggestions.fetchSuggestions(
                                  val, 'en');
                              setState(() {
                                isSuggestion = false;
                              });
                            }
                          },
                          controller: _locationController,
                          inputType: TextInputType.name,
                          hintText: 'Any place in your mind...?!',
                          errorText: 'Invalid input!',
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 20,
                      ),
                    ),
                    SliverToBoxAdapter(child: _getCurrentWidget()),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100,
                      ),
                    ),
                  ],
                ),
                _driverSheetButton()
              ],
            );
          }),
    );
  }

  //
  // goAndGetSuggestions(val) async {
  //   Timer(const Duration(seconds: 1), () async {
  //     suggestions = await LocationSuggestions.fetchSuggestions(val, 'en');
  //   });
  // }

  Widget _getCurrentWidget() {
    if (isSuggestion) {
      return const Center(child: CircularProgressIndicator());
    } else if (suggestions.isEmpty) {
      return const Center(
        child: Text(
          "No suggestions found!",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: suggestions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ServiceSelectableWidget(
              serviceName: suggestions[index].description,
              isLocation: true,
              onSelect: (String service) {
                setState(() {
                  widget.selectedLocations.add(service);
                });
                print("selected = ${widget.selectedLocations}");
                widget.onSelect(widget.selectedLocations);
              },
              onDeSelect: (String service) {
                setState(() {
                  widget.selectedLocations.remove(service);
                });
                print("selected = ${widget.selectedLocations}");
                widget.onSelect(widget.selectedLocations);
              },
              isSelected: widget.selectedLocations
                  .contains(suggestions[index].description),
            ),
          );
        });
  }

  _driverSheetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            widget.onSelect(widget.selectedLocations);
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            width: double.maxFinite,
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: const Center(
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

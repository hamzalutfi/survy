import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wego/features/auth/widget/service_selectable_widget.dart';
import 'package:wego/utils/constants/colors.dart';
import 'package:wego/utils/widgets/input_text_field.dart';

import '../stuff/location_services.dart';

class AddNewServiceSheetPage extends StatefulWidget {
  final Function(String) onAdd;

  AddNewServiceSheetPage({required this.onAdd});

  @override
  State<AddNewServiceSheetPage> createState() => _AddNewServiceSheetPageState();
}

class _AddNewServiceSheetPageState extends State<AddNewServiceSheetPage> {
  TextEditingController _serviceController = TextEditingController();

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

                          },
                          controller: _serviceController,
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
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100,
                      ),
                    ),
                  ],
                ),
                _serviceSheetButton()
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


  _serviceSheetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            widget.onAdd(_serviceController.text.trim());
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

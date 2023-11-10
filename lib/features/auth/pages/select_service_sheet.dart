import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wego/features/auth/widget/service_selectable_widget.dart';
import 'package:wego/utils/constants/colors.dart';


class ServiceSheetPage extends StatefulWidget {
  List<String> selectedServices;
  final Function(List<String>) onSelect;
  final bool isMulti;

  ServiceSheetPage({required this.onSelect, required this.selectedServices, this.isMulti = true});

  @override
  State<ServiceSheetPage> createState() => _ServiceSheetPageState();
}

class _ServiceSheetPageState extends State<ServiceSheetPage> {
  List<String> services = [];

  @override
  void initState() {
    // print("--> ddddd");
    // DatabaseReference starCountRef = FirebaseDatabase.instance.ref('services');
    // starCountRef.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value;
    //   print("---> data = $data");
    //
    // });
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

  Widget _getCurrentWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("services").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var items = snapshot.data == null ? [] : snapshot.data!.docs;
          if (!snapshot.hasData) {
            return const Center(
              child:  SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator()),
            );
          } else if (items.isEmpty) {
            return const Center(
              child: Text(
                "No services found!",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ServiceSelectableWidget(
                    isLocation: false,
                    serviceName: items[index]['service_name'],
                    onSelect: (String service) {
                      if(widget.isMulti) {
                        setState(() {
                          widget.selectedServices.add(service);
                        });
                        print("selected = ${widget.selectedServices}");
                        widget.onSelect(widget.selectedServices);
                      } else {
                        setState(() {
                          widget.selectedServices = [];
                          widget.selectedServices.add(service);
                        });
                        print("selected = ${widget.selectedServices}");
                        widget.onSelect(widget.selectedServices);
                        Navigator.pop(context);
                      }
                    },
                    onDeSelect: (String service) {
                      setState(() {
                        widget.selectedServices.remove(service);
                      });
                      print("selected = ${widget.selectedServices}");
                      widget.onSelect(widget.selectedServices);
                    },
                    isSelected: widget.selectedServices
                        .contains(items[index]['service_name']),
                  ),
                );
              });
        });
  }

  _driverSheetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            widget.onSelect(widget.selectedServices);
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

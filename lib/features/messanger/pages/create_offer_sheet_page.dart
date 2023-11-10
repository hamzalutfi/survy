import 'package:flutter/material.dart';
import 'package:wego/features/auth/widget/service_selectable_widget.dart';
import 'package:wego/utils/constants/colors.dart';
import 'package:wego/utils/widgets/input_text_field.dart';

import '../../../entities/user_entity.dart';
import '../../auth/pages/select_service_sheet.dart';

class CreateOfferSheetPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelect;
  final UserEntity currentUser;

  CreateOfferSheetPage({required this.onSelect, required this.currentUser});

  @override
  State<CreateOfferSheetPage> createState() => _CreateOfferSheetPageState();
}

class _CreateOfferSheetPageState extends State<CreateOfferSheetPage> {
  TextEditingController _periodController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  List<String> services = [];

  @override
  void initState() {
    super.initState();
    setState(() {
    });
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
          initialChildSize: 0.75,
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
                          onChanged: (val) async {},
                          controller: _periodController,
                          inputType: TextInputType.number,
                          hintText: 'What is the period of the offer? (Days)',
                          errorText: 'Invalid input!',
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 8,
                    )),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InputTextField(
                          onChanged: (val) async {},
                          controller: _budgetController,
                          inputType: TextInputType.number,
                          hintText: 'What is the budget of the offer? (EUR)',
                          errorText: 'Invalid input!',
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 8,
                    )),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InputTextField(
                          onChanged: (val) async {},
                          controller: _descController,
                          inputType: TextInputType.text,
                          hintText: 'Description (optional)',
                          maxLines: 4,
                          errorText: 'Invalid input!',
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 8,
                    )),
                    SliverToBoxAdapter(child: _servicesWidget()),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100,
                      ),
                    ),
                  ],
                ),
                _sheetButton()
              ],
            );
          }),
    );
  }

  _servicesWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () => _showSheetModalWidget(),
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: textFieldColor,
            border: Border.all(color: textFieldColor, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  services.isEmpty
                      ? "Select a service (optional)"
                      : services[0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        services.isEmpty ? hintOfTextFieldColor : Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: services.isEmpty ? hintOfTextFieldColor : Colors.black,
                size: 17,
              )
            ],
          ),
        ),
      ),
    );
  }

  _showSheetModalWidget() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        backgroundColor: primaryColor,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ServiceSheetPage(
              selectedServices: services,
              isMulti: false,
              onSelect: (list) {
                setState(() {
                  services = list;
                });
              },
            ),
          );
        });
  }

  _sheetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            if (_periodController.text.trim().isEmpty) {
            } else if (_budgetController.text.trim().isEmpty) {
            } else {
              print("service => $services");
              widget.onSelect({
                'period': _periodController.text,
                'budget': _budgetController.text,
                'message': _descController.text,
                'service': services.isEmpty ? null : services[0]
              });
              Navigator.pop(context);
            }
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
                "Send!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/my_offers/stuff/offer_services.dart';

import '../../colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/widgets/background_widget.dart';
import '../../utils/widgets/input_text_field.dart';
import '../../../utils/widgets/auth_button.dart';

class AddNewOffer extends StatefulWidget {
  final UserEntity currentUser;
  final int lengthOffers;
  final ViewMode mode;
  final QueryDocumentSnapshot? itemForUpdate;

  AddNewOffer(this.currentUser, this.lengthOffers, this.mode,
      {this.itemForUpdate});

  @override
  State<AddNewOffer> createState() => _AddNewOfferState();
}

class _AddNewOfferState extends State<AddNewOffer> {
  bool errorContentValidation = false;
  bool errorBudgetValidation = false;
  bool errorPeriodValidation = false;
  bool isSubmittingOffer = false;
  TextEditingController _contentController = TextEditingController();
  TextEditingController _periodController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();

  OfferServices offerServices = OfferServices();

  @override
  void initState() {
    super.initState();
    if (widget.mode == ViewMode.edit) {
      _contentController =
          TextEditingController(text: widget.itemForUpdate!['content']);
      _periodController =
          TextEditingController(text: widget.itemForUpdate!['period']);
      _budgetController =
          TextEditingController(text: widget.itemForUpdate!['budget']);
    }
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.02,
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
                      Text(
                        'Add New Offer',
                        style: TextStyle(
                          fontSize: 28,
                          color: lightColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  InputTextField(
                    onChanged: (val) {
                      setState(() {
                        errorContentValidation = false;
                      });
                    },
                    controller: _contentController,
                    inputType: TextInputType.emailAddress,
                    hintText: 'Offer description...',
                    errorText: 'Invalid input!',
                    showError: errorContentValidation,
                    color: textFieldColor,
                    maxLines: 5,
                  ),
                  SizedBox(height: 10),
                  InputTextField(
                    onChanged: (val) {
                      setState(() {
                        errorBudgetValidation = false;
                      });
                    },
                    controller: _budgetController,
                    inputType: TextInputType.number,
                    hintText: 'Budget....',
                    errorText: 'Invalid input!',
                    showError: errorContentValidation,
                    color: textFieldColor,
                    maxLines: 1,
                  ),
                  SizedBox(height: 10),
                  InputTextField(
                    onChanged: (val) {
                      setState(() {
                        errorPeriodValidation = false;
                      });
                    },
                    controller: _periodController,
                    inputType: TextInputType.number,
                    hintText: 'Period (In Days)....',
                    errorText: 'Invalid input!',
                    showError: errorPeriodValidation,
                    color: textFieldColor,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  AuthButton(
                      onPressed: () async {
                        widget.mode == ViewMode.create
                            ? _submitNewOffer()
                            : _editOffer();
                        Navigator.pop(context);
                      },
                      text: widget.mode == ViewMode.create ? 'GO!' : "Edit",
                      isLoading: isSubmittingOffer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _submitNewOffer() async {
    if (_contentController.text.trim().isEmpty) {
      setState(() {
        errorContentValidation = true;
      });
    } else if (_budgetController.text.trim().isEmpty) {
      setState(() {
        errorBudgetValidation = true;
      });
    } else if (_periodController.text.trim().isEmpty) {
      setState(() {
        errorPeriodValidation = true;
      });
    } else {
      setState(() {
        isSubmittingOffer = true;
      });

      offerServices.createOffer(
        ownerName:
            "${widget.currentUser.firstName} ${widget.currentUser.lastName}",
        content: _contentController.text,
        budget: _budgetController.text,
        period: _periodController.text,
        uid: widget.currentUser.token,
        length: widget.lengthOffers,
        email: widget.currentUser.email,
        profileURL: widget.currentUser.profileURL,
      );

      setState(() {
        isSubmittingOffer = false;
      });
    }
  }

  _editOffer() async {
    if (_contentController.text.trim().isEmpty) {
      setState(() {
        errorContentValidation = true;
      });
    } else if (_budgetController.text.trim().isEmpty) {
      setState(() {
        errorBudgetValidation = true;
      });
    } else if (_periodController.text.trim().isEmpty) {
      setState(() {
        errorPeriodValidation = true;
      });
    } else {
      setState(() {
        isSubmittingOffer = true;
      });

      offerServices.editOffer(
          ownerName:
              "${widget.currentUser.firstName} ${widget.currentUser.lastName}",
          content: _contentController.text,
          budget: _budgetController.text,
          period: _periodController.text,
          uid: widget.currentUser.token,
          length: widget.lengthOffers,
          documentIdForEdit: widget.itemForUpdate!.id);

      setState(() {
        isSubmittingOffer = false;
      });
    }
  }
}

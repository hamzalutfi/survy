import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/entities/user_entity.dart';
import 'package:wego/features/profile/pages/locations_sheet.dart';
import 'package:wego/features/profile/pages/add_new_service_sheet.dart';
import 'package:wego/features/profile/pages/profile_photos_page.dart';
import 'package:wego/utils/mixin/flush_bar_mixin.dart';
import '../../../colors.dart';
import '../../../utils/constants/shared_keys.dart';
import '../../../utils/widgets/auth_button.dart';
import '../../../utils/widgets/background_widget.dart';
import '../../../utils/widgets/input_text_field.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/pages/select_service_sheet.dart';
import '../../auth/stuff/auth_services.dart';

class ProfileScreen extends StatefulWidget {
  UserEntity userEntity;

  ProfileScreen(this.userEntity);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with FlushBarMixin {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  List<String> services = [];
  List<String> locations = [];

  bool isRegistering = false;
  bool errorFirstNameValidation = false;
  bool errorLastNameValidation = false;
  bool errorEmailValidation = false;
  bool errorPasswordValidation = false;
  bool errorConfirmPasswordValidation = false;
  bool errorConfirmationPassword = false;
  bool errorServicesValidation = false;
  bool errorLocationsValidation = false;

  late dynamic sharedPreferences;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    initializeShared();
    _firstNameController =
        TextEditingController(text: widget.userEntity.firstName);
    _lastNameController =
        TextEditingController(text: widget.userEntity.lastName);
    _emailController = TextEditingController(text: widget.userEntity.email);
    setState(() {
      services = widget.userEntity.servicesType;
      locations = widget.userEntity.locations;
    });
  }

  initializeShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
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
            padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(fontSize: 28, color: lightColor),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              child: Text(
                                'Do you want to update your profile?!',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, color: subLightColor),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/images/thinking.png',
                              height: 20,
                              width: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // GestureDetector(
                        //   onVerticalDragEnd: (val) {
                        //     if (val.velocity.pixelsPerSecond.dy != 0.0) {
                        //       if (widget.type == 0) {
                        //         widget.type = 1;
                        //       } else if (widget.type == 1) {
                        //         widget.type = 2;
                        //       } else if (widget.type == 2) {
                        //         widget.type = 0;
                        //       }
                        //       setState(() {});
                        //     }
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: getTypeColor(widget.type),
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(
                        //           top: 3.0,
                        //           bottom: 3.0,
                        //           right: 8.0,
                        //           left: 8.0),
                        //       child: Text(getTypeString(widget.type),
                        //           style:
                        //           const TextStyle(color: Colors.white)),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InputTextField(
                            onChanged: (val) {
                              setState(() {
                                // errorFirstNameValidation = false;
                              });
                            },
                            controller: _firstNameController,
                            inputType: TextInputType.name,
                            hintText: 'First name...',
                            errorText: 'Invalid input!',
                            //showError: errorFirstNameValidation,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Expanded(
                          child: InputTextField(
                            onChanged: (val) {
                              setState(() {
                                //errorLastNameValidation = false;
                              });
                            },
                            controller: _lastNameController,
                            inputType: TextInputType.name,
                            hintText: 'Last name...',
                            errorText: 'Invalid input!',
                            // showError: errorLastNameValidation,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    InputTextField(
                      onChanged: (val) {
                        setState(() {
                          // errorEmailValidation = false;
                        });
                      },
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      hintText: 'Email...',
                      errorText: 'Invalid input!',
                      // showError: errorEmailValidation,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    _accountTypeDropDown(),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => _showSheetModalWidget(),
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(top: 4.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: textFieldColor,
                              border: Border.all(
                                  color: errorServicesValidation
                                      ? Colors.red
                                      : textFieldColor,
                                  width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  services.isEmpty ? "Services" : "Selected",
                                  style: TextStyle(
                                    color: services.isEmpty
                                        ? hintOfTextFieldColor
                                        : Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: services.isEmpty
                                      ? hintOfTextFieldColor
                                      : Colors.black,
                                  size: 17,
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: errorServicesValidation,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: Text(
                              "Choose 1 service at least!",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: List.generate(
                          services.length,
                          (index) => Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, right: 3.0),
                                    child: InputChip(
                                      backgroundColor: Colors.black,
                                      label: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          services[index],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      deleteIconColor: Colors.white,
                                      onDeleted: () {
                                        setState(() {
                                          services.remove(services[index]);
                                        });
                                      },
                                    ),
                                  ),
                                  index == services.length - 1
                                      ? GestureDetector(
                                          onTap: () {
                                            _addNewService();
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: textFieldColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(Icons.add,
                                                  color: Colors.black,
                                                  size: 18),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => _showLocationsSheetModalWidget(),
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(top: 4.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: textFieldColor,
                              border: Border.all(
                                  color: errorLocationsValidation
                                      ? Colors.red
                                      : textFieldColor,
                                  width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  locations.isEmpty ? "Locations" : "Selected",
                                  style: TextStyle(
                                    color: locations.isEmpty
                                        ? hintOfTextFieldColor
                                        : Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: locations.isEmpty
                                      ? hintOfTextFieldColor
                                      : Colors.black,
                                  size: 17,
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: errorLocationsValidation,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: Text(
                              "Choose 1 locations at least!",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: List.generate(
                          locations.length,
                          (index) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 3.0, right: 3.0),
                                child: InputChip(
                                  backgroundColor: Colors.black,
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      locations[index],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  deleteIconColor: Colors.white,
                                  onDeleted: () {
                                    setState(() {
                                      locations.remove(locations[index]);
                                    });
                                  },
                                ),
                              )),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  width: width * 0.5,
                  child: AuthButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePhotosPage(widget.userEntity)));
                    },
                    text: 'My Album',
                    buttonColor: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                AuthButton(
                    onPressed: () async {
                      if (!isRegistering) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const MainScreen(),
                        //   ),
                        // );
                        if (_firstNameController.text.trim().isEmpty) {
                          setState(() {
                            errorFirstNameValidation = true;
                          });
                        } else if (_lastNameController.text.trim().isEmpty) {
                          setState(() {
                            errorLastNameValidation = true;
                          });
                        } else if (_emailController.text.trim().isEmpty) {
                          setState(() {
                            errorEmailValidation = true;
                          });
                        } else if (services.isEmpty &&
                            widget.userEntity.type != 0) {
                          setState(() {
                            errorServicesValidation = true;
                          });
                        } else {
                          setState(() {
                            isRegistering = true;
                          });
                          print(widget.userEntity.toString());
                          var result = await _auth.update(
                              type: widget.userEntity.type,
                              name: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              services: services,
                              locations: locations,
                              uid: widget.userEntity.token,
                              accountStatus: widget.userEntity.accountStatus,
                              profileURL: widget.userEntity.profileURL);

                          // var result = await _auth.register(_emailController.text, _passwordController.text);
                          if (result is UserEntity) {
                            setState(() {
                              isRegistering = false;
                            });
                            saveUserInfo(result);
                          } else {
                            if (result.toString().trim().isNotEmpty) {
                              exceptionFlushBar(
                                context: context,
                                message: result.toString(),
                                duration: const Duration(milliseconds: 2000),
                                onChangeStatus: (status) {},
                                onHidden: () {},
                              );
                            }
                            setState(() {
                              isRegistering = false;
                            });
                          }
                        }
                      }
                    },
                    text: 'Update',
                    isLoading: isRegistering),
                SizedBox(
                  height: height * 0.05,
                ),
              ],
            )),
          ),
        ],
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
              onSelect: (list) {
                setState(() {
                  errorServicesValidation = false;
                  services = list;
                });
              },
            ),
          );
        });
  }

  _addNewService() {
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
            child: AddNewServiceSheetPage(
              onAdd: (service) {
                setState(() {
                  errorServicesValidation = false;
                  services.contains(service.toString().trim())
                      ? print("")
                      : services.add(service);
                });
              },
            ),
          );
        });
  }

  _showLocationsSheetModalWidget() {
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
            child: LocationsSheetPage(
              selectedLocations: locations,
              onSelect: (list) {
                setState(() {
                  errorLocationsValidation = false;
                  locations = list;
                });
              },
            ),
          );
        });
  }

  saveUserInfo(UserEntity user) async {
    print("----> user = ${user.toString()}");
    sharedPreferences.setString(SharedKeys.UID, user.token);
    sharedPreferences.setString(SharedKeys.EMAIL, user.email);
    sharedPreferences.setString(SharedKeys.FIRST_NAME, user.firstName);
    sharedPreferences.setString(SharedKeys.LAST_NAME, user.lastName);
    sharedPreferences.setString(SharedKeys.ACCOUNT_STATUS, user.accountStatus);
    sharedPreferences.setBool(SharedKeys.IS_LOGGED_IN, true);
    sharedPreferences.setInt(SharedKeys.TYPE, user.type);
    sharedPreferences.setString(
        SharedKeys.SERVICES_TYPE, SharedKeys.encode(user.servicesType));
    sharedPreferences.setString(
        SharedKeys.LOCATIONS, SharedKeys.encode(user.locations));
    Navigator.pop(context, {'update': user});

    // final String servicesSP = await prefs.getString('musics_key');
    //
    // final List<String> services = SharedKeys.decode(servicesSP);
  }

  Widget _accountTypeDropDown() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: textFieldColor,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            "Account type*",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          iconSize: 20.0,
          icon: Transform(
              alignment: FractionalOffset.center,
              transform: new Matrix4.identity()..rotateZ(90 * 3.1415927 / 180),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 25,
                color: Colors.grey,
              )),
          value: widget.userEntity.type == 0
              ? "Service Consumer"
              : widget.userEntity.type == 1
                  ? "Service Producer"
                  : "Both",
          items: ["Service Consumer", "Service Producer", "Both"]
              .map<DropdownMenuItem<String>>((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Container(
                // width: hintWidth,
                child: Text(
                  option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val == "Service Consumer") {
              widget.userEntity.type = 0;
            } else if (val == "Service Producer") {
              widget.userEntity.type = 1;
            } else {
              widget.userEntity.type = 2;
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}

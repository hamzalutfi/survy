import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/features/auth/pages/select_service_sheet.dart';
import 'package:wego/features/auth/stuff/auth_services.dart';
import 'package:wego/utils/widgets/auth_button.dart';
import 'package:wego/utils/widgets/background_widget.dart';
import 'package:wego/utils/widgets/input_text_field.dart';
import '../../../entities/user_entity.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/shared_keys.dart';
import '../../../utils/mixin/flush_bar_mixin.dart';
import '../../main_page/main_screen.dart';
import '../../verify_account/verify_account_page.dart';

class RegisterScreen extends StatefulWidget {
  int type;

  RegisterScreen(this.type);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with FlushBarMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _auth = AuthService();

  List<String> services = [];

  bool isRegistering = false;
  bool errorFirstNameValidation = false;
  bool errorLastNameValidation = false;
  bool errorEmailValidation = false;
  bool errorPasswordValidation = false;
  bool errorConfirmPasswordValidation = false;
  bool errorConfirmationPassword = false;
  bool errorServicesValidation = false;

  late dynamic sharedPreferences;

  @override
  void initState() {
    super.initState();
    initializeShared();
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
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Row(
                    children: [  // here we make some changes
                      // InkWell(
                      //   child: Container(
                      //     width: 35,
                      //     height: 35,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: lightColor,
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(right: 4.0),
                      //       child: Center(
                      //         child: Image.asset(
                      //           "assets/images/icons/left-arrow.png",
                      //           width: 18,
                      //           height: 18,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () => Navigator.pop(context),
                      // ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(fontSize: 28, color: lightColor),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Hello, what\'s your name!?',
                                style: TextStyle(
                                    fontSize: 18, color: subLightColor),
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
                         /* GestureDetector(
                            onVerticalDragEnd: (val) {
                              if (val.velocity.pixelsPerSecond.dy != 0.0) {
                                if (widget.type == 0) {
                                  widget.type = 1;
                                } else if (widget.type == 1) {
                                  widget.type = 2;
                                } else if (widget.type == 2) {
                                  widget.type = 0;
                                }
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: getTypeColor(widget.type),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 3.0,
                                    bottom: 3.0,
                                    right: 8.0,
                                    left: 8.0),
                                child: Text(getTypeString(widget.type),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                          )*/
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
                                  errorFirstNameValidation = false;
                                });
                              },
                              controller: _firstNameController,
                              inputType: TextInputType.name,
                              hintText: 'First name...',
                              errorText: 'Invalid input!',
                              showError: errorFirstNameValidation,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Expanded(
                            child: InputTextField(
                              onChanged: (val) {
                                setState(() {
                                  errorLastNameValidation = false;
                                });
                              },
                              controller: _lastNameController,
                              inputType: TextInputType.name,
                              hintText: 'Last name...',
                              errorText: 'Invalid input!',
                              showError: errorLastNameValidation,
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
                            errorEmailValidation = false;
                          });
                        },
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        hintText: 'Email...',
                        errorText: 'Invalid input!',
                        showError: errorEmailValidation,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InputTextField(
                        onChanged: (val) {
                          setState(() {
                            errorConfirmationPassword = false;
                            errorPasswordValidation = false;
                          });
                        },
                        controller: _passwordController,
                        inputType: TextInputType.visiblePassword,
                        hintText: 'Password...',
                        errorText: errorConfirmationPassword
                            ? 'Password not confirmed!'
                            : 'Invalid input!',
                        showError: errorPasswordValidation ||
                            errorConfirmationPassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InputTextField(
                        onChanged: (val) {
                          setState(() {
                            errorConfirmationPassword = false;
                            errorConfirmPasswordValidation = false;
                          });
                        },
                        controller: _confirmPasswordController,
                        inputType: TextInputType.visiblePassword,
                        hintText: 'Confirm Password...',
                        errorText: errorConfirmationPassword
                            ? 'Password not confirmed!'
                            : 'Invalid input!',
                        showError: errorConfirmPasswordValidation ||
                            errorConfirmationPassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),

                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text("Already have an account ?", style: TextStyle(
                         fontSize: 14.0,
                         color: Colors.black
                                           ),),
                      ),
                     SizedBox(
                        height: height * 0.03,
                      ),
                     Text("You can change your account type after complete the registration process.", style: TextStyle(
                       fontSize: 14.0,
                       color: subLightColor
                     ),)

                     /* widget.type == 1 || widget.type == 2
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => _showSheetModalWidget(),
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 4.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      color: textFieldColor,
                                      border: Border.all(
                                          color: errorServicesValidation
                                              ? Colors.red
                                              : Colors.white,
                                          width: 1.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          services.isEmpty
                                              ? "Services"
                                              : "Selected",
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
                                    padding: const EdgeInsets.symmetric(
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
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: List.generate(
                            services.length,
                            (index) => Padding(
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
                                )),
                      )*/
                    ],
                  ),
                  const SizedBox(
                    height: 25,
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
                          } else if (_passwordController.text.trim().isEmpty) {
                            setState(() {
                              errorPasswordValidation = true;
                            });
                          } else if (_confirmPasswordController.text
                              .trim()
                              .isEmpty) {
                            setState(() {
                              errorConfirmPasswordValidation = true;
                            });
                          } else if (_confirmPasswordController.text !=
                              _passwordController.text) {
                            setState(() {
                              errorConfirmationPassword = true;
                            });
                          } /*else if (services.isEmpty && widget.type != 0) {
                            setState(() {
                              errorServicesValidation = true;
                            });
                          } */else {
                            setState(() {
                              isRegistering = true;
                            });
                            var result = await _auth.register(
                                type: widget.type,
                                name: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                services: []); // services

                            // var result = await _auth.register(_emailController.text, _passwordController.text);
                            if (result is UserEntity) {
                              setState(() {
                                isRegistering = false;
                              });
                              saveUserInfo(result);
                            } else {
                              exceptionFlushBar(
                                context: context,
                                message: result.toString(),
                                duration: const Duration(milliseconds: 2000),
                                onChangeStatus: (status) {},
                                onHidden: () {},
                              );
                              setState(() {
                                isRegistering = false;
                              });
                            }
                          }
                        }
                      },
                      text: 'GO!',
                      isLoading: isRegistering),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  saveUserInfo(UserEntity user) async {
    print("----> user = ${user.toString()}");
    sharedPreferences.setString(SharedKeys.UID, user.token);
    sharedPreferences.setString(SharedKeys.EMAIL, user.email);
    sharedPreferences.setString(SharedKeys.FIRST_NAME, user.firstName);
    sharedPreferences.setString(SharedKeys.LAST_NAME, user.lastName);
    sharedPreferences.setString(SharedKeys.ACCOUNT_STATUS, user.accountStatus);
    sharedPreferences.setBool(SharedKeys.IS_LOGGED_IN, true);
    sharedPreferences.setString(
        SharedKeys.SERVICES_TYPE, SharedKeys.encode(user.servicesType));
    sharedPreferences.setString(
        SharedKeys.LOCATIONS, SharedKeys.encode(user.locations));
    sharedPreferences.setInt(SharedKeys.TYPE, widget.type);
    sharedPreferences.setString(SharedKeys.PROFILE_URL, user.profileURL);
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => MainScreen(user)),
    //     (route) => false);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VerifyAccountPage(user)),
            (route) => false);
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

  Color getTypeColor(int type) {
    switch (type) {
      case 0:
        return Colors.blue;
      case 1:
        return primaryColor;
      default:
        return Colors.purple;
    }
  }

  String getTypeString(int type) {
    switch (type) {
      case 0:
        return "Service Consumer";
      case 1:
        return "Service Producer";
      default:
        return "Both";
    }
  }
}

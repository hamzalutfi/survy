import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wego/features/auth/stuff/auth_services.dart';
import 'package:wego/features/main_page/main_screen.dart';
import 'package:wego/features/verification_screen.dart';
import 'package:wego/utils/constants/shared_keys.dart';
import 'package:wego/utils/mixin/flush_bar_mixin.dart';
import '../../../entities/user_entity.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/widgets/auth_button.dart';
import '../../../utils/widgets/background_widget.dart';
import '../../../utils/widgets/input_text_field.dart';
import '../../verify_account/verify_account_page.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final int type;

  LoginScreen(this.type);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FlushBarMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool isRegistering = false;
  bool errorEmailValidation = false;
  bool errorPasswordValidation = false;

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
    return Hero(
      tag: widget.type == 0
          ? "Service Consumer"
          : widget.type == 2
              ? "Both"
              : "Service Producer",
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(),
        ),
        body: Stack(
          children: [
            const BackgroundWidget(),
            Padding(
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.08,
                    ),
                    Row(
                      children: [
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
                          children: const [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28,
                                color: lightColor,
                              ),
                            ),
                            Text(
                              'Hello,welcome back!',
                              style: TextStyle(
                                  fontSize: 18, color: textFieldColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.1,
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
                      color: textFieldColor,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    InputTextField(
                      onChanged: (val) {
                        setState(() {
                          errorPasswordValidation = false;
                        });
                      },
                      controller: _passwordController,
                      inputType: TextInputType.visiblePassword,
                      obscureText: true,
                      hintText: 'Password...',
                      errorText: 'Invalid input!',
                      showError: errorPasswordValidation,
                      color: textFieldColor,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Do you forget your password?',
                          style: TextStyle(
                            color: lightColor,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerificationScreen(),
                                ),
                              );
                            },
                            child: const Text('Rest'))
                      ],
                    ),
                    SizedBox(
                      height: height * 0.12,
                    ),
                    Column(
                      children: [
                        AuthButton(
                            onPressed: () async {
                              _signInFunc();
                            },
                            text: 'GO!',
                            isLoading: isRegistering),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'you don\'t have an account?',
                              style: TextStyle(
                                color: lightColor,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterScreen(widget.type),
                                    ),
                                  );
                                },
                                child: const Text('Register'))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signInFunc() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        errorEmailValidation = true;
      });
    } else if (_passwordController.text.trim().isEmpty) {
      setState(() {
        errorPasswordValidation = true;
      });
    } else {
      setState(() {
        isRegistering = true;
      });
      var result =
          await _auth.signIn(_emailController.text, _passwordController.text);
      if (result is User) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(result.uid)
            .get()
            .then((value) {
          UserEntity userEntity = UserEntity.fromJson({
            'firstName': value['firstName'],
            'lastName': value['lastName'],
            'email': value['email'],
            'uid': result.uid,
            'type': value['type'],
            'services': (value['services'] as List<dynamic>)
                .map<String>((service) => service)
                .toList(),
            'locations': (value['locations'] as List<dynamic>)
                .map<String>((service) => service)
                .toList(),
            'accountStatus': value['accountStatus'],
            'profileURL': value['profileURL']
          });
          saveUserInfo(userEntity);
        });
        setState(() {
          isRegistering = false;
        });
      } else if (result.toString().trim().isNotEmpty) {
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

  saveUserInfo(UserEntity user) async {
    print("----> user = ${user.toString()}");
    sharedPreferences.setString(SharedKeys.UID, user.token);
    sharedPreferences.setString(SharedKeys.EMAIL, user.email);
    sharedPreferences.setString(SharedKeys.FIRST_NAME, user.firstName);
    sharedPreferences.setString(SharedKeys.LAST_NAME, user.lastName);
    sharedPreferences.setBool(SharedKeys.IS_LOGGED_IN, true);
    sharedPreferences.setString(SharedKeys.SERVICES_TYPE, SharedKeys.encode(user.servicesType));
    sharedPreferences.setString(SharedKeys.LOCATIONS, SharedKeys.encode(user.locations));
    sharedPreferences.setString(SharedKeys.PROFILE_URL, user.profileURL);
    sharedPreferences.setString(SharedKeys.ACCOUNT_STATUS, user.accountStatus);
    sharedPreferences.setInt(SharedKeys.TYPE, widget.type);
    if(user.accountStatus == "verified") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(user)),
              (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => VerifyAccountPage(user)),
              (route) => false);
    }

    // final String servicesSP = await prefs.getString('musics_key');
    //
    // final List<String> services = SharedKeys.decode(servicesSP);
  }
}

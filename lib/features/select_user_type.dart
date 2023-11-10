import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:wego/features/auth/pages/login_screen.dart';
import 'package:wego/utils/widgets/background_widget.dart';

import '../utils/constants/colors.dart';

class SelectUserTypePage extends StatefulWidget {
  const SelectUserTypePage({Key? key}) : super(key: key);

  @override
  State<SelectUserTypePage> createState() => _SelectUserTypePageState();
}

class _SelectUserTypePageState extends State<SelectUserTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "SELECT USER TYPE",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                const SizedBox(
                  height: 40.0,
                ),

                getUserTypeWidget(0),
                const SizedBox(
                  height: 20.0,
                ),
                getUserTypeWidget(1),
                const SizedBox(
                  height: 20.0,
                ),
                getUserTypeWidget(2),
                /*Text(
                  'Wego',
                  style: TextStyle(
                    fontSize: 28,
                    color: lightColor,
                  ),
                ),
                const SizedBox(height: 8.0,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'All the services in one place!',
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],

                    totalRepeatCount: 5,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                )*/
                // AnimatedTextKit(
                //   animatedTexts: [
                //     FadeAnimatedText(
                //       'All the services in one place!',
                //       textStyle: const TextStyle(
                //           fontSize: 32.0, fontWeight: FontWeight.bold),
                //     ),
                //     ScaleAnimatedText(
                //       'Try now, it\'s your time to try!',
                //       textStyle: const TextStyle(fontSize: 70.0),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getUserTypeWidget(int type) {
    return Hero(
      tag: type == 0
          ? "Service Consumer"
          : type == 2
              ? "Both"
              : "Service Producer",
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.black.withOpacity(0.7))),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginScreen(type)));
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.10,
                width: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                  type == 0
                      ? 'assets/images/icons/buyer1.png'
                      : type == 2
                          ? "assets/images/icons/best-seller.png"
                          : 'assets/images/icons/seller.png',
                ))),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: Text(
                      type == 0
                          ? "Do you have service to sell?"
                          : type == 2
                              ? "Do you have service to offer & sell (both)?"
                              : "Do you have service to offer?",
                      style:
                          const TextStyle(color: lightColor, fontSize: 18.0)),
                ),
                const SizedBox(height: 4),
                Text(
                    type == 0
                        ? "Let’s go..."
                        : type == 2
                            ? "Go harder..."
                            : "Go ahead...",
                    style:
                        const TextStyle(color: subLightColor, fontSize: 16.0)),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

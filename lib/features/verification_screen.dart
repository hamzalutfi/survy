import 'package:flutter/material.dart';
import 'package:wego/utils/widgets/auth_button.dart';
import 'package:wego/utils/widgets/background_widget.dart';
import 'package:wego/utils/widgets/input_text_field.dart';
import '../utils/constants/colors.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({Key? key}) : super(key: key);
  final TextEditingController _verificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: width * 0.1,
                        height: height * 0.1,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightColor,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/icons/left-arrow.png",
                            width: width * 0.04,
                            height: width * 0.04,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Verification',
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Please verify your email address!',
                          style: TextStyle(fontSize: 18, color: subLightColor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                InputTextField(
                  onChanged: (val) {},
                  controller: _verificationController,
                  inputType: TextInputType.number,
                  hintText: 'Enter verification code...',
                ),
                const Spacer(),
                AuthButton(onPressed: () {}, text: 'Verify!'),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

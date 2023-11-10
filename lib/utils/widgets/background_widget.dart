import 'package:flutter/material.dart';

import '../../colors.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Transform.scale(
            scale: 1.25,
            child: Image.asset(
              "assets/images/1.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              scale: 0.1,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height ,
          color: Colors.black.withOpacity(0.45),
        )
      ],
    );
  }
}

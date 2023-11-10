import 'package:flutter/material.dart';

class ImageLoaderWidget extends StatelessWidget {
  final String networkUrl;

  ImageLoaderWidget(this.networkUrl);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      networkUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}

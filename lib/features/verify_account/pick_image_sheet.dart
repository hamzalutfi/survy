import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wego/colors.dart';

class PickImageSheet extends StatefulWidget {
  final Function(File?) onSelectImage;

  PickImageSheet({required this.onSelectImage});

  @override
  State<PickImageSheet> createState() => _PickImageSheetState();
}

class _PickImageSheetState extends State<PickImageSheet> {
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
          minChildSize: 0.2,
          maxChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
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
                        child: Center(
                            child: Text(
                      "From Where?",
                      style: TextStyle(color: subLightColor, fontSize: 22),
                    ))),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 10,
                    )),
                    SliverToBoxAdapter(
                      child: ListTile(
                        title: Text("Camera",
                            style:
                                TextStyle(color: subLightColor, fontSize: 20)),
                        trailing:
                            Icon(Icons.camera_enhance, color: subLightColor),
                        onTap: () {
                          uploadImageFromCamera().then((value) {
                            widget.onSelectImage(value);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: ListTile(
                        title: Text("Gallery",
                            style:
                                TextStyle(color: subLightColor, fontSize: 20)),
                        trailing: Icon(Icons.camera, color: subLightColor),
                        onTap: () {
                          uploadImageFromGallery().then((value) {
                            widget.onSelectImage(value);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Future uploadImageFromGallery() async {
    File? file;
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 512, maxWidth: 512);
    if (image == null) return;

    return File(image.path);
  }

  Future uploadImageFromCamera() async {
    File? file;
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 512, maxHeight: 512);
    if (image == null) return;

    return File(image.path);
  }
}

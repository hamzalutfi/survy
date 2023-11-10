import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wego/utils/libs/flush_bar/stuff/flushbar.dart';

mixin FlushBarMixin {
  void exceptionFlushBar(
      {String? message,
      Function? onHidden,
      BuildContext? context,
      Function(FlushbarStatus)? onChangeStatus,
      Duration? duration,
        FlushbarPosition flushbarPosition = FlushbarPosition.BOTTOM}) {
    Flushbar(
      icon: Icon(
        Icons.info,
        color: Colors.red,
      ),
      onStatusChanged: (status) {
        onChangeStatus!(status!);
        print(status.toString());
      },
      flushbarPosition: flushbarPosition,
      margin: EdgeInsets.all(12.0),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
      message: message,
      duration: duration == null ? Duration(milliseconds: 1000) : duration,
    ).show(context!).then((value) {
      onHidden!();
    });
  }

  void doneFlushBar(
      {String? title,
      String? message,
      Function? onHidden,
      BuildContext? context,
      required Color backgroundColor,
      Function(FlushbarStatus)? onChangeStatus,
      Duration? duration,
        FlushbarPosition flushbarPosition = FlushbarPosition.BOTTOM}) {
    Flushbar(
      backgroundColor: backgroundColor,
      icon: Icon(
        Icons.done,
        color: Colors.white,
      ),
      onStatusChanged: (status) {
        onChangeStatus!(status!);
        print(status.toString());
      },
      title: title,
      margin: EdgeInsets.all(12.0),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      message: message,
      flushbarPosition: flushbarPosition,
      duration: duration == null ? Duration(milliseconds: 1000) : duration,
    ).show(context!).then((value) {
      onHidden!();
    });
  }
}

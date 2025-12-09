import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlert {
  static void showCustomAlert(BuildContext context, Widget contentWidget,
      {Function()? dismiss}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (context) {
          return UnconstrainedBox(
            child: contentWidget,
          );
        }).then((value) => {
          if (dismiss != null) {dismiss()}
        });
  }

  static void showCustomBackAlert(BuildContext context, Widget contentWidget) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return contentWidget;
      },
    );
  }
}

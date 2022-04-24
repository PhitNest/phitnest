import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:phitnest/constants/constants.dart';

/// This class is used to show modular dialog boxes
class DialogUtils {
  //helper method to show progress
  static late ProgressDialog progressDialog;

  static showProgress(
      BuildContext context, String message, bool isDismissible) async {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: isDismissible);
    progressDialog.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: Color(COLOR_PRIMARY),
        progressWidget: Container(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
              backgroundColor: Colors.white,
            )),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));

    await progressDialog.show();
  }

  static updateProgress(String message) {
    progressDialog.update(message: message);
  }

  static hideProgress() async {
    await progressDialog.hide();
  }

  //helper method to show alert dialog
  static showAlertDialog(BuildContext context, String title, String content) {
    // set up the AlertDialog
    Widget okButton = TextButton(
      child: Text('OK'.tr()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    if (Platform.isIOS) {
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}

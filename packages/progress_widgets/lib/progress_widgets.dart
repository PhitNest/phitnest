import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

late ProgressDialog _progressDialog;
late int _color;

class ProgressWidget {
  static initialize(int primaryColor) {
    _color = primaryColor;
  }
}

showProgressUntil(BuildContext context, String message,
    Future<dynamic>? Function() showUntil) async {
  await showProgress(context, message, false);
  dynamic retVal = await showUntil();
  await hideProgress();
  return retVal;
}

showProgress(BuildContext context, String message, bool isDismissible) async {
  _progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  _progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Color(_color),
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(Color(_color)),
            backgroundColor: Colors.white,
          )),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));

  await _progressDialog.show();
}

updateProgress(String message) {
  _progressDialog.update(message: message);
}

hideProgress() async {
  await _progressDialog.hide();
}

//helper method to show alert dialog
showAlertDialog(BuildContext context, String title, String content) {
  // set up the AlertDialog
  Widget okButton = TextButton(
    child: Text('OK'),
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

late ProgressDialog _progressDialog;
late Color _color;

class ProgressWidget {
  static initialize(Color primaryColor) {
    _color = primaryColor;
  }
}

showProgressUntil(
    {required BuildContext context,
    required String message,
    required Future? Function() showUntil,
    Widget? spinner,
    Function(dynamic result)? onDone}) async {
  await showProgress(context, message, false, spinner: spinner);
  dynamic retVal = await showUntil();
  await hideProgress();
  if (onDone != null) {
    onDone(retVal);
  }
  return retVal;
}

/// Shows a confirmation message and returns true if the confirm button is pressed.
Future<bool> showConfirmWidget(
    BuildContext context, String title, String message) async {
  Widget confirmButton = TextButton(
    child: Text('Confirm'),
    onPressed: () => Navigator.pop(context, true),
  );
  Widget cancelButton = TextButton(
    child: Text('Cancel'),
    onPressed: () => Navigator.pop(context, false),
  );

  if (Platform.isIOS) {
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );

    // show the dialog
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } else {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );

    // show the dialog
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

showProgress(BuildContext context, String message, bool isDismissible,
    {Widget? spinner}) async {
  _progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  _progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: _color,
      progressWidget: spinner ??
          Container(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(_color),
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

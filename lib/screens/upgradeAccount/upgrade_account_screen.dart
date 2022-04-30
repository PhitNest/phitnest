import 'package:flutter/material.dart';
import 'package:display/display_utils.dart';

import 'provider/upgrade_account_provider.dart';

class UpgradeAccount extends StatelessWidget {
  UpgradeAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpgradeAccountProvider(
        builder: (context, user, model, functions, child) => Container(
            height: MediaQuery.of(context).size.height * .85,
            decoration: BoxDecoration(
              color: DisplayUtils.isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: functions.upgradeAccount()));
  }
}

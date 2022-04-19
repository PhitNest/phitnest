import 'package:phitnest/firebase_options.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/models/models.dart';

import 'package:phitnest/widgets/redirectorWidget/redirector_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import 'app.dart';
import 'locator.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ProgressWidget.initialize(COLOR_PRIMARY);
  setupLocator();
  runApp(
    EasyLocalization(
            builder: (context, child) => const PhitnestApp())),
}

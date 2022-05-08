import 'package:flutter/material.dart';

import '../models.dart';

class ProfileModel extends BaseModel {
  List images = [];
  List pages = [];
  List<Widget> gridPages = [];
  PageController controller = PageController();
}

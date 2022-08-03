import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../../screens.dart';
import '../../models/home_model.dart';
import '../../views/home_view.dart';

class HeatmapProvider extends ScreenProvider<HeatmapModel, HeatmapView> {
  const HeatmapProvider({
    Key? key,
  }) : super(key: key);

  @override
  Future<bool> init(BuildContext context, HeatmapModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.userLocationListener = Provider.of<HomeModel>(context, listen: false)
        .userLocationStream
        .listen((latlong) {
      if (latlong != null) {
        // Update map
      }
    });

    return true;
  }

  @override
  HeatmapView build(BuildContext context, HeatmapModel model) => HeatmapView();

  @override
  HeatmapModel createModel() => HeatmapModel();
}

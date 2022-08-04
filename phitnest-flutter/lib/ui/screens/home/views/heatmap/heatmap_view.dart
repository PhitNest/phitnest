import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../common/textStyles/text_styles.dart';
import '../../../../common/widgets/widgets.dart';
import '../../../screen_view.dart';

class HeatmapView extends ScreenView {
  final LatLng? userPosition;
  final MapController? mapController;
  const HeatmapView({Key? key, this.userPosition, this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: FlutterMap(
          options: MapOptions(
              keepAlive: true,
              center: userPosition,
              zoom: 8,
              controller: mapController),
          layers: userPosition != null
              ? [
                  TileLayerOptions(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.phitnest.map',
                  ),
                  MarkerLayerOptions(markers: [
                    Marker(
                        point: userPosition!,
                        width: 120,
                        height: 120,
                        builder: (context) =>
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                "Your location",
                                style: BodyTextStyle(size: TextSize.MEDIUM),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 8.0,
                              )
                            ]))
                  ]),
                ]
              : []));
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../common/textStyles/text_styles.dart';
import '../../../screen_view.dart';

class HeatmapView extends ScreenView {
  final LatLng? userPosition;
  final MapController? mapController;
  const HeatmapView({Key? key, this.userPosition, this.mapController})
      : super(key: key);

  Marker get userMarker => Marker(
      point: userPosition!,
      width: 120,
      height: 120,
      builder: (context) => Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              "Your location",
              style: BodyTextStyle(size: TextSize.MEDIUM),
            ),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 8.0,
            )
          ]));

  static const double boundarySize = 0.25;

  LatLng get swBound => LatLng(max(userPosition!.latitude - boundarySize, -90),
      max(userPosition!.longitude - boundarySize, -180));

  LatLng get neBound => LatLng(min(userPosition!.latitude + boundarySize, 90),
      min(userPosition!.longitude + boundarySize, 180));

  @override
  Widget build(BuildContext context) => Scaffold(
          body: FlutterMap(
              options: MapOptions(
                  keepAlive: true,
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                  center: userPosition,
                  swPanBoundary: swBound,
                  nePanBoundary: neBound,
                  slideOnBoundaries: true,
                  zoom: 12,
                  minZoom: 10,
                  maxZoom: 15,
                  controller: mapController),
              layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.phitnest.map',
            ),
            MarkerLayerOptions(markers: [
              ...userPosition != null ? [userMarker] : []
            ]),
          ]));
}

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DevicePreviewProvider extends StatelessWidget {
  /// A callback for building the app widget.
  final Widget Function(BuildContext context, bool usingPreview) builder;

  /// A wrapper around [DevicePreview] that allows to enable it only for a device specified in the .env file.
  const DevicePreviewProvider({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceInfo? device = <DeviceInfo?>[...Devices.all].firstWhere(
      (device) =>
          dotenv.get("DEVICE", fallback: "null").toLowerCase() ==
          device!.name.toLowerCase(),
      orElse: () => null,
    );
    return DevicePreview(
      defaultDevice: device,
      enabled: device != null,
      isToolbarVisible: true,
      builder: (context) => builder(context, device != null),
    );
  }
}

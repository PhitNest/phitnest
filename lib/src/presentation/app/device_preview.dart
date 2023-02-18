part of app;

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
          dotenv.get("DEVICE").toLowerCase() == device!.name.toLowerCase(),
      orElse: () => null,
    );
    return DevicePreview(
      defaultDevice: device,
      enabled: device != null ? true : false,
      isToolbarVisible: true,
      builder: (context) => builder(context, device != null),
    );
  }
}

import 'package:get_ip_address/get_ip_address.dart';

/// The authentication service will be responsible for getting user ip.
Future<String> get userIP async =>
    (await IpAddress(type: RequestType.json).getIpAddress())['ip'];

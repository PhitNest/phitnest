import '../requests.dart';

class SignOutRequest extends Request {
  static const kEmpty = SignOutRequest(allDevices: false);

  final bool allDevices;

  const SignOutRequest({
    required this.allDevices,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'allDevices': allDevices,
      };

  @override
  List<Object?> get props => [allDevices];
}

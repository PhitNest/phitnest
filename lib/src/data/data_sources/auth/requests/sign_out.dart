import '../../../../domain/entities/entity.dart';

class SignOutRequest extends Entity<SignOutRequest> {
  static const kEmpty = SignOutRequest(allDevices: false);

  final bool allDevices;

  const SignOutRequest({
    required this.allDevices,
  }) : super();

  @override
  SignOutRequest fromJson(Map<String, dynamic> json) => SignOutRequest(
        allDevices: json['allDevices'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'allDevices': allDevices,
      };

  @override
  List<Object?> get props => [allDevices];
}

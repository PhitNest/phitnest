import '../../../../domain/entities/entities.dart';

class DenyFriendRequestRequest extends Entity<DenyFriendRequestRequest> {
  static const kEmpty = DenyFriendRequestRequest(
    senderCognitoId: "",
  );

  final String senderCognitoId;

  const DenyFriendRequestRequest({
    required this.senderCognitoId,
  }) : super();

  @override
  DenyFriendRequestRequest fromJson(Map<String, dynamic> json) =>
      DenyFriendRequestRequest(
        senderCognitoId: json['senderCognitoId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'senderCognitoId': senderCognitoId,
      };

  @override
  List<Object?> get props => [senderCognitoId];
}

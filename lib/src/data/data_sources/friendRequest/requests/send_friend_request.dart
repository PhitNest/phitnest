import '../../../../domain/entities/entities.dart';

class SendFriendRequestRequest extends Entity<SendFriendRequestRequest> {
  static const kEmpty = SendFriendRequestRequest(
    recipientCognitoId: "",
  );

  final String recipientCognitoId;

  const SendFriendRequestRequest({
    required this.recipientCognitoId,
  }) : super();

  @override
  SendFriendRequestRequest fromJson(Map<String, dynamic> json) =>
      SendFriendRequestRequest(
        recipientCognitoId: json['recipientCognitoId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'recipientCognitoId': recipientCognitoId,
      };

  @override
  List<Object?> get props => [recipientCognitoId];
}

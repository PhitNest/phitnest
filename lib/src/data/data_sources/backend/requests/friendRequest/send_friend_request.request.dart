import '../requests.dart';

class SendFriendRequest extends Request {
  final String recipientCognitoId;

  const SendFriendRequest({
    required this.recipientCognitoId,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'recipientCognitoId': recipientCognitoId,
      };

  @override
  List<Object?> get props => [recipientCognitoId];
}

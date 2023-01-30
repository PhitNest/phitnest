import '../requests.dart';

class DenyFriendRequest extends Request {
  final String senderCognitoId;

  const DenyFriendRequest({
    required this.senderCognitoId,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'senderCognitoId': senderCognitoId,
      };

  @override
  List<Object?> get props => [senderCognitoId];
}

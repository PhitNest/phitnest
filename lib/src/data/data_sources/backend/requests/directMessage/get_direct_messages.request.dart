import '../requests.dart';

class GetDirectMessagesRequest extends Request {
  final String friendCognitoId;

  const GetDirectMessagesRequest({
    required this.friendCognitoId,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'friendCognitoId': friendCognitoId,
      };

  @override
  List<Object?> get props => [friendCognitoId];
}

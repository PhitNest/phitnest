import '../../../../domain/entities/entities.dart';

class GetDirectMessagesRequest extends Entity<GetDirectMessagesRequest> {
  static const kEmpty = GetDirectMessagesRequest(
    friendCognitoId: "",
  );

  final String friendCognitoId;

  const GetDirectMessagesRequest({
    required this.friendCognitoId,
  }) : super();

  @override
  GetDirectMessagesRequest fromJson(Map<String, dynamic> json) =>
      GetDirectMessagesRequest(
        friendCognitoId: json['friendCognitoId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'friendCognitoId': friendCognitoId,
      };

  @override
  List<Object?> get props => [friendCognitoId];
}

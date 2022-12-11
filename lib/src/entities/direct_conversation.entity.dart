import 'package:equatable/equatable.dart';

class DirectConversationEntity extends Equatable {
  final String id;
  final List<String> userCognitoIds;

  const DirectConversationEntity({
    required this.id,
    required this.userCognitoIds,
  }) : super();

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userCognitoIds": userCognitoIds,
      };

  factory DirectConversationEntity.fromJson(Map<String, dynamic> json) =>
      DirectConversationEntity(
        id: json["_id"],
        userCognitoIds: List<String>.from(json["userCognitoIds"]),
      );

  @override
  List<Object?> get props => [id, userCognitoIds];
}

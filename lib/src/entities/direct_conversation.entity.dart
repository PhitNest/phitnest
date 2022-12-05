import 'package:equatable/equatable.dart';

class DirectConversationEntity extends Equatable {
  final String id;
  final List<String> userCognitoIds;

  const DirectConversationEntity({
    required this.id,
    required this.userCognitoIds,
  }) : super();

  @override
  List<Object?> get props => [id, userCognitoIds];
}

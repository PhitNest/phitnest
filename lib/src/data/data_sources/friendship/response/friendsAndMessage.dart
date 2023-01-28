import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../domain/entities/friendship.entity.dart';

class FriendsAndMessagesResponse extends Equatable {
  final PopulatedFriendshipEntity friendship;
  final DirectMessageEntity? message;

  FriendsAndMessagesResponse({
    required this.friendship,
    required this.message,
  }) : super();

  factory FriendsAndMessagesResponse.fromJson(Map<String, dynamic> json) =>
      FriendsAndMessagesResponse(
        friendship: PopulatedFriendshipEntity.fromJson(json['friendship']),
        message: DirectMessageEntity.fromJson(json['message']),
      );

  @override
  List<Object?> get props => [friendship, message];
}

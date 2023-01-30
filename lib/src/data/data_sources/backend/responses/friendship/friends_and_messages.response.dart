import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class FriendsAndMessagesResponseParser
    extends Parser<FriendsAndMessagesResponse> {
  const FriendsAndMessagesResponseParser() : super();

  @override
  FriendsAndMessagesResponse fromJson(Map<String, dynamic> json) =>
      FriendsAndMessagesResponse(
        friendship: PopulatedFriendshipParser().fromJson(json['friendship']),
        message: json.containsKey('message')
            ? DirectMessageParser().fromJson(json['message'])
            : null,
      );
}

class FriendsAndMessagesResponse extends Equatable {
  final PopulatedFriendshipEntity friendship;
  final DirectMessageEntity? message;

  FriendsAndMessagesResponse({
    required this.friendship,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [friendship, message];
}

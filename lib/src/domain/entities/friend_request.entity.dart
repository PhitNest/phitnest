import 'entities.dart';

class FriendRequestEntity extends Entity<FriendRequestEntity> {
  static final kEmpty = FriendRequestEntity(
    id: '',
    createdAt: DateTime.now(),
    denied: false,
    fromCognitoId: '',
    toCognitoId: '',
  );

  final String id;
  final String fromCognitoId;
  final String toCognitoId;
  final bool denied;
  final DateTime createdAt;

  FriendRequestEntity({
    required this.id,
    required this.createdAt,
    required this.denied,
    required this.fromCognitoId,
    required this.toCognitoId,
  }) : super();

  @override
  FriendRequestEntity fromJson(Map<String, dynamic> json) =>
      FriendRequestEntity(
        id: json['_id'],
        createdAt: json['createdAt'],
        denied: json['denied'],
        fromCognitoId: json['fromCognitoId'],
        toCognitoId: json['toCognitoId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'createdAt': createdAt,
        'denied': denied,
        'fromCognitoId': fromCognitoId,
        'toCognitoId': toCognitoId,
      };

  @override
  List<Object?> get props => [
        id,
        createdAt,
        denied,
        fromCognitoId,
        toCognitoId,
      ];
}

class PopulatedFriendRequestEntity extends FriendRequestEntity {
  static final kEmpty = PopulatedFriendRequestEntity(
    id: '',
    createdAt: DateTime.now(),
    denied: false,
    fromCognitoId: '',
    toCognitoId: '',
    fromUser: PublicUserEntity.kEmpty,
  );

  final PublicUserEntity fromUser;

  PopulatedFriendRequestEntity({
    required super.id,
    required super.createdAt,
    required super.denied,
    required super.fromCognitoId,
    required super.toCognitoId,
    required this.fromUser,
  }) : super();

  @override
  PopulatedFriendRequestEntity fromJson(Map<String, dynamic> json) =>
      PopulatedFriendRequestEntity(
        id: json['_id'],
        createdAt: json['createdAt'],
        denied: json['denied'],
        fromCognitoId: json['fromCognitoId'],
        toCognitoId: json['toCognitoId'],
        fromUser: Entity.jsonFactory((json['fromUser'])),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'fromUser': fromUser.toJson(),
      };

  @override
  List<Object?> get props => [
        super.props,
        fromUser,
      ];
}

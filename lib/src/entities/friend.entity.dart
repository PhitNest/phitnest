import 'entities.dart';

class FriendEntity extends PublicUserEntity {
  final DateTime since;

  const FriendEntity({
    required super.id,
    required super.cognitoId,
    required super.firstName,
    required super.lastName,
    required super.gymId,
    required this.since,
  }) : super();

  factory FriendEntity.fromJson(Map<String, dynamic> json) => FriendEntity(
        id: json['_id'],
        cognitoId: json['cognitoId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gymId: json['gymId'],
        since: DateTime.parse(json['since']),
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'since': since.toIso8601String(),
      };

  @override
  List<Object?> get props => [...super.props, since];
}

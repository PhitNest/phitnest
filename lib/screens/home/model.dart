part of 'home.dart';

final class UserExplore extends JsonSerializable {
  final String id;
  final String firstName;
  final String lastName;
  final String identityId;

  const UserExplore({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.identityId,
  }) : super();

  factory UserExplore.fromJson(Map<String, dynamic> json) => switch (json) {
        ({
          'id': final String id,
          'firstName': final String firstName,
          'lastName': final String lastName,
          'identityId': final String identityId,
        }) =>
          UserExplore(
            id: id,
            firstName: firstName,
            lastName: lastName,
            identityId: identityId,
          ),
        _ => throw FormatException(
            'Invalid JSON for UserExplore',
            json,
          ),
      };

  @override
  List<Object?> get props => [id, firstName, lastName, identityId];

  @override
  Map<String, Serializable> toJson() => {
        'id': Serializable.string(id),
        'firstName': Serializable.string(firstName),
        'lastName': Serializable.string(lastName),
        'identityId': Serializable.string(identityId),
      };
}

final class UserWithProfilePicture extends UserExplore {
  final Image profilePicture;

  const UserWithProfilePicture({
    required String id,
    required String firstName,
    required String lastName,
    required String identityId,
    required this.profilePicture,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          identityId: identityId,
        );

  @override
  List<Object?> get props => [super.props, profilePicture];
}

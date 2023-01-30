import '../../backend.dart';

class UserExploreRequest extends Request {
  final String gymId;

  const UserExploreRequest({
    required this.gymId,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'gymId': gymId,
      };

  @override
  List<Object?> get props => [gymId];
}

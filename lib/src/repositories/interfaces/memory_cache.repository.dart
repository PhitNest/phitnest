import '../../entities/entities.dart';

abstract class IMemoryCacheRepository {
  UserEntity? get me;
  set me(UserEntity? me);
  set myGym(GymEntity? gym);
  GymEntity? get myGym;
  String? get accessToken;
  set accessToken(String? accessToken);
  String? get refreshToken;
  set refreshToken(String? refreshToken);
  String? get email;
  set email(String? email);
  String? get password;
  set password(String? password);
}

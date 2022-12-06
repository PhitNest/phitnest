import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';

class MemoryCacheRepository implements IMemoryCacheRepository {
  GymEntity? _myGym;
  String? _accessToken;
  String? _refreshToken;
  String? _email;
  String? _password;

  @override
  GymEntity? get myGym => _myGym;

  @override
  set myGym(GymEntity? gym) => _myGym = gym;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get email => _email;

  @override
  String? get password => _password;

  @override
  String? get refreshToken => _refreshToken;

  @override
  set accessToken(String? accessToken) => _accessToken = accessToken;

  @override
  set email(String? email) => _email = email;

  @override
  set password(String? password) => _password = password;

  @override
  set refreshToken(String? refreshToken) => _refreshToken = refreshToken;
}
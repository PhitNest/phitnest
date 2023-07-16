part of 'cognito.dart';

Future<void> logout({
  required Session session,
}) async {
  await session.user.signOut();
}

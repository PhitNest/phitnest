import 'aws.dart';

Future<void> logout(Session session) => session.user.signOut();

Future<bool> deleteAccount(Session session) => session.user.deleteUser();

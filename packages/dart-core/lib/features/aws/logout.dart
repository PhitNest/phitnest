import 'aws.dart';

Future<void> logout(Session session) => session.user.signOut();

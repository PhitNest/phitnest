part of 'aws.dart';

Future<void> logout({required Session session}) => session.user.signOut();

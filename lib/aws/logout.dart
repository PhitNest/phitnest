part of 'aws.dart';

Future<void> logout(
    {required Session session, required SessionBloc sessionLoader}) async {
  await session.user.signOut();
  sessionLoader.add(const LoaderSetEvent(SessionReset()));
}

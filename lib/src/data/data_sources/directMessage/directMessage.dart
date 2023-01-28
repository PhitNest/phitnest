import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../adapters/adapters.dart';
import 'response/directMessage.dart';

abstract class DirectMessageDataSource {
  static Future<Either<List<DirectMessageResponse>, Failure>> getDirectMessages(
    String friendCognitoId,
  ) =>
      httpAdapter.request(
        Routes.getDirectMessages.instance,
        data: {
          'friendCognitoId': friendCognitoId,
        },
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => Right(Failures.invalidBackendResponse.instance),
            (list) => Left(
              list
                  .map(
                    (json) => DirectMessageResponse.fromJson(json),
                  )
                  .toList(),
            ),
          ),
          (failure) => Right(failure),
        ),
      );
}

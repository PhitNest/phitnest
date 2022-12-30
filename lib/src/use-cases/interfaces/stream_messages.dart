import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IStreamMessagesUseCase {
  Future<Either<Stream<MessageEntity>, Failure>> streamMessages();
}

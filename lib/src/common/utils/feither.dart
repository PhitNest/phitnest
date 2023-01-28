import 'package:dartz/dartz.dart';

import 'either3.dart';

typedef FEither<L, R> = Future<Either<L, R>>;

typedef FEither3<F, S, T> = Future<Either3<F, S, T>>;

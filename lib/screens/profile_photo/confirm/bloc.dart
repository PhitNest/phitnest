part of 'confirm.dart';

sealed class ConfirmPhotoResponse extends Equatable {
  const ConfirmPhotoResponse() : super();
}

final class ConfirmPhotoSuccess extends ConfirmPhotoResponse {
  const ConfirmPhotoSuccess() : super();

  @override
  List<Object?> get props => [];
}

final class ConfirmPhotoFailure extends ConfirmPhotoResponse {
  final Failure error;

  const ConfirmPhotoFailure({
    required this.error,
  }) : super();

  @override
  List<Object?> get props => [error];
}

final class ConfirmPhotoLostAuth extends ConfirmPhotoResponse {
  const ConfirmPhotoLostAuth() : super();

  @override
  List<Object?> get props => [];
}

typedef ConfirmPhotoBloc = LoaderBloc<void, ConfirmPhotoResponse>;
typedef ConfirmPhotoConsumer = LoaderConsumer<void, ConfirmPhotoResponse>;

extension on BuildContext {
  ConfirmPhotoBloc get confirmPhotoBloc => loader();
}

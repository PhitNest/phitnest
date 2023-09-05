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
  final String message;

  const ConfirmPhotoFailure({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}

typedef ConfirmPhotoBloc = AuthLoaderBloc<void, ConfirmPhotoResponse>;
typedef ConfirmPhotoConsumer = AuthLoaderConsumer<void, ConfirmPhotoResponse>;

extension on BuildContext {
  ConfirmPhotoBloc get confirmPhotoBloc => authLoader();
}

void _handleStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<ConfirmPhotoResponse>> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final data):
      switch (data) {
        case AuthLost(message: final message):
          StyledBanner.show(
            message: message,
            error: true,
          );
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute<void>(
              builder: (_) => const LoginPage(),
            ),
            (_) => false,
          );
        case AuthRes(data: final data):
          switch (data) {
            case ConfirmPhotoSuccess():
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute<void>(
                  builder: (_) => const HomePage(),
                ),
                (_) => false,
              );
            case ConfirmPhotoFailure(message: final error):
              StyledBanner.show(message: error, error: true);
          }
      }
    default:
  }
}

part of 'explore.dart';

void _handleExploreStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<List<UserExploreWithPicture>>>>
      loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
            default:
          }
        default:
      }
    default:
  }
}

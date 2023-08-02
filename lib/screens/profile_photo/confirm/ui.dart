part of 'confirm.dart';

final class ConfirmPhotoScreen extends StatelessWidget {
  final CroppedFile photo;
  final ApiInfo apiInfo;

  const ConfirmPhotoScreen({
    super.key,
    required this.photo,
    required this.apiInfo,
  }) : super();

  Future<ConfirmPhotoResponse> submit(BuildContext context) async {
    final session = await context.sessionLoader.session;
    if (session == null) {
      prettyLogger.e('Lost auth while confirming photo');
      return const ConfirmPhotoLostAuth();
    }
    final bytes = await photo.readAsBytes();
    final failure = await uploadProfilePicture(
      photo: ByteStream.fromBytes(bytes),
      length: bytes.length,
      session: session,
    );
    if (failure != null) {
      return ConfirmPhotoFailure(
        error: failure,
      );
    } else {
      return const ConfirmPhotoSuccess();
    }
  }

  void handleStateChanged(
      BuildContext context, LoaderState<ConfirmPhotoResponse> confirmState) {
    switch (confirmState) {
      case LoaderLoadedState(data: final failure):
        switch (failure) {
          case ConfirmPhotoLostAuth():
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => LoginScreen(
                  apiInfo: apiInfo,
                ),
              ),
              (_) => false,
            );
          case ConfirmPhotoSuccess():
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => HomeScreen(
                  apiInfo: apiInfo,
                ),
              ),
              (_) => false,
            );
          case ConfirmPhotoFailure(error: final error):
            StyledBanner.show(message: error.message, error: true);
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: BlocProvider(
            create: (_) => ConfirmPhotoBloc(
              load: (_) => submit(context),
            ),
            child: ConfirmPhotoConsumer(
              listener: handleStateChanged,
              builder: (context, confirmState) => SingleChildScrollView(
                child: Column(
                  children: [
                    Image.file(
                      File(photo.path),
                      height: 444.h,
                      width: double.infinity,
                    ),
                    56.verticalSpace,
                    ...switch (confirmState) {
                      LoaderLoadingState() => const [Loader()],
                      _ => [
                          ElevatedButton(
                            child: Text(
                              'CONFIRM',
                              style: theme.textTheme.bodySmall,
                            ),
                            onPressed: () => context.confirmPhotoBloc
                                .add(const LoaderLoadEvent(null)),
                          ),
                          12.verticalSpace,
                          StyledOutlineButton(
                            text: 'BACK',
                            onPress: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ]
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

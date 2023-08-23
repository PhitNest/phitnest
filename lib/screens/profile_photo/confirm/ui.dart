part of 'confirm.dart';

final class ConfirmPhotoScreen extends StatelessWidget {
  final CroppedFile photo;
  final ApiInfo apiInfo;

  const ConfirmPhotoScreen({
    super.key,
    required this.photo,
    required this.apiInfo,
  }) : super();

  Future<ConfirmPhotoResponse> submit(Session session) async {
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: BlocProvider(
            create: (_) => ConfirmPhotoBloc(
              load: (_, session) => submit(session),
            ),
            child: ConfirmPhotoConsumer(
              listener: (context, confirmState) {
                switch (confirmState) {
                  case LoaderLoadedState(data: final data):
                    switch (data) {
                      case AuthLost():
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (context) => LoginScreen(
                              apiInfo: apiInfo,
                            ),
                          ),
                          (_) => false,
                        );
                      case AuthRes(data: final data):
                        switch (data) {
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
                            StyledBanner.show(
                              message: error.message,
                              error: true,
                            );
                        }
                    }
                  default:
                }
              },
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
                            onPressed: () => context.confirmPhotoBloc.add(
                                LoaderLoadEvent((
                              data: null,
                              sessionLoader: context.sessionLoader
                            ))),
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

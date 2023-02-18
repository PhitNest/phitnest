part of verification_page;

class _LoadingPage extends _IBasePage {
  _LoadingPage({
    Key? key,
    required super.codeController,
    required super.headerText,
    required super.email,
  }) : super(
          key: key,
          onSubmit: () {},
          child: Column(
            children: [
              20.verticalSpace,
              CircularProgressIndicator(),
            ],
          ),
        );
}

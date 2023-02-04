part of verification_page;

class _LoadingPage extends _BasePage {
  _LoadingPage({
    Key? key,
    required super.codeController,
    required super.codeFocusNode,
    required super.headerText,
    required super.email,
  }) : super(
          key: key,
          onCompleted: () {},
          child: Column(
            children: [
              20.verticalSpace,
              CircularProgressIndicator(),
            ],
          ),
        );
}

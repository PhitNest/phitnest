part of verification_page;

class _InitialPage extends _BasePage {
  final VoidCallback onPressedResend;

  _InitialPage({
    Key? key,
    required super.codeController,
    required super.codeFocusNode,
    required super.onCompleted,
    required super.headerText,
    required super.email,
    required this.onPressedResend,
  }) : super(
          key: key,
          child: Column(
            children: [
              20.verticalSpace,
              StyledButton(
                text: 'SUBMIT',
                onPressed: onCompleted,
              ),
              Spacer(),
              StyledUnderlinedTextButton(
                onPressed: onPressedResend,
                text: 'RESEND CODE',
              ),
              37.verticalSpace,
            ],
          ),
        );
}

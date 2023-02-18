part of verification_page;

class _InitialPage extends _IBasePage {
  final VoidCallback onPressedResend;

  _InitialPage({
    Key? key,
    required super.codeController,
    required super.headerText,
    required super.email,
    required super.onSubmit,
    required this.onPressedResend,
  }) : super(
          key: key,
          child: Column(
            children: [
              20.verticalSpace,
              StyledButton(
                text: 'SUBMIT',
                onPressed: onSubmit,
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

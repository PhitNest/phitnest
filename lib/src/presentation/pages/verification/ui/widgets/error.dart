part of verification_page;

class _ErrorPage extends _BasePage {
  final VoidCallback onCompleted;
  final VoidCallback onPressedResend;
  final Failure error;

  _ErrorPage({
    Key? key,
    required super.codeController,
    required super.headerText,
    required super.email,
    required this.error,
    required this.onPressedResend,
    required this.onCompleted,
  }) : super(
          key: key,
          child: Column(
            children: [
              8.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  error.message,
                  style: theme.textTheme.labelLarge!
                      .copyWith(color: theme.errorColor),
                  textAlign: TextAlign.center,
                ),
              ),
              16.verticalSpace,
              StyledButton(
                text: 'RETRY',
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

part of verification_page;

class _IBasePage extends StatelessWidget {
  final String headerText;
  final VoidCallback onSubmit;
  final TextEditingController codeController;
  final String email;
  final Widget child;

  const _IBasePage({
    Key? key,
    required this.headerText,
    required this.child,
    required this.codeController,
    required this.email,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                StyledBackButton(),
                30.verticalSpace,
                Text(
                  headerText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                40.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Check $email for a verification code from us and enter it below",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                30.verticalSpace,
                StyledVerificationField(
                  controller: codeController,
                  onCompleted: (_) => onSubmit(),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
}

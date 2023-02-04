part of verification_page;

class _BasePage extends StatelessWidget {
  final String headerText;
  final Widget child;
  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final VoidCallback onCompleted;
  final String email;

  const _BasePage({
    Key? key,
    required this.headerText,
    required this.child,
    required this.onCompleted,
    required this.codeController,
    required this.codeFocusNode,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                40.verticalSpace,
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
                  focusNode: codeFocusNode,
                  onCompleted: (_) => onCompleted(),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
}

part of options_page;

class _InitialPage extends _BasePage {
  final VoidCallback onSignOut;

  _InitialPage({
    required super.user,
    required super.gym,
    required super.onEditProfilePicture,
    required this.onSignOut,
  }) : super(
          child: StyledUnderlinedTextButton(
            text: 'SIGN OUT',
            onPressed: onSignOut,
          ),
        );
}

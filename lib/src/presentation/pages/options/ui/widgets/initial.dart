part of options_page;

class _InitialPage extends _BasePage {
  final VoidCallback onSignOut;

  _InitialPage({
    required super.name,
    required super.address,
    required super.email,
    required super.profilePicUri,
    required this.onSignOut,
  }) : super(
          child: StyledButton(
            text: 'SIGN OUT',
            onPressed: onSignOut,
          ),
        );
}

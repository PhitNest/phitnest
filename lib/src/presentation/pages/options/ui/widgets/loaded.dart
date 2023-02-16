part of options_page;

class _InitialPage extends _IBasePage {
  final VoidCallback onSignOut;

  _InitialPage({
    required super.user,
    required super.gym,
    required super.onEditProfilePicture,
    required this.onSignOut,
  }) : super(
          showEdit: true,
          child: StyledUnderlinedTextButton(
            text: 'SIGN OUT',
            onPressed: onSignOut,
          ),
        );
}

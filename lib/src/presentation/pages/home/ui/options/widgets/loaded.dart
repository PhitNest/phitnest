part of home_page;

class _OptionsInitialPage extends _IOptionsBasePage {
  final VoidCallback onSignOut;

  _OptionsInitialPage({
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

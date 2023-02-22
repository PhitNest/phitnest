part of home_page;

class _OptionsLoadingPage extends _IOptionsBasePage {
  final VoidCallback onSignOut;

  _OptionsLoadingPage({
    required super.user,
    required super.gym,
    required this.onSignOut,
  }) : super(
          showEdit: false,
          onEditProfilePicture: () {},
          child: StyledUnderlinedTextButton(
            text: 'SIGN OUT',
            onPressed: onSignOut,
          ),
        );
}

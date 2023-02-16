part of options_page;

class _LoadingPage extends _IBasePage {
  final VoidCallback onSignOut;

  _LoadingPage({
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

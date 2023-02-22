part of home_page;

class _OptionsSignOutLoadingPage extends _IOptionsBasePage {
  _OptionsSignOutLoadingPage({
    required super.user,
    required super.gym,
  }) : super(
          child: const CircularProgressIndicator(),
          showEdit: false,
          onEditProfilePicture: () {},
        );
}

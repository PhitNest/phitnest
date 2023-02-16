part of options_page;

class _SignOutLoadingPage extends _IBasePage {
  _SignOutLoadingPage({
    required super.user,
    required super.gym,
  }) : super(
          child: const CircularProgressIndicator(),
          showEdit: false,
          onEditProfilePicture: () {},
        );
}

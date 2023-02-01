part of options_page;

class _LoadingPage extends _BasePage {
  _LoadingPage({
    required super.address,
    required super.email,
    required super.name,
    required super.profilePicUri,
  }) : super(child: CircularProgressIndicator());
}

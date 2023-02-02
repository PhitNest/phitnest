part of options_page;

class _LoadingPage extends _BasePage {
  const _LoadingPage({
    required super.user,
    required super.gym,
  }) : super(child: const CircularProgressIndicator());
}

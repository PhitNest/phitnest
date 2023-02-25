part of message;

class _LoadingPage extends _IBasePage {
  final String name;

  _LoadingPage({
    Key? key,
    required this.name,
  }) : super(
          key: key,
          child: Expanded(child: Center(child: CircularProgressIndicator())),
          name: name,
        );
}

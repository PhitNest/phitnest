part of message;

class _LoadingPage extends _IBasePage {
  final String name;

  _LoadingPage({
    Key? key,
    required super.controller,
    required super.focusNode,
    required super.onSend,
    required super.loading,
    required this.name,
  }) : super(
          key: key,
          child: Expanded(child: Center(child: CircularProgressIndicator())),
          name: name,
        );
}

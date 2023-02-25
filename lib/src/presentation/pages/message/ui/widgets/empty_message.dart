part of message;

class _EmptyMessagePage extends _IBasePage {
  final String name;

  _EmptyMessagePage({
    Key? key,
    required this.name,
  }) : super(
          key: key,
          name: name,
          child: Expanded(
            child: Center(
              child: Text(
                'Seems like you have no messages yet.',
                style: theme.textTheme.labelLarge,
              ),
            ),
          ),
        );
}

part of message;

class _MessageLoaded extends _IBasePage {
  final List<DirectMessageEntity>? message;
  final String name;

  _MessageLoaded({
    Key? key,
    required super.controller,
    required super.focusNode,
    required super.onSend,
    required super.loading,
    required this.message,
    required this.name,
  }) : super(
          key: key,
          name: name,
          child: Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: ClampingScrollPhysics(),
                    itemCount: message!.length,
                    itemBuilder: (context, index) => StyledMessageCard(
                      message: message[index].text,
                      sentByMe: message[index].senderCognitoId ==
                          Cache.user.user!.cognitoId,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}

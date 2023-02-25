part of message;

class _MessageLoaded extends _IBasePage {
  final String message;
  final bool sentByMe;
  final String name;

  _MessageLoaded({
    Key? key,
    required this.message,
    required this.sentByMe,
    required this.name,
  }) : super(
          key: key,
          name: name,
          child: Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    controller: ScrollController(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: ClampingScrollPhysics(),
                    itemCount: 15,
                    itemBuilder: (context, index) => StyledMessageCard(
                      message: message,
                      sentByMe: sentByMe,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}

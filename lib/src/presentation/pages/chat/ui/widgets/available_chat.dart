part of chat_page;

class _AvailableChatPage extends _BasePage {
  final List<FriendsAndMessagesResponse> messages;

  _AvailableChatPage({
    Key? key,
    required this.messages,
  }) : super(
          key: key,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                        '${messages[index].friendship.friend.firstName} ${messages[index].friendship.friend.lastName}'),
                    subtitle: Text(messages[index].message!.text),
                  ),
                  40.verticalSpace,
                ],
              );
            },
          ),
        );
}

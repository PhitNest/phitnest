part of chat_page;

class _AvailableChatPage extends _IChatPageBase {
  final List<FriendsAndMessagesResponse> messages;

  _AvailableChatPage({
    Key? key,
    required this.messages,
  }) : super(
          key: key,
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: ListView.builder(
                itemCount: messages.length * 50,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${messages[index % messages.length].friendship.friend.firstName} ${messages[index % messages.length].friendship.friend.lastName}',
                          style: theme.textTheme.headlineSmall,
                        ),
                        subtitle: Text(
                          messages[index % messages.length].message!.text,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      40.verticalSpace,
                    ],
                  );
                },
              ),
            ),
          ),
        );
}

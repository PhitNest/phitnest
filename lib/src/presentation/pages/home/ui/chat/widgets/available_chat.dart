part of home_page;

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
                itemCount: messages.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      tileColor: Color(0x84DFDFDF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      title: Text(
                        messages[index % messages.length]
                            .friendship
                            .friend
                            .fullName,
                        style: theme.textTheme.headlineSmall,
                      ),
                      subtitle: Text(
                        messages[index % messages.length].message!.text,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        );
}

part of home_page;

class _AvailableChatPage extends _IChatPageBase {
  final List<FriendsAndMessagesResponse> messages;
  final ValueChanged<FriendsAndMessagesResponse> onTap;

  _AvailableChatPage({
    Key? key,
    required this.messages,
    required this.onTap,
  }) : super(
          key: key,
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 16.h),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onTap: () => onTap(messages[index]),
                      tileColor: Color.fromARGB(49, 223, 223, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      title: Text(
                        messages[index]
                            .friendship
                            .notMe(Cache.user.user!.cognitoId)
                            .fullName,
                        style: theme.textTheme.headlineSmall,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          messages[index].message?.text ??
                              "Say hello to your new friend!",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Color(0xFF6B6B6B),
                          ),
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

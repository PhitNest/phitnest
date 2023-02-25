part of message;

class MessagePage extends StatelessWidget {
  final HomeBloc homeBloc;
  final PopulatedFriendshipEntity friendship;

  const MessagePage({
    Key? key,
    required this.homeBloc,
    required this.friendship,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: homeBloc,
        child: BlocConsumer<HomeBloc, IHomeState>(
          listener: (context, state) {},
          builder: (context, state) => StyledScaffold(
            body: Column(
              children: [
                Stack(
                  children: [
                    StyledBackButton(),
                    Container(
                      padding: EdgeInsets.only(top: 8.h),
                      alignment: Alignment.center,
                      child: Text(
                        'name',
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                  ],
                ),
                Expanded(
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
                          itemBuilder: (context, index) => _MessageCard(
                            message: 'messages[index].text',
                            sentByMe: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F7F7),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 9.h,
                      bottom: 18.h,
                      left: 14.w,
                      right: 14.w,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: TextEditingController(),
                            maxLines: 12,
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            onFieldSubmitted: (value) => {},
                            focusNode: FocusNode(),
                            decoration: InputDecoration(
                              hintText: 'Write a message...',
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.w),
                                borderSide: BorderSide(
                                  color: Color(0xFFEAE7E7),
                                  width: 1.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.w),
                                borderSide: BorderSide(
                                  color: Color(0xFFEAE7E7),
                                  width: 1.w,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 7.5.w,
                              ),
                              border: InputBorder.none,
                              fillColor: Color(0xFFFFFFFF),
                              filled: true,
                            ),
                          ),
                        ),
                        14.horizontalSpace,
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'SEND',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      );
}

part of message;

abstract class _IBasePage extends StatelessWidget {
  final String name;
  final Widget child;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool loading;

  const _IBasePage({
    Key? key,
    required this.child,
    required this.name,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            Stack(
              children: [
                StyledBackButton(),
                Container(
                  padding: EdgeInsets.only(top: 8.h),
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
            child,
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
                        controller: controller,
                        maxLines: 12,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted:
                            loading ? (_) {} : (value) => onSend(),
                        focusNode: focusNode,
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
                    loading
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(),
                          )
                        : TextButton(
                            onPressed: onSend,
                            child: Text(
                              'SEND',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            MediaQuery.of(context).viewInsets.bottom.verticalSpace,
          ],
        ),
      );
}

part of friends_page;

class _FriendRequestCard extends StatelessWidget {
  final PublicUserEntity user;
  final VoidCallback onAdd;
  final VoidCallback onIgnore;
  final bool loading;

  const _FriendRequestCard({
    Key? key,
    required this.user,
    required this.onAdd,
    required this.onIgnore,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 24.h,
          left: 24.w,
          right: 24.w,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            ...(loading
                ? [
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ]
                : [
                    TextButton(
                      key: key,
                      onPressed: onAdd,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFFE3E3)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        textStyle: MaterialStateProperty.all(
                            theme.textTheme.bodySmall!),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      child: Text('ADD'),
                    ),
                    12.horizontalSpace,
                    _LightButton(
                      onTap: onIgnore,
                      text: 'IGNORE',
                    ),
                  ]),
          ],
        ),
      );
}

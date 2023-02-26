part of friends_page;

class _FriendCard extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;
  final bool loading;

  const _FriendCard({
    Key? key,
    required this.name,
    required this.onRemove,
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
            Text(
              name,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            loading
                ? Padding(
                    padding: EdgeInsets.only(right: 28.w),
                    child: const CircularProgressIndicator())
                : _LightButton(
                    onTap: onRemove,
                    text: 'REMOVE',
                  ),
          ],
        ),
      );
}

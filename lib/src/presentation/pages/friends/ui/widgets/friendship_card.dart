part of friends_page;

class _FriendCard extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;

  const _FriendCard({
    Key? key,
    required this.name,
    required this.onRemove,
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
            _LightButton(
              onTap: onRemove,
              text: 'REMOVE',
            ),
          ],
        ),
      );
}

part of options_page;

abstract class _BasePage extends StatelessWidget {
  final String name;
  final String email;
  final String address;
  final String profilePicUri;
  final Widget child;

  const _BasePage({
    Key? key,
    required this.name,
    required this.email,
    required this.address,
    required this.profilePicUri,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.network(profilePicUri),
                Padding(
                  padding: EdgeInsets.only(
                    top: 32.h,
                    right: 24.w,
                  ),
                  child: Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.more_horiz_sharp,
                      color: Color(0xFFC11C1C),
                    ),
                  ),
                ),
              ],
            ),
            40.verticalSpace,
            Text(
              name,
              style: theme.textTheme.headlineLarge,
            ),
            32.verticalSpace,
            Text(
              email,
              style: theme.textTheme.labelLarge,
            ),
            Divider(),
            24.verticalSpace,
            Text(
              'Address',
              style: theme.textTheme.headlineLarge,
            ),
            Divider(),
            45.verticalSpace,
            child,
          ],
        ),
      );
}

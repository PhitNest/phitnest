part of friends;

class IBaseFriendsPage extends StatelessWidget {
  const IBaseFriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StyledBackButton(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StyledTextField(
                      hint: 'Search',
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(),
                    ),
                    8.verticalSpace,
                    Text(
                      'Friend Requests',
                      style: theme.textTheme.headlineMedium,
                    ),
                    23.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Erin-Michelle J.',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE3E3),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text('ADD'),
                              ),
                            ),
                            18.horizontalSpace,
                            Container(
                              width: 68.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                // color: Color(0xFFFFE3E3),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: Color(0xFFFFE3E3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text('IGNORE'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    23.verticalSpace,
                    Text(
                      'Your Friends',
                      style: theme.textTheme.headlineMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Erin-Michelle J.',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Container(
                          width: 68.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            // color: Color(0xFFFFE3E3),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Color(0xFFFFE3E3),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text('IGNORE'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

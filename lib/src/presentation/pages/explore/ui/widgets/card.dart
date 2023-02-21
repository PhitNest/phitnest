part of explore_page;

class _ExploreCard extends StatelessWidget {
  final String fullName;
  final String profilePictureUrl;
  final int? countdown;

  const _ExploreCard({
    required this.fullName,
    required this.profilePictureUrl,
    required this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 375.w,
                height: 333.h,
                child: CachedNetworkImage(imageUrl: profilePictureUrl),
              ),
              Container(
                padding: EdgeInsets.only(top: 40.h),
                alignment: Alignment.topCenter,
                child: countdown != null
                    ? Container(
                        width: 240.w,
                        height: 240.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 6.0,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 150.w,
                              height: 159.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 6.0,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    countdown.toString(),
                                    style: theme.textTheme.labelLarge!.copyWith(
                                      fontSize: 128.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
          30.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              height: 120.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/left_arrow.png',
                    width: 40.w,
                  ),
                  Container(
                    width: 240.w,
                    child: Text(
                      fullName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                      softWrap: true,
                    ),
                  ),
                  Image.asset(
                    'assets/images/right_arrow.png',
                    width: 40.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

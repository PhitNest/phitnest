part of home_page;

class _ExploreCard extends StatelessWidget {
  final ProfilePicturePublicUserEntity user;
  final int? countdown;

  const _ExploreCard({
    required this.user,
    required this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            children: [
              StyledNetworkProfilePicture(
                url: user.profilePictureUrl,
                cacheKey: Cache.profilePicture
                    .getUserProfilePictureImageCacheKey(user.id),
              ),
              Container(
                alignment: Alignment.center,
                width: 1.sw,
                height: 1.sw / kProfilePictureAspectRatio.aspectRatio,
                child: Visibility(
                  visible: countdown != null,
                  child: Container(
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
                  ),
                ),
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
                      user.fullName,
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

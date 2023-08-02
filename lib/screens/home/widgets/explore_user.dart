part of '../home.dart';

final class UserPage extends StatelessWidget {
  final UserWithProfilePicture user;
  final int? countdown;

  const UserPage({
    super.key,
    required this.user,
    required this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 444.h,
                width: 375.w,
                child: user.profilePicture,
              ),
              Positioned(
                bottom: 16.h,
                left: 16.w,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.h,
                right: 16.w,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          84.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  countdown != null
                      ? '$countdown...'
                      : 'Press & hold the logo to send a friend request',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      );
}

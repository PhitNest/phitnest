import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/backend/backend.dart';
import '../data/cache/cache.dart';
import '../common/theme.dart';
import '../domain/entities/entities.dart';
import 'pages/pages.dart';
import 'widgets/widgets.dart';

class _RedirectedLogin extends StatefulWidget {
  final bool shouldRedirect;
  final String? password;
  final String? email;

  const _RedirectedLogin({
    Key? key,
    required this.shouldRedirect,
    required this.email,
    required this.password,
  })  : assert((shouldRedirect && email != null && password != null) ||
            !shouldRedirect),
        super(key: key);

  @override
  _RedirectedLoginState createState() => _RedirectedLoginState();
}

class _RedirectedLoginState extends State<_RedirectedLogin> {
  var _disposed = false;

  @override
  void initState() {
    super.initState();
    if (widget.shouldRedirect) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (!_disposed)
            Navigator.of(context)
              ..push<LoginResponse>(
                CupertinoPageRoute(
                  builder: (context) => ConfirmEmailPage(
                    password: widget.password,
                    email: widget.email!,
                  ),
                ),
              ).then(
                (response) => response != null
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomePage(
                            initialData: response,
                            initialPassword: widget.password!,
                          ),
                        ),
                        (_) => false,
                      )
                    : null,
              );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) => LoginPage();

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _RedirectHome extends StatefulWidget {
  final String accessToken;
  final String refreshToken;
  final GymEntity gym;
  final UserEntity user;
  final String profilePictureUrl;
  final String password;

  const _RedirectHome({
    Key? key,
    required this.accessToken,
    required this.refreshToken,
    required this.gym,
    required this.user,
    required this.profilePictureUrl,
    required this.password,
  }) : super(key: key);

  @override
  _RedirectHomeState createState() => _RedirectHomeState();
}

class _RedirectHomeState extends State<_RedirectHome> {
  var _disposed = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (!_disposed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(
                  initialData: LoginResponse(
                    accessToken: widget.accessToken,
                    refreshToken: widget.refreshToken,
                    user: ProfilePictureUserEntity.fromUserEntity(
                      widget.user,
                      widget.profilePictureUrl,
                    ),
                    gym: widget.gym,
                  ),
                  initialPassword: widget.password,
                ),
              ),
              (_) => false,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Container(),
      );

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeviceInfo? device;
    try {
      final name = dotenv.get("DEVICE");
      device = Devices.all.firstWhere(
        (device) => name.toLowerCase() == device.name.toLowerCase(),
      );
    } catch (_) {
      device = null;
    }
    return DevicePreview(
      defaultDevice: device,
      enabled: device != null,
      isToolbarVisible: true,
      builder: (context) => ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        useInheritedMediaQuery: device != null,
        builder: (context, child) => MaterialApp(
          title: 'PhitNest',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              final user = Cache.user;
              final password = Cache.password;
              if (user != null && password != null) {
                final accessToken = Cache.accessToken;
                final refreshToken = Cache.refreshToken;
                final profilePictureUrl = Cache.profilePictureUrl;
                final gym = Cache.gym;
                if (user.confirmed &&
                    accessToken != null &&
                    refreshToken != null &&
                    profilePictureUrl != null &&
                    gym != null) {
                  return _RedirectHome(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    gym: gym,
                    user: user,
                    profilePictureUrl: profilePictureUrl,
                    password: password,
                  );
                } else {
                  return _RedirectedLogin(
                    shouldRedirect: !user.confirmed,
                    email: user.email,
                    password: password,
                  );
                }
              }
              return OnBoardingPage();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../../api/api.dart';
import '../../common/constants/constants.dart';
import '../../widgets/widgets.dart';
import '../login/login.dart';
import '../profile_photo/profile_photo.dart';

part 'bloc/explore_bloc.dart';
part 'bloc/home_bloc.dart';
part 'bloc/user_bloc.dart';
part 'bloc/logout_bloc.dart';
part 'pages/explore.dart';
part 'widgets/explore_user.dart';
part 'widgets/empty_explore.dart';
part 'widgets/navbar.dart';
part 'model.dart';
part 'ui.dart';

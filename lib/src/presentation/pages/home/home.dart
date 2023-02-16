library home_page;

import 'dart:async';

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../data/backend/backend.dart';
import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

part 'ui/home_page.dart';

part 'state/base.dart';
part 'state/initial.dart';
part 'state/log_out_connected.dart';
part 'state/explore.dart';
part 'state/socket_connected.dart';
part 'state/socket_disconnected.dart';

part 'bloc/home_bloc.dart';
part 'bloc/on_loaded_user.dart';
part 'bloc/on_refresh_session.dart';
part 'bloc/on_login.dart';
part 'bloc/on_log_out.dart';
part 'bloc/on_set_page.dart';
part 'bloc/on_set_explore_response.dart';

part 'event/base.dart';
part 'event/loaded_user.dart';
part 'event/refresh_session.dart';
part 'event/login.dart';
part 'event/log_out.dart';
part 'event/set_page.dart';
part 'event/set_explore_response.dart';

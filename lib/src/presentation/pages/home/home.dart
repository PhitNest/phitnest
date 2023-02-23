library home_page;

import 'dart:async';

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../common/utils/utils.dart';
import '../../../data/backend/backend.dart';
import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../friends/friends.dart';
import '../pages.dart';

// CHAT PAGE BLOC
part 'bloc/chat/chat_bloc.dart';
part 'bloc/chat/on_loaded.dart';
part 'bloc/chat/on_loading_error.dart';

// EXPLORE PAGE BLOC
part 'bloc/explore/explore_bloc.dart';
part 'bloc/explore/on_increment_countdown.dart';
part 'bloc/explore/on_loaded.dart';
part 'bloc/explore/on_loading_error.dart';
part 'bloc/explore/on_press_down.dart';
part 'bloc/explore/on_release.dart';

// HOME PAGE BLOC
part 'bloc/home/home_bloc.dart';
part 'bloc/home/on_refresh_session.dart';
part 'bloc/home/on_set_page.dart';
part 'bloc/home/on_socket_connect.dart';
part 'bloc/home/on_socket_connect_error.dart';

// OPTIONS PAGE BLOC
part 'bloc/options/on_edit_profile_picture.dart';
part 'bloc/options/on_error.dart';
part 'bloc/options/on_loaded.dart';
part 'bloc/options/on_set_profile_picture.dart';
part 'bloc/options/on_sign_out.dart';
part 'bloc/options/on_sign_out_response.dart';
part 'bloc/options/options_bloc.dart';

// CHAT PAGE EVENT
part 'event/chat/base.dart';
part 'event/chat/loaded.dart';
part 'event/chat/loading_error.dart';

// EXPLORE PAGE EVENT
part 'event/explore/base.dart';
part 'event/explore/increment_countdown.dart';
part 'event/explore/loaded.dart';
part 'event/explore/loading_error.dart';
part 'event/explore/press_down.dart';
part 'event/explore/release.dart';
part 'event/explore/send_friend_request.dart';

// HOME PAGE EVENT
part 'event/home/base.dart';
part 'event/home/refresh_session.dart';
part 'event/home/set_page.dart';
part 'event/home/socket_connect_error.dart';
part 'event/home/socket_connected.dart';

// OPTIONS PAGE EVENT
part 'event/options/base.dart';
part 'event/options/edit_profile_picture.dart';
part 'event/options/error.dart';
part 'event/options/loaded.dart';
part 'event/options/set_profile_picture.dart';
part 'event/options/sign_out.dart';
part 'event/options/sign_out_response.dart';

// CHAT PAGE STATE
part 'state/chat/base.dart';
part 'state/chat/loaded.dart';
part 'state/chat/loading.dart';
part 'state/chat/reloading.dart';

// EXPLORE PAGE STATE
part 'state/explore/base.dart';
part 'state/explore/holding.dart';
part 'state/explore/loaded.dart';
part 'state/explore/loading.dart';
part 'state/explore/matched.dart';
part 'state/explore/reloading.dart';
part 'state/explore/sending.dart';

// HOME PAGE STATE
part 'state/home/base.dart';
part 'state/home/initial.dart';
part 'state/home/socket_connected.dart';

// OPTIONS PAGE STATE
part 'state/options/base.dart';
part 'state/options/edit_profile_picture.dart';
part 'state/options/initial.dart';
part 'state/options/loaded.dart';
part 'state/options/sign_out.dart';
part 'state/options/sign_out_loading.dart';

// CHAT PAGE UI
part 'ui/chat/chat_page.dart';
part 'ui/chat/widgets/available_chat.dart';
part 'ui/chat/widgets/base.dart';
part 'ui/chat/widgets/empty.dart';
part 'ui/chat/widgets/loading.dart';

// EXPLORE PAGE UI
part 'ui/explore/explore_page.dart';
part 'ui/explore/widgets/base.dart';
part 'ui/explore/widgets/card.dart';
part 'ui/explore/widgets/empty.dart';
part 'ui/explore/widgets/loading.dart';

// HOME PAGE UI
part 'ui/home_page.dart';

// OPTIONS PAGE UI
part 'ui/options/options_page.dart';
part 'ui/options/widgets/base.dart';
part 'ui/options/widgets/loaded.dart';
part 'ui/options/widgets/loading.dart';
part 'ui/options/widgets/sign_out_loading.dart';

library friends_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
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
import '../../widgets/widgets.dart';
import '../pages.dart';

// ======= BLOC =======
part 'bloc/friends_bloc.dart';
part 'bloc/on_loaded.dart';
part 'bloc/on_loading_error.dart';
part 'bloc/on_edit_search.dart';
part 'bloc/on_deny_request.dart';
part 'bloc/on_remove_friend.dart';
part 'bloc/on_add_friend.dart';
part 'bloc/on_add_friend_error.dart';
part 'bloc/on_remove_friend_error.dart';
part 'bloc/on_deny_request_error.dart';
part 'bloc/on_deny_request_success.dart';
part 'bloc/on_add_friend_success.dart';
part 'bloc/on_remove_friend_success.dart';

// ======= EVENT =======
part 'event/base.dart';
part 'event/loaded.dart';
part 'event/loading_error.dart';
part 'event/edit_search.dart';
part 'event/add_friend.dart';
part 'event/remove_friend.dart';
part 'event/deny_request.dart';
part 'event/add_friend_error.dart';
part 'event/remove_friend_error.dart';
part 'event/deny_request_error.dart';
part 'event/deny_request_success.dart';
part 'event/add_friend_success.dart';
part 'event/remove_friend_success.dart';

// ======= STATE =======
part 'state/base.dart';
part 'state/loaded.dart';
part 'state/loading.dart';
part 'state/reloading.dart';

// ======= UI =======
part 'ui/friends_page.dart';
part 'ui/widgets/friend_request_card.dart';
part 'ui/widgets/friendship_card.dart';
part 'ui/widgets/ignore_button.dart';

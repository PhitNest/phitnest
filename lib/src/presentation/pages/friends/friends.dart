library friends_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

// ======= EVENT =======
part 'event/base.dart';
part 'event/loaded.dart';
part 'event/loading_error.dart';
part 'event/edit_search.dart';

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

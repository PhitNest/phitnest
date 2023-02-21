library explore_page;

import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../common/utils/utils.dart';
import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../home/home.dart';

part 'ui/explore_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/card.dart';
part 'ui/widgets/loading.dart';
part 'ui/widgets/empty.dart';

part 'bloc/explore_bloc.dart';
part 'bloc/on_press_down.dart';
part 'bloc/on_release.dart';
part 'bloc/on_increment_countdown.dart';
part 'bloc/on_load.dart';
part 'bloc/on_load_with_initial.dart';
part 'bloc/on_loaded.dart';
part 'bloc/on_loading_error.dart';

part 'event/base.dart';
part 'event/press_down.dart';
part 'event/release.dart';
part 'event/increment_countdown.dart';
part 'event/loaded.dart';
part 'event/loading_error.dart';
part 'event/load_with_initial.dart';
part 'event/load.dart';
part 'event/send.dart';

part 'state/base.dart';
part 'state/initial.dart';
part 'state/holding.dart';
part 'state/matched.dart';
part 'state/loading.dart';
part 'state/loaded.dart';
part 'state/reloading.dart';
part 'state/sending.dart';

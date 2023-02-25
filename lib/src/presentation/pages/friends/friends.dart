library friends_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../data/backend/backend.dart';
import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

// ██████  ██       ██████   ██████
// ██   ██ ██      ██    ██ ██
// ██████  ██      ██    ██ ██
// ██   ██ ██      ██    ██ ██
// ██████  ███████  ██████   ██████
part 'bloc/friends_bloc.dart';
part 'bloc/on_loaded.dart';
part 'bloc/on_loading_error.dart';

// ███████ ██    ██ ███████ ███    ██ ████████
// ██      ██    ██ ██      ████   ██    ██
// █████   ██    ██ █████   ██ ██  ██    ██
// ██       ██  ██  ██      ██  ██ ██    ██
// ███████   ████   ███████ ██   ████    ██
part 'event/base.dart';
part 'event/loaded.dart';
part 'event/loading_error.dart';

// ███████ ████████  █████  ████████ ███████
// ██         ██    ██   ██    ██    ██
// ███████    ██    ███████    ██    █████
//      ██    ██    ██   ██    ██    ██
// ███████    ██    ██   ██    ██    ███████
part 'state/base.dart';
part 'state/loaded.dart';
part 'state/loading.dart';
part 'state/reloading.dart';

// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
//  ██████  ██
part 'ui/friends_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/loaded.dart';
part 'ui/widgets/loading.dart';

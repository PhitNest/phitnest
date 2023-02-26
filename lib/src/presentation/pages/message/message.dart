library message;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/common/utils/utils.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

// ======= BLOC =======
part 'bloc/message_bloc.dart';
part 'bloc/on_loaded.dart';
part 'bloc/on_loading_error.dart';
part 'bloc/on_send.dart';
part 'bloc/on_send_error.dart';
part 'bloc/on_send_success.dart';
// ======= EVENT =======
part 'event/base.dart';
part 'event/loaded.dart';
part 'event/loading_error.dart';
part 'event/send.dart';
part 'event/send_error.dart';
part 'event/send_success.dart';
// ======= STATE =======
part 'state/base.dart';
part 'state/loaded.dart';
part 'state/loading.dart';
part 'state/reloading.dart';
part 'state/sending.dart';
// ======= UI =====
part 'ui/message_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/empty_message.dart';
part 'ui/widgets/loading.dart';
part 'ui/widgets/message_loaded.dart';

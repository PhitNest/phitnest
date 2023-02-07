library chat_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../data/backend/backend.dart';
import '../../widgets/widgets.dart';

part 'ui/widgets/available_chat.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/empty.dart';
part 'bloc/chat_bloc.dart';
part 'bloc/onError.dart';
part 'bloc/onMessageLoaded.dart';
part 'event/base.dart';
part 'event/error.dart';
part 'event/message_loaded.dart';
part 'state/base.dart';
part 'state/error.dart';
part 'state/initial.dart';
part 'state/message_loaded.dart';
part 'ui/chat_page.dart';
part 'ui/widgets/loading.dart';

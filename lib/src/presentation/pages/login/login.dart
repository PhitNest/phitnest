library login_page;

import 'dart:async';

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../common/utils/utils.dart';
import '../../../data/backend/backend.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

// ======= BLOC =======
part 'bloc/login_bloc.dart';
part 'bloc/on_cancel.dart';
part 'bloc/on_error.dart';
part 'bloc/on_submit.dart';
part 'bloc/on_success.dart';

// ======= EVENT =======
part 'event/base.dart';
part 'event/cancel.dart';
part 'event/error.dart';
part 'event/submit.dart';
part 'event/success.dart';

// ======= STATE =======
part 'state/base.dart';
part 'state/confirming_email.dart';
part 'state/initial.dart';
part 'state/loading.dart';
part 'state/success.dart';

// ======= UI =======
part 'ui/login_page.dart';

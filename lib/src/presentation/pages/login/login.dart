library login_page;

import 'package:async/async.dart';
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
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../confirmEmail/confirm_email.dart';
import '../forgotPassword/forgot_password.dart';
import '../home/home.dart';

part 'bloc/login_bloc.dart';
part 'bloc/on_cancel.dart';
part 'bloc/on_error.dart';
part 'bloc/on_success.dart';
part 'bloc/on_submit.dart';

part 'event/cancel.dart';
part 'event/login_event.dart';
part 'event/submit.dart';
part 'event/success.dart';
part 'event/error.dart';

part 'state/login_state.dart';
part 'state/success.dart';
part 'state/initial.dart';
part 'state/loading.dart';
part 'state/confirming_email.dart';

part 'ui/login_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

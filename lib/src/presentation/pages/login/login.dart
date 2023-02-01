library login_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../data/backend/backend.dart';

part 'bloc/login_bloc.dart';
part 'bloc/on_cancel.dart';
part 'bloc/on_error.dart';
part 'bloc/on_login_success.dart';
part 'bloc/on_reset.dart';
part 'bloc/on_submit.dart';

part 'event/cancel.dart';
part 'event/login_event.dart';
part 'event/submit.dart';
part 'event/reset.dart';
part 'event/success.dart';
part 'event/error.dart';

part 'state/login_state.dart';
part 'state/login_success.dart';
part 'state/initial.dart';
part 'state/loading.dart';
part 'state/confirming_email.dart';

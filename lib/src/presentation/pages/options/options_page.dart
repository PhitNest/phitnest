library options_page;

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../login/login.dart';

part 'bloc/on_sign_out_error.dart';
part 'bloc/on_sign_out.dart';
part 'bloc/on_sign_out_success.dart';
part 'bloc/options_bloc.dart';

part 'event/sign_out_error.dart';
part 'event/options_event.dart';
part 'event/sign_out.dart';
part 'event/sign_out_success.dart';

part 'state/error.dart';
part 'state/initial.dart';
part 'state/sign_out_loading.dart';
part 'state/options_state.dart';
part 'state/sign_out_success.dart';

part 'ui/options_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

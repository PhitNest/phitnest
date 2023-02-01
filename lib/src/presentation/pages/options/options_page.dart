library options_page;

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../widgets/widgets.dart';

part 'bloc/on_error.dart';
part 'bloc/on_signout.dart';
part 'bloc/on_success.dart';
part 'bloc/options_bloc.dart';
part 'event/error.dart';
part 'event/options_event.dart';
part 'event/signout.dart';
part 'event/success.dart';
part 'state/error.dart';
part 'state/initial.dart';
part 'state/loading.dart';
part 'state/options_state.dart';
part 'state/success.dart';
part 'ui/options_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

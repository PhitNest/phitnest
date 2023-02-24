library forgot_password_page;

import 'dart:async';

import 'package:async/async.dart';
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
import '../../../data/cache/cache.dart';
import '../../widgets/widgets.dart';
import '../confirmEmail/confirm_email.dart';
import '../forgotPasswordSubmit/forgot_password_submit.dart';
import '../home/home.dart';

// ██████  ██       ██████   ██████
// ██   ██ ██      ██    ██ ██
// ██████  ██      ██    ██ ██
// ██   ██ ██      ██    ██ ██
// ██████  ███████  ██████   ██████
part 'bloc/forgot_password_bloc.dart';
part 'bloc/on_error.dart';
part 'bloc/on_submit.dart';
part 'bloc/on_success.dart';

// ███████ ██    ██ ███████ ███    ██ ████████
// ██      ██    ██ ██      ████   ██    ██
// █████   ██    ██ █████   ██ ██  ██    ██
// ██       ██  ██  ██      ██  ██ ██    ██
// ███████   ████   ███████ ██   ████    ██
part 'event/base.dart';
part 'event/error.dart';
part 'event/submit.dart';
part 'event/success.dart';

// ███████ ████████  █████  ████████ ███████
// ██         ██    ██   ██    ██    ██
// ███████    ██    ███████    ██    █████
//      ██    ██    ██   ██    ██    ██
// ███████    ██    ██   ██    ██    ███████
part 'state/base.dart';
part 'state/confirm_email_error.dart';
part 'state/initial.dart';
part 'state/loading.dart';
part 'state/success.dart';

// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
//  ██████  ██
part 'ui/forgot_password_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

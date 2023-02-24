library verification_page;

import 'dart:async';

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../data/backend/backend.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../profilePicture/profile_picture.dart';

// ██████  ██       ██████   ██████
// ██   ██ ██      ██    ██ ██
// ██████  ██      ██    ██ ██
// ██   ██ ██      ██    ██ ██
// ██████  ███████  ██████   ██████
part 'bloc/verification_bloc.dart';
part 'bloc/on_confirm_error.dart';
part 'bloc/on_login_response.dart';
part 'bloc/on_reset.dart';
part 'bloc/on_resend.dart';
part 'bloc/on_submit.dart';
part 'bloc/on_confirm_success.dart';

// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
//  ██████  ██
part 'ui/verification_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

// ███████ ██    ██ ███████ ███    ██ ████████
// ██      ██    ██ ██      ████   ██    ██
// █████   ██    ██ █████   ██ ██  ██    ██
// ██       ██  ██  ██      ██  ██ ██    ██
// ███████   ████   ███████ ██   ████    ██
part 'event/base.dart';
part 'event/error.dart';
part 'event/login_response.dart';
part 'event/confirm_success.dart';
part 'event/reset.dart';
part 'event/submit.dart';
part 'event/resend.dart';

// ███████ ████████  █████  ████████ ███████
// ██         ██    ██   ██    ██    ██
// ███████    ██    ███████    ██    █████
//      ██    ██    ██   ██    ██    ██
// ███████    ██    ██   ██    ██    ███████
part 'state/base.dart';
part 'state/confirming.dart';
part 'state/success.dart';
part 'state/profile_picture_upload.dart';
part 'state/initial.dart';
part 'state/resending.dart';
part 'state/login_loading.dart';

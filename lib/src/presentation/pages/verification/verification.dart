library verification_page;

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

part 'bloc/verification_bloc.dart';
part 'bloc/on_confirm_error.dart';
part 'bloc/on_success.dart';
part 'bloc/on_profile_picture_error.dart';
part 'bloc/on_reset.dart';
part 'bloc/on_resend.dart';
part 'bloc/on_resend_error.dart';
part 'bloc/on_submit.dart';

part 'ui/verification_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/error.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

part 'event/base.dart';
part 'event/confirm_error.dart';
part 'event/success.dart';
part 'event/profile_picture_error.dart';
part 'event/reset.dart';
part 'event/submit.dart';
part 'event/resend.dart';
part 'event/resend_error.dart';

part 'state/base.dart';
part 'state/confirming.dart';
part 'state/confirm_error.dart';
part 'state/success.dart';
part 'state/profile_picture_upload.dart';
part 'state/initial.dart';
part 'state/resend_error.dart';
part 'state/resending.dart';

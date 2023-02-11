library options_page;

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../common/utils/utils.dart';
import '../../../data/backend/backend.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../login/login.dart';
import '../home/home.dart';
import '../profilePicture/profile_picture.dart';

part 'bloc/on_sign_out_error.dart';
part 'bloc/on_sign_out.dart';
part 'bloc/on_sign_out_success.dart';
part 'bloc/options_bloc.dart';
part 'bloc/on_error.dart';
part 'bloc/on_loaded.dart';
part 'bloc/on_edit_profile_picture.dart';
part 'bloc/on_set_profile_picture.dart';

part 'event/base.dart';
part 'event/sign_out_error.dart';
part 'event/sign_out.dart';
part 'event/sign_out_success.dart';
part 'event/error.dart';
part 'event/loaded.dart';
part 'event/edit_profile_picture.dart';
part 'event/set_profile_picture.dart';

part 'state/base.dart';
part 'state/sign_out_error.dart';
part 'state/initial.dart';
part 'state/sign_out_loading.dart';
part 'state/sign_out_success.dart';
part 'state/error.dart';
part 'state/loaded.dart';
part 'state/edit_profile_picture.dart';

part 'ui/options_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/loaded.dart';
part 'ui/widgets/sign_out_loading.dart';
part 'ui/widgets/loading.dart';

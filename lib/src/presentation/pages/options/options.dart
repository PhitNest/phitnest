library options_page;

import 'dart:async';

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
import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

part 'bloc/on_edit_profile_picture.dart';
part 'bloc/on_error.dart';
part 'bloc/on_loaded.dart';
part 'bloc/on_set_profile_picture.dart';
part 'bloc/on_sign_out.dart';
part 'bloc/on_sign_out_response.dart';
part 'bloc/options_bloc.dart';

part 'event/base.dart';
part 'event/edit_profile_picture.dart';
part 'event/error.dart';
part 'event/loaded.dart';
part 'event/set_profile_picture.dart';
part 'event/sign_out.dart';
part 'event/sign_out_response.dart';

part 'state/base.dart';
part 'state/edit_profile_picture.dart';
part 'state/initial.dart';
part 'state/loaded.dart';
part 'state/sign_out_loading.dart';
part 'state/sign_out.dart';

part 'ui/options_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/loaded.dart';
part 'ui/widgets/loading.dart';
part 'ui/widgets/sign_out_loading.dart';

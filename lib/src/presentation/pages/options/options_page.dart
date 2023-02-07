library options_page;

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../login/login.dart';

part 'bloc/on_edit_profile_picture.dart';
part 'bloc/on_error.dart';
part 'bloc/on_sign_out.dart';
part 'bloc/on_sign_out_success.dart';
part 'bloc/options_bloc.dart';
part 'event/base.dart';
part 'event/edit_profile_picture.dart';
part 'event/error.dart';
part 'event/sign_out.dart';
part 'event/success.dart';
part 'state/base.dart';
part 'state/edit_profile_picture.dart';
part 'state/error.dart';
part 'state/initial.dart';
part 'state/sign_out_loading.dart';
part 'state/success.dart';
part 'ui/options_page.dart';
part 'ui/widgets/base.dart';
part 'ui/widgets/initial.dart';
part 'ui/widgets/loading.dart';

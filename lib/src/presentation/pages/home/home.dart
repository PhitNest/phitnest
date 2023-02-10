library home_page;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../data/backend/backend.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../widgets/widgets.dart';
import '../login/login.dart';
import '../options/options.dart';

part 'ui/home_page.dart';

part 'state/base.dart';
part 'state/initial.dart';
part 'state/log_out.dart';

part 'bloc/home_bloc.dart';
part 'bloc/on_loaded_user.dart';
part 'bloc/on_refresh_session.dart';
part 'bloc/on_login.dart';
part 'bloc/on_log_out.dart';

part 'event/base.dart';
part 'event/loaded_user.dart';
part 'event/refresh_session.dart';
part 'event/login.dart';
part 'event/log_out.dart';

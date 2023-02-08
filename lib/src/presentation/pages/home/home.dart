library home_page;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/backend/backend.dart';
import '../../../domain/entities/entities.dart';
import '../../widgets/widgets.dart';
import '../options/options.dart';

part 'ui/home_page.dart';

part 'state/base.dart';
part 'state/initial.dart';

part 'bloc/home_bloc.dart';
part 'bloc/on_loaded_user.dart';

part 'event/base.dart';
part 'event/loaded_user.dart';

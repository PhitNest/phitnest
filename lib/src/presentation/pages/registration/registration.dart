library registration_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/theme.dart';
import '../../../common/utils/utils.dart';
import '../../../data/backend/backend.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../confirmEmail/confirm_email.dart';
import '../gymSearch/gym_search.dart';
import '../home/home.dart';
import '../profilePicture/profile_picture.dart';

// ██████  ██       ██████   ██████
// ██   ██ ██      ██    ██ ██
// ██████  ██      ██    ██ ██
// ██   ██ ██      ██    ██ ██
// ██████  ███████  ██████   ██████
part 'bloc/on_edit_first_name.dart';
part 'bloc/on_gym_loading_error.dart';
part 'bloc/on_gyms_loaded.dart';
part 'bloc/on_gym_selected.dart';
part 'bloc/on_register.dart';
part 'bloc/on_register_error.dart';
part 'bloc/on_register_success.dart';
part 'bloc/on_retry_load_gyms.dart';
part 'bloc/on_submit_page_one.dart';
part 'bloc/on_submit_page_two.dart';
part 'bloc/on_swipe.dart';
part 'bloc/registration_bloc.dart';

// ███████ ██    ██ ███████ ███    ██ ████████
// ██      ██    ██ ██      ████   ██    ██
// █████   ██    ██ █████   ██ ██  ██    ██
// ██       ██  ██  ██      ██  ██ ██    ██
// ███████   ████   ███████ ██   ████    ██
part 'event/base.dart';
part 'event/edit_first_name.dart';
part 'event/gym_selected.dart';
part 'event/register.dart';
part 'event/register_error.dart';
part 'event/success.dart';
part 'event/retry_load_gyms.dart';
part 'event/submit_page_one.dart';
part 'event/submit_page_two.dart';
part 'event/swipe.dart';
part 'event/gyms_loading_error.dart';
part 'event/gyms_loaded.dart';

// ███████ ████████  █████  ████████ ███████
// ██         ██    ██   ██    ██    ██
// ███████    ██    ███████    ██    █████
//      ██    ██    ██   ██    ██    ██
// ███████    ██    ██   ██    ██    ███████
part 'state/base.dart';
part 'state/initial.dart';
part 'state/gyms_loaded.dart';
part 'state/gyms_loading_error.dart';
part 'state/success.dart';
part 'state/gym_selected.dart';
part 'state/register_loading.dart';

// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
//  ██████  ██
part 'ui/registration_page.dart';
part 'ui/widgets/page_four.dart';
part 'ui/widgets/page_one.dart';
part 'ui/widgets/page_three.dart';
part 'ui/widgets/page_two.dart';
part 'ui/widgets/profile_picture_instructions.dart';

library message_page;

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../../data/backend/backend.dart';
import '../../../domain/entities/entities.dart';
import '../../widgets/widgets.dart';
import '../home/home.dart';

// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
// ██    ██ ██
//  ██████  ██
part 'ui/message_page.dart';
part 'ui/widgets/message_card.dart';

// ██████  ██       ██████   ██████
// ██   ██ ██      ██    ██ ██
// ██████  ██      ██    ██ ██
// ██   ██ ██      ██    ██ ██
// ██████  ███████  ██████   ██████


// ███████ ██    ██ ███████ ███    ██ ████████
// ██      ██    ██ ██      ████   ██    ██
// █████   ██    ██ █████   ██ ██  ██    ██
// ██       ██  ██  ██      ██  ██ ██    ██
// ███████   ████   ███████ ██   ████    ██


// ███████ ████████  █████  ████████ ███████
// ██         ██    ██   ██    ██    ██
// ███████    ██    ███████    ██    █████
//      ██    ██    ██   ██    ██    ██
// ███████    ██    ██   ██    ██    ███████

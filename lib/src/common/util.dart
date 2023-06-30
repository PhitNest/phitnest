import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

extension CognitoBlocGetter on BuildContext {
  CognitoBloc get cognitoBloc => BlocProvider.of(this);
}

const kProfilePictureAspectRatio = Size(375.0, 330.0);

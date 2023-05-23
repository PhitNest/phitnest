import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

extension AuthBlocGetter on BuildContext {
  AuthBloc get authBloc => BlocProvider.of(this);
}

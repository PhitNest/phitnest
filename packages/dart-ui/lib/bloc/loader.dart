import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension LoaderGetter on BuildContext {
  LoaderBloc<ReqType, ResType> loader<ReqType, ResType>() =>
      BlocProvider.of(this);
  ParallelLoaderBloc<ReqType, ResType> parallelBloc<ReqType, ResType>() =>
      BlocProvider.of(this);
  AuthLoaderBloc<ReqType, ResType> authLoader<ReqType, ResType>() =>
      BlocProvider.of(this);
  AuthParallelLoaderBloc<ReqType, ResType>
      authParallelBloc<ReqType, ResType>() => BlocProvider.of(this);
  SessionBloc get sessionLoader => loader();
}

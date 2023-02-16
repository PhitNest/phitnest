import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocWidget<B extends Bloc<dynamic, S>, S extends Equatable>
    extends StatelessWidget {
  final B Function(BuildContext context) create;
  final Widget Function(BuildContext, S) builder;
  final void Function(BuildContext, S)? listener;

  const BlocWidget({
    Key? key,
    required this.create,
    required this.builder,
    this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<B>(
        create: create,
        child: BlocConsumer<B, S>(
          builder: builder,
          listener: listener ?? (_, __) {},
        ),
      );
}

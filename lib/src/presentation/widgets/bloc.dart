import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocWidget<B extends Bloc<dynamic, S>, S> extends StatefulWidget {
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
  _BlocWidgetState<B, S> createState() => _BlocWidgetState<B, S>();
}

class _BlocWidgetState<B extends Bloc<dynamic, S>, S>
    extends State<BlocWidget<B, S>> {
  @override
  Widget build(BuildContext context) => BlocProvider<B>(
        create: widget.create,
        child: BlocConsumer<B, S>(
          buildWhen: (_, __) => true,
          listenWhen: (_, __) => true,
          builder: widget.builder,
          listener: widget.listener ?? (_, __) {},
        ),
      );
}

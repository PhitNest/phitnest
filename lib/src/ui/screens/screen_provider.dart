import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'screen_state.dart';

abstract class ScreenProvider<C extends ScreenCubit<S>, S extends ScreenState>
    extends StatefulWidget {
  const ScreenProvider() : super();

  C buildCubit();

  Widget builder(BuildContext context, C cubit, S state);

  Future<void> listener(BuildContext context, C cubit, S state) async {}

  @nonVirtual
  @override
  State<StatefulWidget> createState() => _ScreenProviderState<C, S>();

  void dispose() {}
}

class _ScreenProviderState<C extends ScreenCubit<S>, S extends ScreenState>
    extends State<ScreenProvider<C, S>> {
  _ScreenProviderState() : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) {
          C cubit = widget.buildCubit();
          Future.delayed(Duration.zero,
              () => widget.listener(context, cubit, cubit.state));
          return cubit;
        },
        child: BlocConsumer<C, S>(
          builder: (context, state) =>
              widget.builder(context, context.read<C>(), state),
          listener: (context, state) =>
              widget.listener(context, context.read<C>(), state),
        ),
      );

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}

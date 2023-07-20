import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form.dart';
import '../bloc/loader.dart';

final class FormProvider<Controllers extends FormControllers, ReqType, ResType>
    extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    Controllers controllers,
    Widget Function({
      required Widget Function(
              BuildContext, LoaderState<ResType>, void Function(ReqType) submit)
          builder,
      required void Function(
              BuildContext, LoaderState<ResType>, void Function(ReqType) submit)
          listener,
    }) consumer,
  ) formBuilder;

  final Controllers Function(BuildContext context) createControllers;
  final Future<ReqType> Function(ResType req) load;
  final ResType? initialData;

  void submit(BuildContext context, ReqType request) =>
      BlocProvider.of<FormBloc<Controllers>>(context).submit(
        onAccept: () => context.loader<ReqType, ResType>().add(
              LoaderLoadEvent(request),
            ),
      );

  const FormProvider({
    required this.load,
    required this.formBuilder,
    required this.createControllers,
    this.initialData,
  }) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FormBloc(createControllers(context)),
          ),
          BlocProvider(
            create: (_) => LoaderBloc(load: load),
          ),
        ],
        child: FormConsumer(
          listener: (context, formState) {},
          builder: (context, formState) {
            final formBloc = BlocProvider.of<FormBloc<Controllers>>(context);
            return Form(
              key: formBloc.formKey,
              child: formBuilder(
                context,
                formBloc.controllers,
                ({required builder, required listener}) =>
                    LoaderConsumer<ReqType, ResType>(
                  builder: (context, loaderState) => builder(
                    context,
                    loaderState,
                    (req) => switch (loaderState) {
                      LoaderLoadingState() => {},
                      _ => submit(context, req),
                    },
                  ),
                  listener: (context, loaderState) => listener(
                    context,
                    loaderState,
                    (req) => switch (loaderState) {
                      LoaderLoadingState() => {},
                      _ => submit(context, req),
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
}

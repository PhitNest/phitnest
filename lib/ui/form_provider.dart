import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form/form.dart';
import '../bloc/loader/loader.dart';

typedef FormProvider<Controllers extends FormControllers, ReqType, ResType>
    = _FormProvider<Controllers, LoaderBloc<ReqType, ResType>, ReqType,
        ResType>;

typedef AuthFormProvider<Controllers extends FormControllers, ReqType, ResType>
    = _FormProvider<Controllers, AuthLoaderBloc<ReqType, ResType>,
        ({ReqType data, SessionBloc sessionLoader}), AuthResOrLost<ResType>>;

final class _FormProvider<
    Controllers extends FormControllers,
    BlocType extends LoaderBloc<ReqType, ResType>,
    ReqType,
    ResType> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    Controllers controllers,
    LoaderState<ResType> loaderState,
    void Function(ReqType) submit,
  ) builder;

  final void Function(
    BuildContext context,
    Controllers controllers,
    LoaderState<ResType> loaderState,
    void Function(ReqType) submit,
  ) listener;

  final Controllers Function(BuildContext context) createControllers;
  final BlocType Function(BuildContext) createLoader;

  void submit(BuildContext context, ReqType request) =>
      context.formBloc<Controllers>().submit(
            onAccept: () => context
                .loader<ReqType, ResType>()
                .add(LoaderLoadEvent(request)),
          );

  const _FormProvider({
    required this.createLoader,
    required this.listener,
    required this.builder,
    required this.createControllers,
  }) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FormBloc(createControllers(context)),
          ),
          BlocProvider(create: createLoader),
        ],
        child: FormConsumer<Controllers>(
          listener: (context, formState) {},
          builder: (context, formState) {
            handleSubmit(ReqType req, LoaderState<ResType> loaderState) =>
                switch (loaderState) {
                  LoaderLoadingState() => null,
                  _ => submit(context, req),
                };
            final FormBloc<Controllers> formBloc = context.formBloc();
            return Form(
              key: formBloc.formKey,
              child: LoaderConsumer<ReqType, ResType>(
                listener: (context, loaderState) => listener(
                    context,
                    formBloc.controllers,
                    loaderState,
                    (req) => handleSubmit(req, loaderState)),
                builder: (context, loaderState) => builder(
                    context,
                    formBloc.controllers,
                    loaderState,
                    (req) => handleSubmit(req, loaderState)),
              ),
            );
          },
        ),
      );
}

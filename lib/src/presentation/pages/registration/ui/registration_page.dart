part of registration_page;

extension _Bloc on BuildContext {
  _RegistrationBloc get bloc => read();

  int get scrollLimit {
    if (bloc.state.firstNameConfirmed) {
      if (bloc.state is _GymSelected) {
        return 4;
      } else {
        return 3;
      }
    } else {
      return 1;
    }
  }

  void selectGym(GymEntity gym) => bloc.add(_GymSelectedEvent(gym));

  void noGym() {}

  void notMyGym() {
    final state = bloc.state as _GymSelected;
    Navigator.push(
      this,
      CupertinoPageRoute(
        builder: (context) => GymSearchPage(
          gyms: state.gyms,
          location: state.location,
          initialGym: state.gym,
        ),
      ),
    ).then(
      (gym) {
        if (gym != null) {
          selectGym(gym);
        }
      },
    );
  }

  void submitPageOne() => bloc.add(const _SubmitPageOneEvent());

  void submitPageTwo() => bloc.add(const _SubmitPageTwoEvent());

  void editFirstName(String? value) =>
      bloc.add(_EditFirstNameEvent(value ?? ""));

  void submit() => bloc.add(const _RegisterEvent());

  void retryLoadGyms() => bloc.add(const _RetryLoadGymsEvent());

  Future<void> goToProfilePicture(XFile? initialImage) async {
    final photo = await Navigator.push<XFile>(
      this,
      CupertinoPageRoute(
        builder: (context) => ProfilePicturePage(
          uploadImage: (image) => UseCases.uploadPhotoUnauthorized(
            email: bloc.emailController.text.trim(),
            password: bloc.passwordController.text,
            photo: image,
          ),
        ),
      ),
    );
    if (photo != null) {
      Navigator.pushAndRemoveUntil(
        this,
        CupertinoPageRoute(
          builder: (context) {
            Navigator.push<LoginResponse>(
              context,
              CupertinoPageRoute(
                builder: (context) => ConfirmEmailPage(
                  email: bloc.emailController.text.trim(),
                  password: bloc.passwordController.text,
                ),
              ),
            ).then(
              (confirmEmail) {
                if (confirmEmail != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomePage(
                        initialData: confirmEmail,
                        initialPassword: bloc.passwordController.text,
                      ),
                    ),
                    (_) => false,
                  );
                }
              },
            );
            return const LoginPage();
          },
        ),
        (_) => false,
      );
    }
  }

  void swipe(int pageIndex) => bloc.add(_SwipeEvent(pageIndex));
}

List<GymEntity> _filterGymsWithDuplicateNames(List<GymEntity> gyms) {
  List<GymEntity> filtered = [];
  for (final gym in gyms) {
    if (!filtered.any((element) => element.name == gym.name)) {
      filtered.add(gym);
    }
  }
  return filtered;
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _RegistrationBloc(),
        child: BlocConsumer<_RegistrationBloc, _RegistrationState>(
          listener: (context, state) {},
          builder: (context, state) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            if (state is _SuccessState) {
              return _ProfilePictureInstructions(
                onPressedTakePhoto: () => context.goToProfilePicture(null),
                onPressedUploadFromAlbums: context.goToProfilePicture,
              );
            } else {
              return StyledScaffold(
                body: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: SizedBox(
                    height: 1.sh,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            onPageChanged: context.swipe,
                            controller: context.bloc.pageController,
                            itemCount: context.scrollLimit,
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return _PageOne(
                                    keyboardPadding: keyboardHeight,
                                    formKey: context.bloc.pageOneFormKey,
                                    firstNameController:
                                        context.bloc.firstNameController,
                                    lastNameController:
                                        context.bloc.lastNameController,
                                    autovalidateMode: state.autovalidateMode,
                                    onFirstNameEdited: context.editFirstName,
                                    firstNameFocusNode:
                                        context.bloc.firstNameFocusNode,
                                    lastNameFocusNode:
                                        context.bloc.lastNameFocusNode,
                                    onSubmit: context.submitPageOne,
                                  );
                                case 1:
                                  return _PageTwo(
                                    keyboardPadding: keyboardHeight,
                                    formKey: context.bloc.pageTwoFormKey,
                                    takenEmails: state.takenEmails,
                                    emailController:
                                        context.bloc.emailController,
                                    passwordController:
                                        context.bloc.passwordController,
                                    autovalidateMode: state.autovalidateMode,
                                    emailFocusNode: context.bloc.emailFocusNode,
                                    passwordFocusNode:
                                        context.bloc.passwordFocusNode,
                                    onSubmit: context.submitPageTwo,
                                    confirmPasswordController:
                                        context.bloc.confirmPasswordController,
                                    confirmPasswordFocusNode:
                                        context.bloc.confirmPasswordFocusNode,
                                    firstName: context
                                        .bloc.firstNameController.text
                                        .trim(),
                                  );
                                case 2:
                                  if (state is _InitialState) {
                                    return _PageThreeLoading(
                                      firstName: context
                                          .bloc.firstNameController.text
                                          .trim(),
                                      onPressedNoGym: context.noGym,
                                    );
                                  } else if (state is _GymsLoadingErrorState) {
                                    return _PageThreeLoadingError(
                                      onPressedNoGym: context.noGym,
                                      firstName: context
                                          .bloc.firstNameController.text
                                          .trim(),
                                      error: state.failure.message,
                                      onPressedRetry: context.retryLoadGyms,
                                    );
                                  } else if (state is _GymSelected) {
                                    return _PageThreeSelected(
                                      firstName: context
                                          .bloc.firstNameController.text
                                          .trim(),
                                      gyms: _filterGymsWithDuplicateNames(
                                          state.gyms),
                                      onSelected: context.selectGym,
                                      onPressedNoGym: context.noGym,
                                      gym: state.gym,
                                      onPressedNext: () =>
                                          context.bloc.pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        curve: Curves.easeInOut,
                                      ),
                                    );
                                  } else if (state is _GymsLoaded) {
                                    return _PageThreeNotSelected(
                                      firstName: context
                                          .bloc.firstNameController.text
                                          .trim(),
                                      onPressedNoGym: context.noGym,
                                      gyms: _filterGymsWithDuplicateNames(
                                          state.gyms),
                                      onSelected: context.selectGym,
                                    );
                                  }
                                  break;
                                case 3:
                                  if (state is _RegisterLoadingState) {
                                    return const _PageFourLoading();
                                  } else if (state is _RegisterErrorState) {
                                    return _PageFourError(
                                      gym: state.gym,
                                      onPressedYes: context.submit,
                                      onPressedNo: context.notMyGym,
                                      error: state.failure.message,
                                    );
                                  } else if (state is _GymSelected) {
                                    return _PageFour(
                                      gym: state.gym,
                                      onPressedYes: context.submit,
                                      onPressedNo: context.notMyGym,
                                    );
                                  }
                              }
                              throw Exception('Invalid index: $index');
                            },
                          ),
                        ),
                        StyledPageIndicator(
                          currentPage: state.currentPage,
                          totalPages: 4,
                        ),
                        48.verticalSpace,
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
}

part of registration_page;

extension _Bloc on BuildContext {
  _RegistrationBloc get bloc => read();

  int get scrollLimit {
    if (bloc.state.firstNameConfirmed) {
      if (bloc.state is _IGymSelectedState) {
        return 4;
      } else {
        return 3;
      }
    } else {
      return 1;
    }
  }

  void selectGym(GymEntity gym) => bloc.add(_IGymSelectedStateEvent(gym));

  void noGym() {}

  void notMyGym() {
    final state = bloc.state as _IGymSelectedState;
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
    final email = bloc.emailController.text.trim();
    final password = bloc.passwordController.text;
    final photo = await Navigator.push<XFile>(
      this,
      CupertinoPageRoute(
        builder: (context) => ProfilePicturePage(
          uploadImage: (image) => UseCases.uploadPhotoUnauthorized(
            email: email,
            photo: image,
          ),
        ),
      ),
    );
    if (photo != null) {
      Navigator.push<LoginResponse>(
        this,
        CupertinoPageRoute(
          builder: (context) => ConfirmEmailPage(
            email: email,
            password: password,
          ),
        ),
      ).then(
        (confirmEmail) {
          if (confirmEmail != null) {
            Navigator.pushAndRemoveUntil(
              this,
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (_) => false,
            );
          } else {
            Navigator.pop(this);
          }
        },
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
  Widget build(BuildContext context) =>
      BlocWidget<_RegistrationBloc, _IRegistrationState>(
        create: (context) => _RegistrationBloc(),
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
                  height: 1.sh - MediaQuery.of(context).padding.top,
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
                                  keyboardHeight: keyboardHeight,
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
                                  keyboardHeight: keyboardHeight,
                                  formKey: context.bloc.pageTwoFormKey,
                                  takenEmails: state.takenEmails,
                                  emailController: context.bloc.emailController,
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
                                } else if (state is _IGymSelectedState) {
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
                                } else if (state is _IGymsLoadedState) {
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
                                  return _PageFourLoading(
                                    gym: state.gym,
                                  );
                                } else if (state is _IGymSelectedState) {
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
      );
}

import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../../../common/theme.dart';
import '../../../common/validators.dart';
import '../../../domain/entities/entities.dart';
import '../../widgets/styled/styled.dart';
import 'registration_bloc.dart';
import 'registration_state.dart';

class _GymCard extends StatelessWidget {
  final bool selected;
  final GymEntity gym;
  final double distance;
  final VoidCallback onPressed;

  _GymCard({
    required this.onPressed,
    required this.selected,
    required this.gym,
    required this.distance,
  }) : super();

  @override
  build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.transparent)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              selected ? Color(0xFFFFE3E3) : Colors.grey.shade50,
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${gym.name} (${distance.formatQuantity("mile")})',
                  style: theme.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(gym.address.toString(),
                      style: theme.textTheme.labelMedium),
                )
              ],
            ),
          ),
        ),
      );
}

class _GymSearchState extends ChangeNotifier {
  GymEntity _gym;
  late final TextEditingController searchController = TextEditingController()
    ..addListener(notifyListeners);

  GymEntity get gym => _gym;

  set gym(GymEntity value) {
    _gym = value;
    notifyListeners();
  }

  _GymSearchState(this._gym);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class _GymSearchWidget extends StatelessWidget {
  final List<GymEntity> gyms;
  final LocationEntity location;
  final GymEntity initialGym;

  const _GymSearchWidget({
    Key? key,
    required this.gyms,
    required this.location,
    required this.initialGym,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<_GymSearchState>(
        create: (context) => _GymSearchState(initialGym),
        builder: (context, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              40.verticalSpace,
              Container(
                padding: EdgeInsets.only(
                  left: 8.w,
                ),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: StyledBackButton(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Consumer<_GymSearchState>(
                  builder: (context, state, child) {
                    final cards = gyms
                        .where(
                          (gym) => gym.containsIgnoreCase(
                            state.searchController.text.trim(),
                          ),
                        )
                        .map(
                          (gym) => _GymCard(
                            gym: gym,
                            distance: location.distanceTo(
                              gym.location,
                            ),
                            selected: state.gym == gym,
                            onPressed: () => state.gym = gym,
                          ),
                        )
                        .toList();
                    return CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: <Widget>[
                        SliverAppBar(
                          leading: Container(),
                          elevation: 0,
                          leadingWidth: 0,
                          backgroundColor: Colors.white,
                          floating: true,
                          primary: false,
                          toolbarHeight: 50.h,
                          centerTitle: true,
                          title: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: StyledTextField(
                              hint: 'Search',
                              maxLines: 1,
                              height: 70.h,
                              errorMaxLines: 0,
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.streetAddress,
                              width: 328.w,
                              controller: state.searchController,
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(cards),
                        ),
                      ],
                    );
                  },
                ),
              ),
              StyledButton(
                text: 'CONFIRM',
                onPressed: () => Navigator.pop(
                  context,
                  Provider.of<_GymSearchState>(context, listen: false).gym,
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      );
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<RegistrationBloc>(
        create: (context) => RegistrationBloc(),
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
            if (state is RegistrationLoading) {
              return Scaffold(
                body: Column(
                  children: [
                    double.infinity.horizontalSpace,
                    220.verticalSpace,
                    CircularProgressIndicator(),
                    24.verticalSpace,
                    Text(
                      "Registering...",
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: SizedBox(
                    height: 1.sh,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: state.pageController,
                            onPageChanged: (value) =>
                                context.read<RegistrationBloc>().swipe(value),
                            itemCount: state.pageScrollLimit,
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return Column(
                                    children: [
                                      40.verticalSpace,
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 8.w,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: StyledBackButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                      (32 - keyboardPadding / 10).verticalSpace,
                                      Text(
                                        "Let's get started!\nWhat can we call you?",
                                        style: theme.textTheme.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      36.verticalSpace,
                                      SizedBox(
                                        width: 291.w,
                                        child: Form(
                                          key: state.pageOneFormKey,
                                          autovalidateMode:
                                              state.autovalidateMode,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StyledUnderlinedTextField(
                                                errorMaxLines: 1,
                                                hint: 'First name',
                                                controller:
                                                    state.firstNameController,
                                                validator: (value) =>
                                                    validateName(value),
                                                textInputAction:
                                                    TextInputAction.next,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                onChanged: (value) => context
                                                    .read<RegistrationBloc>()
                                                    .editedPageOne(),
                                                focusNode:
                                                    state.firstNameFocusNode,
                                              ),
                                              8.verticalSpace,
                                              StyledUnderlinedTextField(
                                                errorMaxLines: 1,
                                                hint: 'Last name',
                                                controller:
                                                    state.lastNameController,
                                                validator: (value) =>
                                                    validateName(value),
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                onFieldSubmitted: (val) =>
                                                    context
                                                        .read<
                                                            RegistrationBloc>()
                                                        .submitPageOne(),
                                                onChanged: (value) => context
                                                    .read<RegistrationBloc>()
                                                    .editedPageOne(),
                                                focusNode:
                                                    state.lastNameFocusNode,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (105 - keyboardPadding / 3).verticalSpace,
                                      StyledButton(
                                        onPressed: () => context
                                            .read<RegistrationBloc>()
                                            .submitPageOne(),
                                        text: "NEXT",
                                      ),
                                    ],
                                  );
                                case 1:
                                  return Column(
                                    children: [
                                      (120 - keyboardPadding / 4).verticalSpace,
                                      Text(
                                        "Hi, ${state.firstNameController.text.trim()}.\nLet's make an account.",
                                        style: theme.textTheme.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      32.verticalSpace,
                                      SizedBox(
                                        width: 291.w,
                                        child: Form(
                                          key: state.pageTwoFormKey,
                                          autovalidateMode:
                                              state.autovalidateMode,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StyledUnderlinedTextField(
                                                errorMaxLines: 1,
                                                hint: 'Email',
                                                controller:
                                                    state.emailController,
                                                validator: (value) {
                                                  final validation =
                                                      validateEmail(value);
                                                  if (validation != null) {
                                                    return validation;
                                                  } else if (state
                                                      is GymsLoaded) {
                                                    if (state.takenEmails
                                                        .contains(value)) {
                                                      return 'Email already in use';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: state.emailFocusNode,
                                              ),
                                              StyledPasswordField(
                                                hint: 'Password',
                                                controller:
                                                    state.passwordController,
                                                validator: (value) =>
                                                    validatePassword(value),
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode:
                                                    state.passwordFocusNode,
                                              ),
                                              StyledPasswordField(
                                                hint: 'Confirm password',
                                                controller: state
                                                    .confirmPasswordController,
                                                onFieldSubmitted: (val) =>
                                                    context
                                                        .read<
                                                            RegistrationBloc>()
                                                        .submitPageTwo(),
                                                focusNode: state
                                                    .confirmPasswordFocusNode,
                                                validator: (value) => state
                                                            .passwordController
                                                            .text ==
                                                        state
                                                            .confirmPasswordController
                                                            .text
                                                    ? null
                                                    : "Passwords don't match",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (40 - keyboardPadding / 7).verticalSpace,
                                      StyledButton(
                                        onPressed: () => context
                                            .read<RegistrationBloc>()
                                            .submitPageTwo(),
                                        text: "NEXT",
                                      ),
                                    ],
                                  );
                                case 2:
                                  return Column(
                                    children: [
                                      120.verticalSpace,
                                      Text(
                                        "Let's get ready\nto meet people,\n${state.firstNameController.text.trim()}.",
                                        style: theme.textTheme.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      40.verticalSpace,
                                      Expanded(
                                        child: Builder(
                                          builder: (context) {
                                            if (state is GymsLoaded) {
                                              return Column(
                                                children: [
                                                  Text(
                                                    "Do you belong to a fitness club?",
                                                    style: theme
                                                        .textTheme.labelLarge,
                                                  ),
                                                  24.verticalSpace,
                                                  StyledComboBox<GymEntity>(
                                                    width: 311.w,
                                                    height: 34.h,
                                                    items: state.gyms
                                                        .where(
                                                          (element) =>
                                                              state.gyms
                                                                  .where((innerLoop) =>
                                                                      innerLoop
                                                                          .name ==
                                                                      element
                                                                          .name)
                                                                  .length ==
                                                              1,
                                                        )
                                                        .toList(),
                                                    hint:
                                                        'Select your fitness club',
                                                    labelBuilder: (item) =>
                                                        item.name,
                                                    initialValue: state.gym,
                                                    onChanged: (item) => context
                                                        .read<
                                                            RegistrationBloc>()
                                                        .setGym(item),
                                                  ),
                                                  70.verticalSpace,
                                                  Visibility(
                                                    visible: state
                                                        .showMustSelectGymError,
                                                    child: Text(
                                                      "You must select a fitness club.",
                                                      style: theme
                                                          .textTheme.labelLarge!
                                                          .copyWith(
                                                        color: theme.errorColor,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  28.verticalSpace,
                                                  StyledButton(
                                                    onPressed: () => context
                                                        .read<
                                                            RegistrationBloc>()
                                                        .submitPageThree(),
                                                    text: "NEXT",
                                                  ),
                                                  Spacer(),
                                                  StyledUnderlinedTextButton(
                                                    text:
                                                        "I DON'T BELONG TO A FITNESS CLUB",
                                                    onPressed: () {},
                                                  ),
                                                  32.verticalSpace,
                                                ],
                                              );
                                            } else if (state
                                                is GymsLoadingError) {
                                              return Column(
                                                children: [
                                                  24.verticalSpace,
                                                  Text(
                                                    state.failure.message,
                                                    style: theme
                                                        .textTheme.labelLarge!
                                                        .copyWith(
                                                      color: theme.errorColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  8.verticalSpace,
                                                  StyledButton(
                                                    text: 'RETRY',
                                                    onPressed: () => context
                                                        .read<
                                                            RegistrationBloc>()
                                                        .refreshGyms(),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  24.verticalSpace,
                                                  CircularProgressIndicator(),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                case 3:
                                  return Column(
                                    children: [
                                      120.verticalSpace,
                                      Text(
                                        "Is this your\nfitness club?",
                                        style: theme.textTheme.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      40.verticalSpace,
                                      Text(
                                        (state as GymsLoaded).gym!.name,
                                        style: theme.textTheme.labelLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      10.verticalSpace,
                                      Text(
                                        state.gym!.address.toString(),
                                        style: theme.textTheme.labelLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      134.verticalSpace,
                                      StyledButton(
                                        onPressed: () => context
                                            .read<RegistrationBloc>()
                                            .submitPageFour(),
                                        text: "YES",
                                      ),
                                      Spacer(),
                                      StyledUnderlinedTextButton(
                                        text: "NO, IT'S NOT",
                                        onPressed: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute<GymEntity>(
                                            builder: (context2) =>
                                                _GymSearchWidget(
                                              gyms: state.gyms,
                                              location: state.location,
                                              initialGym: state.gym!,
                                            ),
                                          ),
                                        ).then(
                                          (gym) {
                                            if (gym != null) {
                                              context
                                                  .read<RegistrationBloc>()
                                                  .setGym(gym);
                                            }
                                          },
                                        ),
                                      ),
                                      32.verticalSpace,
                                    ],
                                  );
                                case 4:
                                  return Column(
                                    children: [
                                      96.verticalSpace,
                                      Text(
                                        "Let's put a face\nto your name",
                                        style: theme.textTheme.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      30.verticalSpace,
                                      Text(
                                        "Add a photo of yourself\n**from the SHOULDERS UP**\n\nJust enough for your gym buddies\nto recognize you!",
                                        style: theme.textTheme.labelLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      12.verticalSpace,
                                      Container(
                                        width: 160.h,
                                        child: Image.asset(
                                          'assets/images/pfp_meme.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      30.verticalSpace,
                                      StyledButton(
                                        onPressed: () => context
                                            .read<RegistrationBloc>()
                                            .submitPageFive(null),
                                        text: 'TAKE PHOTO',
                                      ),
                                      Spacer(),
                                      StyledUnderlinedTextButton(
                                        onPressed: () => ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery)
                                            .then(
                                          (image) {
                                            if (image != null) {
                                              context
                                                  .read<RegistrationBloc>()
                                                  .submitPageFive(image);
                                            }
                                          },
                                        ),
                                        text: 'UPLOAD FROM ALBUMS',
                                      ),
                                      32.verticalSpace,
                                    ],
                                  );
                                case 5:
                                  if (state is ProfilePictureUploaded) {
                                    return Column(
                                      children: [
                                        40.verticalSpace,
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              alignment:
                                                  FractionalOffset.bottomCenter,
                                              image: XFileImage(
                                                state.profilePicture,
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 1.sw,
                                            height: 333.h,
                                          ),
                                        ),
                                        20.verticalSpace,
                                        Builder(
                                          builder: (context) {
                                            if (state
                                                is RegistrationRequestErrorState) {
                                              return Column(
                                                children: [
                                                  Text(
                                                    state.failure.message,
                                                    textAlign: TextAlign.center,
                                                    style: theme
                                                        .textTheme.labelLarge!
                                                        .copyWith(
                                                      color: theme.errorColor,
                                                    ),
                                                  ),
                                                  8.verticalSpace,
                                                  StyledButton(
                                                    text: 'RETRY',
                                                    onPressed: () => context
                                                        .read<
                                                            RegistrationBloc>()
                                                        .submitPageSix(),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return StyledButton(
                                                text: 'CONFIRM',
                                                onPressed: () => context
                                                    .read<RegistrationBloc>()
                                                    .submitPageSix(),
                                              );
                                            }
                                          },
                                        ),
                                        StyledUnderlinedTextButton(
                                          text: 'RETAKE',
                                          onPressed: () => context
                                              .read<RegistrationBloc>()
                                              .setProfilePicture(null),
                                        ),
                                        Spacer(),
                                        StyledUnderlinedTextButton(
                                          text: 'ALBUMS',
                                          onPressed: () => ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then(
                                            (image) {
                                              if (image != null) {
                                                context
                                                    .read<RegistrationBloc>()
                                                    .setProfilePicture(image);
                                              }
                                            },
                                          ),
                                        ),
                                        32.verticalSpace,
                                      ],
                                    );
                                  } else {
                                    final cameraController =
                                        (state as GymsLoaded).cameraController;
                                    return Column(
                                      children: [
                                        40.verticalSpace,
                                        Container(
                                          width: 1.sw,
                                          height: 320.h,
                                          child: ClipRect(
                                            child: OverflowBox(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: SizedBox(
                                                  width: 1.sw,
                                                  height: 1.sh /
                                                      cameraController
                                                          .value.aspectRatio,
                                                  child: CameraPreview(
                                                    cameraController,
                                                    child: Center(
                                                      child: Opacity(
                                                        opacity: 0.75,
                                                        child: Image.asset(
                                                          'assets/images/profile_picture_mask.png',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        20.verticalSpace,
                                        Builder(
                                          builder: (context) {
                                            return (state
                                                    is UploadPictureLoading)
                                                ? CircularProgressIndicator()
                                                : OutlinedButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              RegistrationBloc>()
                                                          .uploadingPicture();
                                                      state.cameraController
                                                          .takePicture()
                                                          .then(
                                                            (image) => context
                                                                .read<
                                                                    RegistrationBloc>()
                                                                .setProfilePicture(
                                                                    image),
                                                          );
                                                    },
                                                    child: Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.white,
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.black,
                                                      ),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          },
                                        ),
                                        Spacer(),
                                        StyledUnderlinedTextButton(
                                          text: 'ALBUMS',
                                          onPressed: () => ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then(
                                            (image) {
                                              if (image != null) {
                                                context
                                                    .read<RegistrationBloc>()
                                                    .setProfilePicture(image);
                                              }
                                            },
                                          ),
                                        ),
                                        32.verticalSpace,
                                      ],
                                    );
                                  }
                              }
                              return Container();
                            },
                          ),
                        ),
                        StyledPageIndicator(
                          currentPage: state.pageIndex,
                          totalPages: 6,
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

import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

class ProfilePictureBloc
    extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  ProfilePictureBloc() : super(InitialState());
}

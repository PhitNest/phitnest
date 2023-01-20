import 'package:async/async.dart';

import '../../../../domain/use_cases/use_cases.dart';
import './registration_state.dart';

class InitialState extends RegistrationState {
  final CancelableOperation<LocationAndGymsResponse> loadGymsOp;

  const InitialState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required this.loadGymsOp,
  }) : super();

  @override
  List<Object?> get props =>
      [super.props, loadGymsOp.isCompleted, loadGymsOp.isCanceled];
}

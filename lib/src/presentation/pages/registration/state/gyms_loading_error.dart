import '../../../../common/failure.dart';
import 'register_base.dart';

class GymsLoadingErrorState extends RegistrationBase {
  final Failure failure;

  const GymsLoadingErrorState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

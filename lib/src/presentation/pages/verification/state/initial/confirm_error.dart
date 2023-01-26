import '../../../../../common/failure.dart';
import '../verification_state.dart';

class ConfirmErrorState extends InitialState {
  final Failure failure;

  const ConfirmErrorState({
    required super.codeController,
    required super.codeFocusNode,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

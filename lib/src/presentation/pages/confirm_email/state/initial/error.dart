import '../../../../../common/failure.dart';
import 'initial.dart';

class ErrorState extends InitialState {
  final Failure failure;

  const ErrorState({
    required super.codeFocusNode,
    required super.codeController,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        failure,
      ];
}

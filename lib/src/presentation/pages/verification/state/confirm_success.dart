import '../../../../data/backend/backend.dart';
import 'initial.dart';

class ConfirmSuccessState extends InitialState {
  final LoginResponse? response;

  const ConfirmSuccessState({
    required this.response,
    required super.codeController,
    required super.codeFocusNode,
  }) : super();

  @override
  List<Object> get props => [response ?? ""];
}

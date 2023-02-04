part of verification_page;

class _SuccessState extends _InitialState {
  final LoginResponse? response;

  const _SuccessState({
    required this.response,
  }) : super();

  @override
  List<Object> get props => [response ?? ""];
}

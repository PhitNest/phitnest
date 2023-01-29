import '../backend.dart';

class EmptyResponse extends Response<EmptyResponse> {
  const EmptyResponse() : super();

  @override
  EmptyResponse fromJson(Map<String, dynamic> json) => EmptyResponse();

  @override
  List<Object?> get props => [];
}

import 'requests.dart';

class EmptyRequest extends Request {
  const EmptyRequest() : super();

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}

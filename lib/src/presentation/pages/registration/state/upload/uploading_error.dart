import '../../../../../common/failure.dart';
import 'upload.dart';

class UploadErrorState extends UploadState {
  final Failure failure;

  const UploadErrorState({
    required super.response,
    required super.password,
    required super.file,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}

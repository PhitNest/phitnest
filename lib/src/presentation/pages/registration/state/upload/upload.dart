import 'package:image_picker/image_picker.dart';

import '../registration_state.dart';

export 'uploading.dart';
export 'uploading_error.dart';
export 'upload_success.dart';

abstract class UploadState extends RegisterSuccessState {
  final XFile file;

  const UploadState({
    required super.response,
    required super.password,
    required this.file,
  }) : super();

  @override
  List<Object> get props => [super.props, file];
}

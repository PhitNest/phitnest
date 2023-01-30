import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';

class GetUploadUrlResponseParser extends Parser<GetUploadUrlResponse> {
  const GetUploadUrlResponseParser() : super();

  @override
  GetUploadUrlResponse fromJson(Map<String, dynamic> json) =>
      GetUploadUrlResponse(
        url: json['url'],
      );
}

class GetUploadUrlResponse extends Equatable {
  final String url;

  const GetUploadUrlResponse({
    required this.url,
  }) : super();

  @override
  List<Object?> get props => [url];
}

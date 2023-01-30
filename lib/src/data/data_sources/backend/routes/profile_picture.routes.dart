import '../requests/requests.dart';
import '../responses/responses.dart';
import 'routes.dart';

const kGetUploadUrlUnauthorized =
    Route<GetUploadUrlUnauthorizedRequest, GetUploadUrlResponse>(
        "/profilePicture/unauthorized",
        HttpMethod.get,
        GetUploadUrlResponseParser());

const kGetUploadUrl = Route<EmptyRequest, GetUploadUrlResponse>(
    "/profilePicture/upload", HttpMethod.get, GetUploadUrlResponseParser());

import 'failure.dart';

/// HTTP Status Code
const kStatusContinue = 100; // RFC 7231; 6.2.1
const kStatusSwitchingProtocols = 101; // RFC 7231; 6.2.2
const kStatusProcessing = 102; // RFC 2518; 10.1
const kStatusEarlyHints = 103; // RFC 8297
const kStatusOK = 200; // RFC 7231; 6.3.1
const kStatusCreated = 201; // RFC 7231; 6.3.2
const kStatusAccepted = 202; // RFC 7231; 6.3.3
const kStatusNonAuthoritativeInfo = 203; // RFC 7231; 6.3.4
const kStatusNoContent = 204; // RFC 7231; 6.3.5
const kStatusResetContent = 205; // RFC 7231; 6.3.6
const kStatusPartialContent = 206; // RFC 7233; 4.1
const kStatusMultiStatus = 207; // RFC 4918; 11.1
const kStatusAlreadyReported = 208; // RFC 5842; 7.1
const kStatusIMUsed = 226; // RFC 3229; 10.4.1
const kStatusMultipleChoices = 300; // RFC 7231; 6.4.1
const kStatusMovedPermanently = 301; // RFC 7231; 6.4.2
const kStatusFound = 302; // RFC 7231; 6.4.3
const kStatusSeeOther = 303; // RFC 7231; 6.4.4
const kStatusNotModified = 304; // RFC 7232; 4.1
const kStatusUseProxy = 305; // RFC 7231; 6.4.5
const kStatusTemporaryRedirect = 307; // RFC 7231; 6.4.7
const kStatusPermanentRedirect = 308; // RFC 7538; 3
const kStatusBadRequest = 400; // RFC 7231; 6.5.1
const kStatusUnauthorized = 401; // RFC 7235; 3.1
const kStatusPaymentRequired = 402; // RFC 7231; 6.5.2
const kStatusForbidden = 403; // RFC 7231; 6.5.3
const kStatusNotFound = 404; // RFC 7231; 6.5.4
const kStatusMethodNotAllowed = 405; // RFC 7231; 6.5.5
const kStatusNotAcceptable = 406; // RFC 7231; 6.5.6
const kStatusProxyAuthRequired = 407; // RFC 7235; 3.2
const kStatusRequestTimeout = 408; // RFC 7231; 6.5.7
const kStatusConflict = 409; // RFC 7231; 6.5.8
const kStatusGone = 410; // RFC 7231; 6.5.9
const kStatusLengthRequired = 411; // RFC 7231; 6.5.10
const kStatusPreconditionFailed = 412; // RFC 7232; 4.2
const kStatusRequestEntityTooLarge = 413; // RFC 7231; 6.5.11
const kStatusRequestURITooLong = 414; // RFC 7231; 6.5.12
const kStatusUnsupportedMediaType = 415; // RFC 7231; 6.5.13
const kStatusRequestedRangeNotSatisfiable = 416; // RFC 7233; 4.4
const kStatusExpectationFailed = 417; // RFC 7231; 6.5.14
const kStatusTeapot = 418; // RFC 7168; 2.3.3
const kStatusMisdirectedRequest = 421; // RFC 7540; 9.1.2
const kStatusUnprocessableEntity = 422; // RFC 4918; 11.2
const kStatusLocked = 423; // RFC 4918; 11.3
const kStatusFailedDependency = 424; // RFC 4918; 11.4
const kStatusTooEarly = 425; // RFC 8470; 5.2.
const kStatusUpgradeRequired = 426; // RFC 7231; 6.5.15
const kStatusPreconditionRequired = 428; // RFC 6585; 3
const kStatusTooManyRequests = 429; // RFC 6585; 4
const kStatusRequestHeaderFieldsTooLarge = 431; // RFC 6585; 5
const kStatusUnavailableForLegalReasons = 451; // RFC 7725; 3
const kStatusInternalServerError = 500; // RFC 7231; 6.6.1
const kStatusNotImplemented = 501; // RFC 7231; 6.6.2
const kStatusBadGateway = 502; // RFC 7231; 6.6.3
const kStatusServiceUnavailable = 503; // RFC 7231; 6.6.4
const kStatusGatewayTimeout = 504; // RFC 7231; 6.6.5
const kStatusHTTPVersionNotSupported = 505; // RFC 7231; 6.6.6
const kStatusVariantAlsoNegotiates = 506; // RFC 2295; 8.1
const kStatusInsufficientStorage = 507; // RFC 4918; 11.5
const kStatusLoopDetected = 508; // RFC 5842; 7.2
const kStatusNotExtended = 510; // RFC 2774; 7
const kStatusNetworkAuthenticationRequired = 511; // RFC 6585; 6

// Failures
final locationFailure =
    Failure("LocationDenied", "Location permissions are denied.");

final locationPermanentlyDeniedFailure = Failure("LocationPermanentlyDenied",
    "Location permissions are permanently denied, we cannot request permissions.");

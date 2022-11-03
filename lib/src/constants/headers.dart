/// The HTTP Headers
const String kHeaderAuthorization = 'Authorization';
const String kHeaderProxyAuthenticate = 'Proxy-Authenticate';
const String kHeaderProxyAuthorization = 'Proxy-Authorization';
const String kHeaderWWWAuthenticate = 'WWW-Authenticate';
const String kHeaderAge = 'Age';
const String kHeaderCacheControl = 'Cache-Control';
const String kHeaderClearSiteData = 'Clear-Site-Data';
const String kHeaderExpires = 'Expires';
const String kHeaderPragma = 'Pragma';
const String kHeaderWarning = 'Warning';
const String kHeaderAcceptCH = 'Accept-CH';
const String kHeaderAcceptCHLifetime = 'Accept-CH-Lifetime';
const String kHeaderContentDPR = 'Content-DPR';
const String kHeaderDPR = 'DPR';
const String kHeaderEarlyData = 'Early-Data';
const String kHeaderSaveData = 'Save-Data';
const String kHeaderViewportWidth = 'Viewport-Width';
const String kHeaderWidth = 'Width';
const String kHeaderETag = 'ETag';
const String kHeaderIfMatch = 'If-Match';
const String kHeaderIfModifiedSince = 'If-Modified-Since';
const String kHeaderIfNoneMatch = 'If-None-Match';
const String kHeaderIfUnmodifiedSince = 'If-Unmodified-Since';
const String kHeaderLastModified = 'Last-Modified';
const String kHeaderVary = 'Vary';
const String kHeaderConnection = 'Connection';
const String kHeaderKeepAlive = 'Keep-Alive';
const String kHeaderAccept = 'Accept';
const String kHeaderAcceptCharset = 'Accept-Charset';
const String kHeaderAcceptEncoding = 'Accept-Encoding';
const String kHeaderAcceptLanguage = 'Accept-Language';
const String kHeaderCookie = 'Cookie';
const String kHeaderExpect = 'Expect';
const String kHeaderMaxForwards = 'Max-Forwards';
const String kHeaderSetCookie = 'Set-Cookie';
const String kHeaderAccessControlAllowCredentials =
    'Access-Control-Allow-Credentials';
const String kHeaderAccessControlAllowHeaders = 'Access-Control-Allow-Headers';
const String kHeaderAccessControlAllowMethods = 'Access-Control-Allow-Methods';
const String kHeaderAccessControlAllowOrigin = 'Access-Control-Allow-Origin';
const String kHeaderAccessControlExposeHeaders =
    'Access-Control-Expose-Headers';
const String kHeaderAccessControlMaxAge = 'Access-Control-Max-Age';
const String kHeaderAccessControlRequestHeaders =
    'Access-Control-Request-Headers';
const String kHeaderAccessControlRequestMethod =
    'Access-Control-Request-Method';
const String kHeaderOrigin = 'Origin';
const String kHeaderTimingAllowOrigin = 'Timing-Allow-Origin';
const String kHeaderXPermittedCrossDomainPolicies =
    'X-Permitted-Cross-Domain-Policies';
const String kHeaderDNT = 'DNT';
const String kHeaderTk = 'Tk';
const String kHeaderContentDisposition = 'Content-Disposition';
const String kHeaderContentEncoding = 'Content-Encoding';
const String kHeaderContentLanguage = 'Content-Language';
const String kHeaderContentLength = 'Content-Length';
const String kHeaderContentLocation = 'Content-Location';
const String kHeaderContentType = 'Content-Type';
const String kHeaderForwarded = 'Forwarded';
const String kHeaderVia = 'Via';
const String kHeaderXForwardedFor = 'X-Forwarded-For';
const String kHeaderXForwardedHost = 'X-Forwarded-Host';
const String kHeaderXForwardedProto = 'X-Forwarded-Proto';
const String kHeaderXForwardedProtocol = 'X-Forwarded-Protocol';
const String kHeaderXForwardedSsl = 'X-Forwarded-Ssl';
const String kHeaderXUrlScheme = 'X-Url-Scheme';
const String kHeaderLocation = 'Location';
const String kHeaderFrom = 'From';
const String kHeaderHost = 'Host';
const String kHeaderReferer = 'Referer';
const String kHeaderReferrerPolicy = 'Referrer-Policy';
const String kHeaderUserAgent = 'User-Agent';
const String kHeaderAllow = 'Allow';
const String kHeaderServer = 'Server';
const String kHeaderAcceptRanges = 'Accept-Ranges';
const String kHeaderContentRange = 'Content-Range';
const String kHeaderIfRange = 'If-Range';
const String kHeaderRange = 'Range';
const String kHeaderContentSecurityPolicy = 'Content-Security-Policy';
const String kHeaderContentSecurityPolicyReportOnly =
    'Content-Security-Policy-Report-Only';
const String kHeaderCrossOriginResourcePolicy = 'Cross-Origin-Resource-Policy';
const String kHeaderExpectCT = 'Expect-CT';
const String kHeaderFeaturePolicy = 'Feature-Policy';
const String kHeaderPublicKeyPins = 'Public-Key-Pins';
const String kHeaderPublicKeyPinsReportOnly = 'Public-Key-Pins-Report-Only';
const String kHeaderStrictTransportSecurity = 'Strict-Transport-Security';
const String kHeaderUpgradeInsecureRequests = 'Upgrade-Insecure-Requests';
const String kHeaderXContentTypeOptions = 'X-Content-Type-Options';
const String kHeaderXDownloadOptions = 'X-Download-Options';
const String kHeaderXFrameOptions = 'X-Frame-Options';
const String kHeaderXPoweredBy = 'X-Powered-By';
const String kHeaderXXSSProtection = 'X-XSS-Protection';
const String kHeaderLastEventID = 'Last-Event-ID';
const String kHeaderNEL = 'NEL';
const String kHeaderPingFrom = 'Ping-From';
const String kHeaderPingTo = 'Ping-To';
const String kHeaderReportTo = 'Report-To';
const String kHeaderTE = 'TE';
const String kHeaderTrailer = 'Trailer';
const String kHeaderTransferEncoding = 'Transfer-Encoding';
const String kHeaderSecWebSocketAccept = 'Sec-WebSocket-Accept';
const String kHeaderSecWebSocketExtensions = 'Sec-WebSocket-Extensions';
const String kHeaderSecWebSocketKey = 'Sec-WebSocket-Key';
const String kHeaderSecWebSocketProtocol = 'Sec-WebSocket-Protocol';
const String kHeaderSecWebSocketVersion = 'Sec-WebSocket-Version';
const String kHeaderAcceptPatch = 'Accept-Patch';
const String kHeaderAcceptPushPolicy = 'Accept-Push-Policy';
const String kHeaderAcceptSignature = 'Accept-Signature';
const String kHeaderAltSvc = 'Alt-Svc';
const String kHeaderDate = 'Date';
const String kHeaderIndex = 'Index';
const String kHeaderLargeAllocation = 'Large-Allocation';
const String kHeaderLink = 'Link';
const String kHeaderPushPolicy = 'Push-Policy';
const String kHeaderRetryAfter = 'Retry-After';
const String kHeaderServerTiming = 'Server-Timing';
const String kHeaderSignature = 'Signature';
const String kHeaderSignedHeaders = 'Signed-Headers';
const String kHeaderSourceMap = 'SourceMap';
const String kHeaderUpgrade = 'Upgrade';
const String kHeaderXDNSPrefetchControl = 'X-DNS-Prefetch-Control';
const String kHeaderXPingback = 'X-Pingback';
const String kHeaderXRequestID = 'X-Request-ID';
const String kHeaderXRequestedWith = 'X-Requested-With';
const String kHeaderXRobotsTag = 'X-Robots-Tag';
const String kHeaderXUACompatible = 'X-UA-Compatible';
package funk.net.http;

enum HttpStatusCode {
    HttpInformational(code : HttpInformational);
    HttpSuccess(code : HttpSuccess);
    HttpRedirection(code : HttpRedirection);
    HttpClientError(code : HttpClientError);
    HttpServerError(code : HttpServerError);
}

enum HttpInformational {
    Continue;
    SwitchingProtocols;
    Processing;
}

enum HttpSuccess {
    OK;
    Created;
    Accepted;
    NonAuthoritativeInformation;
    NoContent;
    ResetContent;
    PartialContent;
    MultiStatus;
    AlreadyReported;
    IMUsed;
    AuthenticationSuccessful;
}

enum HttpRedirection {
    MultipleChoices;
    MovedPermanently;
    Found;
    SeeOther;
    NotModified;
    UseProxy;
    SwitchProxy;
    TemporaryRedirect;
    PermanentRedirect;
}

enum HttpClientError {
    BadRequest;
    Unauthorized;
    PaymentRequired;
    Forbidden;
    NotFound;
    MethodNotAllowed;
    NotAcceptable;
    ProxyAuthenticationRequired;
    RequestTimeout;
    Conflict;
    Gone;
    LengthRequired;
    PreconditionFailed;
    RequestEntityTooLarge;
    RequestUriTooLong;
    UnsupportedMediaType;
    RequestedRangeNotSatisfiable;
    ExpectationFailed;
    ImATeapot;
    EnhanceYourCalm;
    TooManyConnections;
    UnprocessableEntity;
    Locked;
    Failure;
    UnorderedCollection;
    UpgradeRequired;
    PreconditionRequired;
    TooManyRequests;
    RequestHeaderFieldsTooLarge;
    NoResponse;
    RetryWith;
    BlockedByWindowsParentalControls;
    Redirect;
    RequestHeaderTooLarget;
    CertError;
    NoCert;
    HttpToHttps;
    ClientClosedRequest;
}

enum HttpServerError {
    InternalServerError;
    NotImplemented;
    BadGateway;
    ServiceUnavailable;
    GatewayTimeout;
    HTTPVersionNotSupported;
    VariantAlsoNegotiates;
    InsufficientStorage;
    LoopDetected;
    BandwidthLimitExceeded;
    NotExtended;
    NetworkAuthenticationRequired;
    AccessDenied;
    NetworkReadTimeoutError;
    NetworkConnectTimeoutError;
}

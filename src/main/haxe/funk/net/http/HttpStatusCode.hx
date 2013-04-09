package funk.net.http;

enum HttpStatusCode {
    HttpUnknown(code : Int);
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

class HttpStatusCodeTypes {

    public static function isHttpInformational(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpInformational(_): true;
            default: false;
        }
    }

    public static function isHttpSuccess(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpSuccess(_): true;
            default: false;
        }
    }

    public static function isHttpRedirection(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpRedirection(_): true;
            default: false;
        }
    }

    public static function isHttpClientError(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpClientError(_): true;
            default: false;
        }
    }

    public static function isHttpServerError(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpServerError(_): true;
            default: false;
        }
    }

    public static function toHttpStatusCode(code : Int) : HttpStatusCode {
        // Note (Simon) : This has to be this way so we pass full coverage (I'd rather use a switch tbh)
        return if (code >= 100 && code <= 199) {

            if (code == 100) { HttpInformational(Continue); }
            else if (code == 101) { HttpInformational(SwitchingProtocols); }
            else if (code == 102) { HttpInformational(Processing); }
            else { HttpUnknown(code); }

        } else if (code >= 200 && code <= 299) {

            if (code == 200) { HttpSuccess(OK); }
            else if (code == 201) { HttpSuccess(Created); }
            else if (code == 202) { HttpSuccess(Accepted); }
            else if (code == 203) { HttpSuccess(NonAuthoritativeInformation); }
            else if (code == 204) { HttpSuccess(NoContent); }
            else if (code == 205) { HttpSuccess(ResetContent); }
            else if (code == 206) { HttpSuccess(PartialContent); }
            else if (code == 207) { HttpSuccess(MultiStatus); }
            else if (code == 208) { HttpSuccess(AlreadyReported); }
            else if (code == 226) { HttpSuccess(IMUsed); }
            else if (code == 230) { HttpSuccess(AuthenticationSuccessful); }
            else { HttpUnknown(code); }

        } else if (code >= 300 && code <= 399) {

            if (code == 300) { HttpRedirection(MultipleChoices); }
            else if (code == 301) { HttpRedirection(MovedPermanently); }
            else if (code == 302) { HttpRedirection(Found); }
            else if (code == 303) { HttpRedirection(SeeOther); }
            else if (code == 304) { HttpRedirection(NotModified); }
            else if (code == 305) { HttpRedirection(UseProxy); }
            else if (code == 306) { HttpRedirection(SwitchProxy); }
            else if (code == 307) { HttpRedirection(TemporaryRedirect); }
            else if (code == 308) { HttpRedirection(PermanentRedirect); }
            else { HttpUnknown(code); }

        } else if (code >= 400 && code <= 499) {

            if (code == 400) { HttpClientError(BadRequest); }
            else if (code == 401) { HttpClientError(Unauthorized); }
            else if (code == 402) { HttpClientError(PaymentRequired); }
            else if (code == 403) { HttpClientError(Forbidden); }
            else if (code == 404) { HttpClientError(NotFound); }
            else if (code == 405) { HttpClientError(MethodNotAllowed); }
            else if (code == 406) { HttpClientError(NotAcceptable); }
            else if (code == 407) { HttpClientError(ProxyAuthenticationRequired); }
            else if (code == 408) { HttpClientError(RequestTimeout); }
            else if (code == 409) { HttpClientError(Conflict); }
            else if (code == 410) { HttpClientError(Gone); }
            else if (code == 411) { HttpClientError(LengthRequired); }
            else if (code == 412) { HttpClientError(PreconditionFailed); }
            else if (code == 413) { HttpClientError(RequestEntityTooLarge); }
            else if (code == 414) { HttpClientError(RequestUriTooLong); }
            else if (code == 415) { HttpClientError(UnsupportedMediaType); }
            else if (code == 416) { HttpClientError(RequestedRangeNotSatisfiable); }
            else if (code == 417) { HttpClientError(ExpectationFailed); }
            else if (code == 418) { HttpClientError(ImATeapot); }
            else if (code == 420) { HttpClientError(EnhanceYourCalm); }
            else if (code == 421) { HttpClientError(TooManyConnections); }
            else if (code == 422) { HttpClientError(UnprocessableEntity); }
            else if (code == 423) { HttpClientError(Locked); }
            else if (code == 424) { HttpClientError(Failure); }
            else if (code == 425) { HttpClientError(UnorderedCollection); }
            else if (code == 426) { HttpClientError(UpgradeRequired); }
            else if (code == 428) { HttpClientError(PreconditionRequired); }
            else if (code == 429) { HttpClientError(TooManyRequests); }
            else if (code == 431) { HttpClientError(RequestHeaderFieldsTooLarge); }
            else if (code == 444) { HttpClientError(NoResponse); }
            else if (code == 449) { HttpClientError(RetryWith); }
            else if (code == 450) { HttpClientError(BlockedByWindowsParentalControls); }
            else if (code == 451) { HttpClientError(Redirect); }
            else if (code == 494) { HttpClientError(RequestHeaderTooLarget); }
            else if (code == 495) { HttpClientError(CertError); }
            else if (code == 496) { HttpClientError(NoCert); }
            else if (code == 497) { HttpClientError(HttpToHttps); }
            else if (code == 499) { HttpClientError(ClientClosedRequest); }
            else { HttpUnknown(code); }

        } else if (code >= 500 && code <= 599)  {

            if (code == 500) { HttpServerError(InternalServerError); }
            else if (code == 501) { HttpServerError(NotImplemented); }
            else if (code == 502) { HttpServerError(BadGateway); }
            else if (code == 503) { HttpServerError(ServiceUnavailable); }
            else if (code == 504) { HttpServerError(GatewayTimeout); }
            else if (code == 505) { HttpServerError(HTTPVersionNotSupported); }
            else if (code == 506) { HttpServerError(VariantAlsoNegotiates); }
            else if (code == 507) { HttpServerError(InsufficientStorage); }
            else if (code == 508) { HttpServerError(LoopDetected); }
            else if (code == 509) { HttpServerError(BandwidthLimitExceeded); }
            else if (code == 510) { HttpServerError(NotExtended); }
            else if (code == 511) { HttpServerError(NetworkAuthenticationRequired); }
            else if (code == 531) { HttpServerError(AccessDenied); }
            else if (code == 598) { HttpServerError(NetworkReadTimeoutError); }
            else if (code == 599) { HttpServerError(NetworkConnectTimeoutError); }
            else { HttpUnknown(code); }

        } else {

            HttpUnknown(code);

        }
    }

    public static function toStatusCode(code : HttpStatusCode) : Int {
        return switch(code) {
            case HttpInformational(Continue): 100;
            case HttpInformational(SwitchingProtocols): 101;
            case HttpInformational(Processing): 102;
            case HttpSuccess(OK): 200;
            case HttpSuccess(Created): 201;
            case HttpSuccess(Accepted): 202;
            case HttpSuccess(NonAuthoritativeInformation): 203;
            case HttpSuccess(NoContent): 204;
            case HttpSuccess(ResetContent): 205;
            case HttpSuccess(PartialContent): 206;
            case HttpSuccess(MultiStatus): 207;
            case HttpSuccess(AlreadyReported): 208;
            case HttpSuccess(IMUsed): 226;
            case HttpSuccess(AuthenticationSuccessful): 230;
            case HttpRedirection(MultipleChoices): 300;
            case HttpRedirection(MovedPermanently): 301;
            case HttpRedirection(Found): 302;
            case HttpRedirection(SeeOther): 303;
            case HttpRedirection(NotModified): 304;
            case HttpRedirection(UseProxy): 305;
            case HttpRedirection(SwitchProxy): 306;
            case HttpRedirection(TemporaryRedirect): 307;
            case HttpRedirection(PermanentRedirect): 308;
            case HttpClientError(BadRequest): 400;
            case HttpClientError(Unauthorized): 401;
            case HttpClientError(PaymentRequired): 402;
            case HttpClientError(Forbidden): 403;
            case HttpClientError(NotFound): 404;
            case HttpClientError(MethodNotAllowed): 405;
            case HttpClientError(NotAcceptable): 406;
            case HttpClientError(ProxyAuthenticationRequired): 407;
            case HttpClientError(RequestTimeout): 408;
            case HttpClientError(Conflict): 409;
            case HttpClientError(Gone): 410;
            case HttpClientError(LengthRequired): 411;
            case HttpClientError(PreconditionFailed): 412;
            case HttpClientError(RequestEntityTooLarge): 413;
            case HttpClientError(RequestUriTooLong): 414;
            case HttpClientError(UnsupportedMediaType): 415;
            case HttpClientError(RequestedRangeNotSatisfiable): 416;
            case HttpClientError(ExpectationFailed): 417;
            case HttpClientError(ImATeapot): 418;
            case HttpClientError(EnhanceYourCalm): 420;
            case HttpClientError(TooManyConnections): 421;
            case HttpClientError(UnprocessableEntity): 422;
            case HttpClientError(Locked): 423;
            case HttpClientError(Failure): 424;
            case HttpClientError(UnorderedCollection): 425;
            case HttpClientError(UpgradeRequired): 426;
            case HttpClientError(PreconditionRequired): 428;
            case HttpClientError(TooManyRequests): 429;
            case HttpClientError(RequestHeaderFieldsTooLarge): 431;
            case HttpClientError(NoResponse): 444;
            case HttpClientError(RetryWith): 449;
            case HttpClientError(BlockedByWindowsParentalControls): 450;
            case HttpClientError(Redirect): 451;
            case HttpClientError(RequestHeaderTooLarget): 494;
            case HttpClientError(CertError): 495;
            case HttpClientError(NoCert): 496;
            case HttpClientError(HttpToHttps): 497;
            case HttpClientError(ClientClosedRequest): 499;
            case HttpServerError(InternalServerError): 500;
            case HttpServerError(NotImplemented): 501;
            case HttpServerError(BadGateway): 502;
            case HttpServerError(ServiceUnavailable): 503;
            case HttpServerError(GatewayTimeout): 504;
            case HttpServerError(HTTPVersionNotSupported): 505;
            case HttpServerError(VariantAlsoNegotiates): 506;
            case HttpServerError(InsufficientStorage): 507;
            case HttpServerError(LoopDetected): 508;
            case HttpServerError(BandwidthLimitExceeded): 509;
            case HttpServerError(NotExtended): 510;
            case HttpServerError(NetworkAuthenticationRequired): 511;
            case HttpServerError(AccessDenied): 531;
            case HttpServerError(NetworkReadTimeoutError): 598;
            case HttpServerError(NetworkConnectTimeoutError): 599;
            case HttpUnknown(v): v;
        }
    }

    public static function toHttpVersion(code : HttpStatusCode) : HttpVersion {
        return switch(code) {
            case HttpInformational(Continue): Http("1.1");
            case HttpInformational(SwitchingProtocols): Http("1.1");
            case HttpInformational(Processing): WebDav("RFC 2518");
            case HttpSuccess(OK): Http("1.0");
            case HttpSuccess(Created): Http("1.0");
            case HttpSuccess(Accepted): Http("1.0");
            case HttpSuccess(NonAuthoritativeInformation): Http("1.1");
            case HttpSuccess(NoContent): Http("1.0");
            case HttpSuccess(ResetContent): Http("1.0");
            case HttpSuccess(PartialContent): Http("1.0");
            case HttpSuccess(MultiStatus): WebDav("RFC 4918");
            case HttpSuccess(AlreadyReported): WebDav("RFC 5842");
            case HttpSuccess(IMUsed): Unknown("RFC 3229");
            case HttpSuccess(AuthenticationSuccessful): Unknown("RFC 2229");
            case HttpRedirection(MultipleChoices): Http("1.0");
            case HttpRedirection(MovedPermanently): Http("1.0");
            case HttpRedirection(Found): Http("1.0");
            case HttpRedirection(SeeOther): Http("1.1");
            case HttpRedirection(NotModified): Http("1.0");
            case HttpRedirection(UseProxy): Http("1.1");
            case HttpRedirection(SwitchProxy): Http("1.0");
            case HttpRedirection(TemporaryRedirect): Http("1.1");
            case HttpRedirection(PermanentRedirect): Unknown("RFC ?");
            case HttpClientError(BadRequest): Http("1.0");
            case HttpClientError(Unauthorized): Http("1.0");
            case HttpClientError(PaymentRequired): Http("1.0");
            case HttpClientError(Forbidden): Http("1.0");
            case HttpClientError(NotFound): Http("1.0");
            case HttpClientError(MethodNotAllowed): Http("1.0");
            case HttpClientError(NotAcceptable): Http("1.0");
            case HttpClientError(ProxyAuthenticationRequired): Http("1.0");
            case HttpClientError(RequestTimeout): Http("1.0");
            case HttpClientError(Conflict): Http("1.0");
            case HttpClientError(Gone): Http("1.0");
            case HttpClientError(LengthRequired): Http("1.0");
            case HttpClientError(PreconditionFailed): Http("1.0");
            case HttpClientError(RequestEntityTooLarge): Http("1.0");
            case HttpClientError(RequestUriTooLong): Http("1.0");
            case HttpClientError(UnsupportedMediaType): Http("1.0");
            case HttpClientError(RequestedRangeNotSatisfiable): Http("1.0");
            case HttpClientError(ExpectationFailed): Http("1.0");
            case HttpClientError(ImATeapot): Unknown("RFC 2324");
            case HttpClientError(EnhanceYourCalm): Unknown("?");
            case HttpClientError(TooManyConnections): Unknown("?");
            case HttpClientError(UnprocessableEntity): WebDav("RFC 4918");
            case HttpClientError(Locked): WebDav("RFC 4918");
            case HttpClientError(Failure): WebDav("RFC 4918");
            case HttpClientError(UnorderedCollection): Unknown("?");
            case HttpClientError(UpgradeRequired): Unknown("RFC 2817");
            case HttpClientError(PreconditionRequired): Unknown("RFC 6585");
            case HttpClientError(TooManyRequests): Unknown("RFC 6585");
            case HttpClientError(RequestHeaderFieldsTooLarge): Unknown("RFC 6585");
            case HttpClientError(NoResponse): Unknown("Nginx");
            case HttpClientError(RetryWith): Unknown("Microsoft");
            case HttpClientError(BlockedByWindowsParentalControls): Unknown("Microsoft");
            case HttpClientError(Redirect): Unknown("Microsoft");
            case HttpClientError(RequestHeaderTooLarget): Unknown("Nginx");
            case HttpClientError(CertError): Unknown("Nginx");
            case HttpClientError(NoCert): Unknown("Nginx");
            case HttpClientError(HttpToHttps): Unknown("Nginx");
            case HttpClientError(ClientClosedRequest): Unknown("Nginx");
            case HttpServerError(InternalServerError): Http("1.0");
            case HttpServerError(NotImplemented): Http("1.0");
            case HttpServerError(BadGateway): Http("1.0");
            case HttpServerError(ServiceUnavailable): Http("1.0");
            case HttpServerError(GatewayTimeout): Http("1.0");
            case HttpServerError(HTTPVersionNotSupported): Http("1.0");
            case HttpServerError(VariantAlsoNegotiates): WebDav("RFC 2295");
            case HttpServerError(InsufficientStorage): WebDav("RFC 4918");
            case HttpServerError(LoopDetected): WebDav("RFC 5842");
            case HttpServerError(BandwidthLimitExceeded): Unknown("Apache");
            case HttpServerError(NotExtended): Unknown("RFC 2774");
            case HttpServerError(NetworkAuthenticationRequired): Unknown("RFC 6585");
            case HttpServerError(AccessDenied): Unknown("RFC 2229");
            case HttpServerError(NetworkReadTimeoutError): Unknown("Microsoft");
            case HttpServerError(NetworkConnectTimeoutError): Unknown("Microsoft");
            case HttpUnknown(_): Unknown("?");
        }
    }
}

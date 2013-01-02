package funk.net.http.extensions;

import funk.net.http.HttpStatusCode;
import funk.net.http.HttpVersion;

class HttpStatusCodes {

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
        return switch(code) {
            case 100: HttpInformational(Continue);
            case 101: HttpInformational(SwitchingProtocols);
            case 102: HttpInformational(Processing);

            case 200: HttpSuccess(OK);
            case 201: HttpSuccess(Created);
            case 202: HttpSuccess(Accepted);
            case 203: HttpSuccess(NonAuthoritativeInformation);
            case 204: HttpSuccess(NoContent);
            case 205: HttpSuccess(ResetContent);
            case 206: HttpSuccess(PartialContent);
            case 207: HttpSuccess(MultiStatus);
            case 208: HttpSuccess(AlreadyReported);
            case 226: HttpSuccess(IMUsed);
            case 230: HttpSuccess(AuthenticationSuccessful);

            case 300: HttpRedirection(MultipleChoices);
            case 301: HttpRedirection(MovedPermanently);
            case 302: HttpRedirection(Found);
            case 303: HttpRedirection(SeeOther);
            case 304: HttpRedirection(NotModified);
            case 305: HttpRedirection(UseProxy);
            case 306: HttpRedirection(SwitchProxy);
            case 307: HttpRedirection(TemporaryRedirect);
            case 308: HttpRedirection(PermanentRedirect);

            case 400: HttpClientError(BadRequest);
            case 401: HttpClientError(Unauthorized);
            case 402: HttpClientError(PaymentRequired);
            case 403: HttpClientError(Forbidden);
            case 404: HttpClientError(NotFound);
            case 405: HttpClientError(MethodNotAllowed);
            case 406: HttpClientError(NotAcceptable);
            case 407: HttpClientError(ProxyAuthenticationRequired);
            case 408: HttpClientError(RequestTimeout);
            case 409: HttpClientError(Conflict);
            case 410: HttpClientError(Gone);
            case 411: HttpClientError(LengthRequired);
            case 412: HttpClientError(PreconditionFailed);
            case 413: HttpClientError(RequestEntityTooLarge);
            case 414: HttpClientError(RequestUriTooLong);
            case 415: HttpClientError(UnsupportedMediaType);
            case 416: HttpClientError(RequestedRangeNotSatisfiable);
            case 417: HttpClientError(ExpectationFailed);
            case 418: HttpClientError(ImATeapot);
            case 420: HttpClientError(EnhanceYourCalm);
            case 421: HttpClientError(TooManyConnections);
            case 422: HttpClientError(UnprocessableEntity);
            case 423: HttpClientError(Locked);
            case 424: HttpClientError(Failure);
            case 425: HttpClientError(UnorderedCollection);
            case 426: HttpClientError(UpgradeRequired);
            case 428: HttpClientError(PreconditionRequired);
            case 429: HttpClientError(TooManyRequests);
            case 431: HttpClientError(RequestHeaderFieldsTooLarge);
            case 444: HttpClientError(NoResponse);
            case 449: HttpClientError(RetryWith);
            case 450: HttpClientError(BlockedByWindowsParentalControls);
            case 451: HttpClientError(Redirect);
            case 494: HttpClientError(RequestHeaderTooLarget);
            case 495: HttpClientError(CertError);
            case 496: HttpClientError(NoCert);
            case 497: HttpClientError(HttpToHttps);
            case 499: HttpClientError(ClientClosedRequest);

            case 500: HttpServerError(InternalServerError);
            case 501: HttpServerError(NotImplemented);
            case 502: HttpServerError(BadGateway);
            case 503: HttpServerError(ServiceUnavailable);
            case 504: HttpServerError(GatewayTimeout);
            case 505: HttpServerError(HTTPVersionNotSupported);
            case 506: HttpServerError(VariantAlsoNegotiates);
            case 507: HttpServerError(InsufficientStorage);
            case 508: HttpServerError(LoopDetected);
            case 509: HttpServerError(BandwidthLimitExceeded);
            case 510: HttpServerError(NotExtended);
            case 511: HttpServerError(NetworkAuthenticationRequired);
            case 531: HttpServerError(AccessDenied);
            case 598: HttpServerError(NetworkReadTimeoutError);
            case 599: HttpServerError(NetworkConnectTimeoutError);
        }
    }

    public static function toStatusCode(code : HttpStatusCode) : Int {
        return switch(code) {
            case HttpInformational(v):
                switch(v) {
                    case Continue: 100;
                    case SwitchingProtocols: 101;
                    case Processing: 102;
                }

            case HttpSuccess(v):
                switch(v) {
                    case OK: 200;
                    case Created: 201;
                    case Accepted: 202;
                    case NonAuthoritativeInformation: 203;
                    case NoContent: 204;
                    case ResetContent: 205;
                    case PartialContent: 206;
                    case MultiStatus: 207;
                    case AlreadyReported: 208;
                    case IMUsed: 226;
                    case AuthenticationSuccessful: 230;
                }

            case HttpRedirection(v):
                switch(v) {
                    case MultipleChoices: 300;
                    case MovedPermanently: 301;
                    case Found: 302;
                    case SeeOther: 303;
                    case NotModified: 304;
                    case UseProxy: 305;
                    case SwitchProxy: 306;
                    case TemporaryRedirect: 307;
                    case PermanentRedirect: 308;
                }

            case HttpClientError(v):
                switch (v) {
                    case BadRequest: 400;
                    case Unauthorized: 401;
                    case PaymentRequired: 402;
                    case Forbidden: 403;
                    case NotFound: 404;
                    case MethodNotAllowed: 405;
                    case NotAcceptable: 406;
                    case ProxyAuthenticationRequired: 407;
                    case RequestTimeout: 408;
                    case Conflict: 409;
                    case Gone: 410;
                    case LengthRequired: 411;
                    case PreconditionFailed: 412;
                    case RequestEntityTooLarge: 413;
                    case RequestUriTooLong: 414;
                    case UnsupportedMediaType: 415;
                    case RequestedRangeNotSatisfiable: 416;
                    case ExpectationFailed: 417;
                    case ImATeapot: 418;
                    case EnhanceYourCalm: 420;
                    case TooManyConnections: 421;
                    case UnprocessableEntity: 422;
                    case Locked: 423;
                    case Failure: 424;
                    case UnorderedCollection: 425;
                    case UpgradeRequired: 426;
                    case PreconditionRequired: 428;
                    case TooManyRequests: 429;
                    case RequestHeaderFieldsTooLarge: 431;
                    case NoResponse: 444;
                    case RetryWith: 449;
                    case BlockedByWindowsParentalControls: 450;
                    case Redirect: 451;
                    case RequestHeaderTooLarget: 494;
                    case CertError: 495;
                    case NoCert: 496;
                    case HttpToHttps: 497;
                    case ClientClosedRequest: 499;
                }

            case HttpServerError(v):
                switch (v) {
                    case InternalServerError: 500;
                    case NotImplemented: 501;
                    case BadGateway: 502;
                    case ServiceUnavailable: 503;
                    case GatewayTimeout: 504;
                    case HTTPVersionNotSupported: 505;
                    case VariantAlsoNegotiates: 506;
                    case InsufficientStorage: 507;
                    case LoopDetected: 508;
                    case BandwidthLimitExceeded: 509;
                    case NotExtended: 510;
                    case NetworkAuthenticationRequired: 511;
                    case AccessDenied: 531;
                    case NetworkReadTimeoutError: 598;
                    case NetworkConnectTimeoutError: 599;
                }
        }
    }

    public static function toHttpVersion(code : HttpStatusCode) : HttpVersion {
        return switch(code) {
            case HttpInformational(v):
                switch(v) {
                    case Continue: Http("1.1");
                    case SwitchingProtocols: Http("1.1");
                    case Processing: WebDav("RFC 2518");
                }

            case HttpSuccess(v):
                switch(v) {
                    case OK: Http("1.0");
                    case Created: Http("1.0");
                    case Accepted: Http("1.0");
                    case NonAuthoritativeInformation: Http("1.1");
                    case NoContent: Http("1.0");
                    case ResetContent: Http("1.0");
                    case PartialContent: Http("1.0");
                    case MultiStatus: WebDav("RFC 4918");
                    case AlreadyReported: WebDav("RFC 5842");
                    case IMUsed: Unknown("RFC 3229");
                    case AuthenticationSuccessful: Unknown("RFC 2229");
                }

            case HttpRedirection(v):
                switch(v) {
                    case MultipleChoices: Http("1.0");
                    case MovedPermanently: Http("1.0");
                    case Found: Http("1.0");
                    case SeeOther: Http("1.1");
                    case NotModified: Http("1.0");
                    case UseProxy: Http("1.1");
                    case SwitchProxy: Http("1.0");
                    case TemporaryRedirect: Http("1.1");
                    case PermanentRedirect: Unknown("RFC ?");
                }

            case HttpClientError(v):
                switch (v) {
                    case BadRequest: Http("1.0");
                    case Unauthorized: Http("1.0");
                    case PaymentRequired: Http("1.0");
                    case Forbidden: Http("1.0");
                    case NotFound: Http("1.0");
                    case MethodNotAllowed: Http("1.0");
                    case NotAcceptable: Http("1.0");
                    case ProxyAuthenticationRequired: Http("1.0");
                    case RequestTimeout: Http("1.0");
                    case Conflict: Http("1.0");
                    case Gone: Http("1.0");
                    case LengthRequired: Http("1.0");
                    case PreconditionFailed: Http("1.0");
                    case RequestEntityTooLarge: Http("1.0");
                    case RequestUriTooLong: Http("1.0");
                    case UnsupportedMediaType: Http("1.0");
                    case RequestedRangeNotSatisfiable: Http("1.0");
                    case ExpectationFailed: Http("1.0");
                    case ImATeapot: Unknown("RFC 2324");
                    case EnhanceYourCalm: Unknown("?");
                    case TooManyConnections: Unknown("?");
                    case UnprocessableEntity: WebDav("RFC 4918");
                    case Locked: WebDav("RFC 4918");
                    case Failure: WebDav("RFC 4918");
                    case UnorderedCollection: Unknown("?");
                    case UpgradeRequired: Unknown("RFC 2817");
                    case PreconditionRequired: Unknown("RFC 6585");
                    case TooManyRequests: Unknown("RFC 6585");
                    case RequestHeaderFieldsTooLarge: Unknown("RFC 6585");
                    case NoResponse: Unknown("Nginx");
                    case RetryWith: Unknown("Microsoft");
                    case BlockedByWindowsParentalControls: Unknown("Microsoft");
                    case Redirect: Unknown("Microsoft");
                    case RequestHeaderTooLarget: Unknown("Nginx");
                    case CertError: Unknown("Nginx");
                    case NoCert: Unknown("Nginx");
                    case HttpToHttps: Unknown("Nginx");
                    case ClientClosedRequest: Unknown("Nginx");
                }

            case HttpServerError(v):
                switch (v) {
                    case InternalServerError: Http("1.0");
                    case NotImplemented: Http("1.0");
                    case BadGateway: Http("1.0");
                    case ServiceUnavailable: Http("1.0");
                    case GatewayTimeout: Http("1.0");
                    case HTTPVersionNotSupported: Http("1.0");
                    case VariantAlsoNegotiates: WebDav("RFC 2295");
                    case InsufficientStorage: WebDav("RFC 4918");
                    case LoopDetected: WebDav("RFC 5842");
                    case BandwidthLimitExceeded: Unknown("Apache");
                    case NotExtended: Unknown("RFC 2774");
                    case NetworkAuthenticationRequired: Unknown("RFC 6585");
                    case AccessDenied: Unknown("RFC 2229");
                    case NetworkReadTimeoutError: Unknown("Microsoft");
                    case NetworkConnectTimeoutError: Unknown("Microsoft");
                }
        }
    }
}

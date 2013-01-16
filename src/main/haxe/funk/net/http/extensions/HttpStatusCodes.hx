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

            case HttpUnknown(v): v;
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

            case HttpUnknown(_): Unknown("?");
        }
    }
}

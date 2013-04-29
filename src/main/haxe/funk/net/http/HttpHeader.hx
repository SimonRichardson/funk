package funk.net.http;

import funk.ds.immutable.List;
import funk.types.Tuple2;
import funk.types.extensions.Strings;

using funk.types.Option;

typedef RawHttpHeader = Tuple2<String, String>;

typedef RawHttpHeaders = List<RawHttpHeader>;

enum HttpHeader {
    HttpRequest(request : HttpRequestHeader);
    HttpResponse(response : HttpResponseHeader);
}

enum HttpRequestHeader {
    Accept(value : String);
    AcceptCharset(value : String);
    AcceptEncoding(value : String);
    AcceptLanguage(value : String);
    AcceptDatetime(date : Date);
    Authorization(value : String);
    Cookie(value : String);
    ContentLength(value : Int);
    ContentMD5(value : String);
    ContentType(value : String);
    DateTime(date : Date);
    Expect(value : String);
    From(value : String);
    Host(value : String);
    IfMatch(value : String);
    IfModifiedSince(date : Date);
    IfNoneMatch(value : String);
    IfRange(value : String);
    IfUnmodifiedSince(date : Date);
    MaxForwards(value : Int);
    Pragma(value : String);
    ProxyAuthorization(value : String);
    Range(value : String);
    Referer(value : String);
    TE(value : String);
    Upgrade(value : String);
    UserAgent(value : String);
    Via(value : String);
    Warning(value : String);
    X(name : String, value : String);
}

enum HttpResponseHeader {
    AccessControlAllowOrigin(value : String);
    AcceptRanges(value : String);
    Age(value : Int);
    Allow(value : String);
    CacheControl(value : String);
    Connection(value : String);
    ContentEncoding(value : String);
    ContentLanguage(value : String);
    ContentLength(value : Int);
    ContentLocation(value : String);
    ContentMD5(value : String);
    ContentRange(value : String);
    ContentType(value : String);
    DateTime(date : Date);
    ETag(value : String);
    Expires(value : Date);
    LastModified(value : Date);
    Link(value : String);
    Location(value : String);
    P3P(value : String);
    Pragma(value : String);
    ProxyAuthenticate(value : String);
    Refresh(value : String);
    RetryAfter(value : Int);
    Server(value : String);
    SetCookie(value : String);
    StrictTransportSecurity(value : String);
    Trailer(value : String);
    TransferEncoding(value : String);
    Vary(value : String);
    Via(value : String);
    Warning(value : String);
    WWWAuthenticate(value : String);
    X(name : String, value : String);
}

class HttpHeaderTypes {

    public static function isHttpRequest(value : HttpHeader) : Bool {
        return switch(value) {
            case HttpRequest(_): true;
            case _: false;
        }
    }

    public static function isHttpResponse(value : HttpHeader) : Bool {
        return switch(value) {
            case HttpResponse(_): true;
            case _: false;
        }
    }

    public static function getHttpCustomRequest(value : HttpHeader) : Option<Tuple2<String, String>> {
        return switch(value) {
            case HttpRequest(request):
                switch(request) {
                    case X(a, b):
                        var tuple : Tuple2<String, String> = tuple2(a, b);
                        Some(tuple);
                    case _: None;
                }
            case _: None;
        }
    }

    public static function getHttpCustomResponse(value : HttpHeader) : Option<Tuple2<String, String>> {
        return switch(value) {
            case HttpResponse(response):
                switch(response) {
                    case X(a, b):
                        var tuple : Tuple2<String, String> = tuple2(a, b);
                        Some(tuple);
                    case _: None;
                }
            case _: None;
        }
    }

    public static function toHttpVersion(value : HttpHeader) : HttpVersion {
        return switch(value) {
            case HttpRequest(Accept(_)): Http("1.1");
            case HttpRequest(AcceptCharset(_)): Http("1.1");
            case HttpRequest(AcceptEncoding(_)): Http("1.1");
            case HttpRequest(AcceptLanguage(_)): Http("1.1");
            case HttpRequest(AcceptDatetime(_)): Http("1.1");
            case HttpRequest(Authorization(_)): Http("1.0");
            case HttpRequest(Cookie(_)): Http("1.0");
            case HttpRequest(ContentLength(_)): Http("1.0");
            case HttpRequest(ContentMD5(_)): Http("1.1");
            case HttpRequest(ContentType(_)): Http("1.0");
            case HttpRequest(DateTime(_)): Http("1.0");
            case HttpRequest(Expect(_)): Http("1.1");
            case HttpRequest(From(_)): Http("1.0");
            case HttpRequest(Host(_)): Http("1.1");
            case HttpRequest(IfMatch(_)): Http("1.1");
            case HttpRequest(IfModifiedSince(_)): Http("1.0");
            case HttpRequest(IfNoneMatch(_)): Http("1.1");
            case HttpRequest(IfRange(_)): Http("1.1");
            case HttpRequest(IfUnmodifiedSince(_)): Http("1.1");
            case HttpRequest(MaxForwards(_)): Http("1.1");
            case HttpRequest(Pragma(_)): Http("1.0");
            case HttpRequest(ProxyAuthorization(_)): Http("1.1");
            case HttpRequest(Range(_)): Http("1.1");
            case HttpRequest(Referer(_)): Http("1.0");
            case HttpRequest(TE(_)): Http("1.1");
            case HttpRequest(Upgrade(_)): Http("1.1");
            case HttpRequest(UserAgent(_)): Http("1.0");
            case HttpRequest(Via(_)): Http("1.1");
            case HttpRequest(Warning(_)): Http("1.1");
            case HttpRequest(X(_, _)): Unknown("");
            case HttpResponse(AccessControlAllowOrigin(_)): Http("1.1");
            case HttpResponse(AcceptRanges(_)): Http("1.1");
            case HttpResponse(Age(_)): Http("1.1");
            case HttpResponse(Allow(_)): Http("1.0");
            case HttpResponse(CacheControl(_)): Http("1.0");
            case HttpResponse(Connection(_)): Http("1.1");
            case HttpResponse(ContentEncoding(_)): Http("1.0");
            case HttpResponse(ContentLanguage(_)): Http("1.1");
            case HttpResponse(ContentLength(_)): Http("1.0");
            case HttpResponse(ContentLocation(_)): Http("1.1");
            case HttpResponse(ContentMD5(_)): Http("1.1");
            case HttpResponse(ContentRange(_)): Http("1.1");
            case HttpResponse(ContentType(_)): Http("1.0");
            case HttpResponse(DateTime(_)): Http("1.0");
            case HttpResponse(ETag(_)): Http("1.1");
            case HttpResponse(Expires(_)): Http("1.0");
            case HttpResponse(LastModified(_)): Http("1.0");
            case HttpResponse(Link(_)): Http("1.0");
            case HttpResponse(Location(_)): Http("1.0");
            case HttpResponse(P3P(_)): Http("1.0");
            case HttpResponse(Pragma(_)): Http("1.0");
            case HttpResponse(ProxyAuthenticate(_)): Http("1.1");
            case HttpResponse(Refresh(_)): Http("1.0");
            case HttpResponse(RetryAfter(_)): Http("1.1");
            case HttpResponse(Server(_)): Http("1.0");
            case HttpResponse(SetCookie(_)): Http("1.0");
            case HttpResponse(StrictTransportSecurity(_)): Http("1.0");
            case HttpResponse(Trailer(_)): Http("1.1");
            case HttpResponse(TransferEncoding(_)): Http("1.1");
            case HttpResponse(Vary(_)): Http("1.1");
            case HttpResponse(Via(_)): Http("1.1");
            case HttpResponse(Warning(_)): Http("1.1");
            case HttpResponse(WWWAuthenticate(_)): Http("1.0");
            case HttpResponse(X(_, _)): Unknown("");
        }
    }

    public static function toTuple(value : HttpHeader) : Tuple2<String, String> {
        function getName(name : String) : String {
            var index = name.indexOf("(");
            return Strings.camelCaseToDashes(name.substr(0, index <= 0 ? name.length : index));
        }

        var name = switch(value) {
            case HttpRequest(request): Some(getName(Std.string(request)));
            case HttpResponse(response): Some(getName(Std.string(response)));
        }

        var argument = switch (value) {
            case HttpRequest(Accept(v)): Some(v);
            case HttpRequest(AcceptCharset(v)): Some(v);
            case HttpRequest(AcceptEncoding(v)): Some(v);
            case HttpRequest(AcceptLanguage(v)): Some(v);
            case HttpRequest(AcceptDatetime(v)): Some(Std.string(v));
            case HttpRequest(Authorization(v)): Some(v);
            case HttpRequest(Cookie(v)): Some(v);
            case HttpRequest(ContentLength(v)): Some(Std.string(v));
            case HttpRequest(ContentMD5(v)): Some(v);
            case HttpRequest(ContentType(v)): Some(v);
            case HttpRequest(DateTime(v)): Some(Std.string(v));
            case HttpRequest(Expect(v)): Some(v);
            case HttpRequest(From(v)): Some(v);
            case HttpRequest(Host(v)): Some(v);
            case HttpRequest(IfMatch(v)): Some(v);
            case HttpRequest(IfModifiedSince(v)): Some(Std.string(v));
            case HttpRequest(IfNoneMatch(v)): Some(v);
            case HttpRequest(IfRange(v)): Some(v);
            case HttpRequest(IfUnmodifiedSince(v)): Some(Std.string(v));
            case HttpRequest(MaxForwards(v)): Some(Std.string(v));
            case HttpRequest(Pragma(v)): Some(v);
            case HttpRequest(ProxyAuthorization(v)): Some(v);
            case HttpRequest(Range(v)): Some(v);
            case HttpRequest(Referer(v)): Some(v);
            case HttpRequest(TE(v)): Some(v);
            case HttpRequest(Upgrade(v)): Some(v);
            case HttpRequest(UserAgent(v)): Some(v);
            case HttpRequest(Via(v)): Some(v);
            case HttpRequest(Warning(v)): Some(v);
            case HttpRequest(X(name, value)): Some('${name},${value}');
            case HttpResponse(AccessControlAllowOrigin(v)): Some(v);
            case HttpResponse(AcceptRanges(v)): Some(v);
            case HttpResponse(Age(v)): Some(Std.string(v));
            case HttpResponse(Allow(v)): Some(v);
            case HttpResponse(CacheControl(v)): Some(v);
            case HttpResponse(Connection(v)): Some(v);
            case HttpResponse(ContentEncoding(v)): Some(v);
            case HttpResponse(ContentLanguage(v)): Some(v);
            case HttpResponse(ContentLength(v)): Some(Std.string(v));
            case HttpResponse(ContentLocation(v)): Some(v);
            case HttpResponse(ContentMD5(v)): Some(v);
            case HttpResponse(ContentRange(v)): Some(v);
            case HttpResponse(ContentType(v)): Some(v);
            case HttpResponse(DateTime(v)): Some(Std.string(v));
            case HttpResponse(ETag(v)): Some(v);
            case HttpResponse(Expires(v)): Some(Std.string(v));
            case HttpResponse(LastModified(v)): Some(Std.string(v));
            case HttpResponse(Link(v)): Some(v);
            case HttpResponse(Location(v)): Some(v);
            case HttpResponse(P3P(v)): Some(v);
            case HttpResponse(Pragma(v)): Some(v);
            case HttpResponse(ProxyAuthenticate(v)): Some(v);
            case HttpResponse(Refresh(v)): Some(v);
            case HttpResponse(RetryAfter(v)): Some(Std.string(v));
            case HttpResponse(Server(v)): Some(v);
            case HttpResponse(SetCookie(v)): Some(v);
            case HttpResponse(StrictTransportSecurity(v)): Some(v);
            case HttpResponse(Trailer(v)): Some(v);
            case HttpResponse(TransferEncoding(v)): Some(v);
            case HttpResponse(Vary(v)): Some(v);
            case HttpResponse(Via(v)): Some(v);
            case HttpResponse(Warning(v)): Some(v);
            case HttpResponse(WWWAuthenticate(v)): Some(v);
            case HttpResponse(X(name, value)): Some('${name},${value}');
        }

        return tuple2(name.getOrElse(Strings.identity), argument.getOrElse(Strings.identity));
    }

    public static function toString(value : HttpHeader) : String {
        var tuple = toTuple(value);
        return '${tuple._1()}: ${tuple._2()}';
    }
}


package funk.net.http;

import funk.collections.immutable.List;
import funk.types.Tuple2;

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
}

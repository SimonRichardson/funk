package funk.net.http;

enum HttpHeader {
    Request(request : HttpRequestHeader);
    Response(response : HttpResponseHeader);
}

enum HttpRequestHeader {
    Accept;
    AcceptCharset;
    AcceptEncoding;
    AcceptLanguage;
    AcceptDatetime;
    Authorization;
    Cookie;
    ContentLength;
    ContentMD5;
    ContentType;
    Date;
    Expect;
    From;
    Host;
    IfMatch;
    IfModifiedSince;
    IfNoneMatch;
    IfRange;
    IfUnmodifiedSince;
    MaxForwards;
    Pragma;
    ProxyAuthorization;
    Range;
    Referer;
    TE;
    Upgrade;
    UserAgent;
    Via;
    Warning;
}

enum HttpResponseHeader {
    AccessControlAllowOrigin;
    AcceptRanges;
    Age;
    Allow;
    CacheControl;
    Connection;
    ContentEncoding;
    ContentLanguage;
    ContentLength;
    ContentLocation;
    ContentMD5;
    ContentRange;
    ContentType;
    Date;
    ETag;
    Expires;
    LastModified;
    Link;
    Location;
    P3P;
    Pragma;
    ProxyAuthenticate;
    Refresh;
    RetryAfter;
    Server;
    SetCookie;
    StrictTransportSecurity;
    Trailer;
    TransferEncoding;
    Vary;
    Via;
    Warning;
    WWWAuthenticate;
}

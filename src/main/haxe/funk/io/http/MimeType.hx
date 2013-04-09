package funk.io.http;

enum MimeType {
    Content(value : ContentType);
}

enum ContentType {
    Application(type : ApplicationType);
    Audio(type : AudioType);
    Image(type : ImageType);
    Message(type : MessageType);
    Multipart(type : MultipartType);
    Text(type : TextType);
    Video(type : VideoType);
}

enum ApplicationType {
    Atom;
    ECMAScript;
    GZip;
    Json;
    JavaScript;
    OctetStream;
    Rdf;
    Rss;
    Soap;
    Xhtml;
    Xml;
    XmlDtd;
    Zip;
}

enum AudioType {
    Basic;
    Mp4;
    Mpeg;
    Ogg;
    Vorbis;
    Wav;
    WebM;
}

enum ImageType {
    Gif;
    Jpeg;
    Png;
    Svg;
    Tiff;
}

enum MessageType {
    Http;
    Email;
}

enum MultipartType {
    Mixed;
    Alternative;
    Related;
    FormData;
    Signed;
    Encrypted;
}

enum TextType {
    Cmd;
    Css;
    Csv;
    Html;
    Javascript;
    Plain;
    VCard;
    Xml;
}

enum VideoType {
    Mpeg;
    Mp4;
    Ogg;
    QuickTime;
    WebM;
    XFlv;
    XMatroska;
    XWmv;
}

class MimeTypes {

    public static function isBinary(type : MimeType) : Bool {
        return switch(type) {
            case Content(Application(GZip)): true;
            case Content(Application(OctetStream)): true;
            case Content(Application(Zip)): true;
            case Content(Audio(_)): true;
            case Content(Image(_)): true;
            case Content(Multipart(_)): true;
            case Content(Video(_)): true;
            case _: false;
        }
    }

    public static function isJson(type : MimeType) : Bool {
        return switch(type) {
            case Content(Application(Json)): true;
            case _: false;
        }
    }

    public static function isText(type : MimeType) : Bool {
        return switch(type) {
            case Content(Text(Plain)): true;
            case _: false;
        }
    }

    public static function isXml(type : MimeType) : Bool {
        return switch(type) {
            case Content(Application(Atom)): true;
            case Content(Application(Rdf)): true;
            case Content(Application(Rss)): true;
            case Content(Application(Soap)): true;
            case Content(Application(Xhtml)): true;
            case Content(Application(Xml)): true;
            case Content(Application(XmlDtd)): true;
            case Content(Text(Xml)): true;
            case _: false;
        }
    }
}

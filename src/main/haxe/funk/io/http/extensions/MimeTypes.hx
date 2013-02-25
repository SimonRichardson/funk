package funk.io.http.extensions;

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
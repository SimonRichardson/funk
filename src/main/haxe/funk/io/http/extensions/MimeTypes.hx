package funk.io.http.extensions;

class MimeTypes {

	public static function isBinary(type : MimeType) : Bool {
		return switch(type) {
            case Content(type):
                switch(type) {
                    case Application(type):
                    	switch(type) {
							case GZip: true;
							case OctetStream: true;
							case Zip: true;
							default: false;
                    	}
                    case Audio(type): true;
                    case Image(type): true;
                    case Multipart(type): true;
                    case Video(type): true;
                    default: false;
                }
            default: false;
        }
	}

	public static function isJson(type : MimeType) : Bool {
		return switch(type) {
            case Content(type):
                switch(type) {
                    case Application(type):
                    	switch(type) {
							case Json: true;
							default: false;
                    	}
                    default: false;
                }
            default: false;
        }
	}

	public static function isText(type : MimeType) : Bool {
		return switch(type) {
            case Content(type):
                switch(type) {
                	case Text(type):
                		switch(type) {
                			case Plain: true;
                			default: false;
                		}
                    default: false;
                }
            default: false;
        }
	}

	public static function isXml(type : MimeType) : Bool {
		return switch(type) {
            case Content(type):
                switch(type) {
                	case Application(type):
                		switch (type) {
                			case Atom: true;
                			case Rdf: true;
                			case Rss: true;
                			case Soap: true;
                			case Xhtml: true;
                			case Xml: true;
                			case XmlDtd: true;
                			default: false;
                		}
                	case Text(type):
                		switch(type) {
                			case Xml: true;
                			default: false;
                		}
                    default: false;
                }
            default: false;
        }
	}
}
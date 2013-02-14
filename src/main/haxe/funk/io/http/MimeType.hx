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
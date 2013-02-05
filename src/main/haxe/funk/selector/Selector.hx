package funk.selector;

class Selector {

	public function new() {

	}

	public function query(selector : String) : Void {
		var lexer = new Lexer(selector);
		var parser = new Parser(lexer);
		parser.execute();
	}
}

private enum Constant {
	Integer(value : Int);
	Str(value : String);
	Ident(value : String);
}

private enum Token {
	Eof;
	Colon;
	Const(value : Constant);
	Dash;
	Dolar;
	Dot;
	Sharp;
	WhiteSpace;
	Unknown(value : String);
}

private enum Expr {
	EVar(name : String, value : Value); 
}

private enum Value {
	VIdent(name : String);
}

private class Lexer {

	private var _source : String;

	private var _index : Int;

	public function new(source : String) {
		_source = source;
	}

	public function hasNext() : Bool {
		return _index < _source.length;
	}

	public function next() : Token {
		return if (this.hasNext()) {
			var char = _source.charAt(_index++);
			switch(char) {
				case ":": Colon;
				case ".": Dot;
				case "#": Sharp;
				case "-": Dash;
				case "$": Dolar;
				default:
					var charCode = char.charCodeAt(0);
					if (charCode >= 48 && charCode <= 57) {
						Const(Integer(Std.parseInt(char)));
					} else if ((charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122)) {
						Const(Ident(char));
					} else if (charCode <= 32) {
						WhiteSpace;
					} else {
						Unknown(char);
					}
			}
		} else {
			Eof;
		}
	}
}

private class Parser {

	private var _lexer : Lexer;

	public function new(lexer : Lexer) {
		_lexer = lexer;
	}

	public function execute() : Void {
		for( token in _lexer) {
			trace(token);
		}
	}
}
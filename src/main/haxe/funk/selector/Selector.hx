package funk.selector;

import funk.Funk;
import funk.collections.immutable.List;
import funk.types.Function1;
import funk.types.Option;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.Lists;
using funk.collections.immutable.extensions.ListsUtil;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class Selector {

	public function new() {

	}

	public function query(selector : String) : Void {
		var lexer = new Lexer(selector);
		var parser = new Parser(lexer);
		var list : List<Expr> = parser.execute();
		trace(list);
	}
}

private enum Constant {
	Accessor(value : String);
	ClassName(value : String);
	Ident(value : String);
	Integer(value : Int);
	Number(value : Float);
	Tag(value : String);
}

private enum Token {
	Eof;
	Gt;
	Const(value : Constant);
	SemiColon;
	WhiteSpace;
	Unknown;
}

private enum Expr {
	ELine(value : Value);
}

private enum Value {
	VAccessor(value : String, next : Value);
	VClassName(value : String, next : Value);
	VDesender(next : Value);
	VInteger(value : Int);
	VNumber(value : Float);
	VIdent(value : String, next : Value);
	VTag(value : String, next : Value);
}

private class Lexer {

	private var _source : String;

	private var _index : Int;

	private var _patterns : List<Tuple2<EReg, Function1<String, Token>>>;

	public function new(source : String) {
		_source = source;
		_patterns = [
			tuple2("\\s*", function(value) {
				return WhiteSpace;
			}),
			tuple2(">", function(value){
				return Gt;
			}),
			tuple2(";", function(value){
				return SemiColon;
			}),
			tuple2("0", function(value) {
				return Const(Integer(Std.parseInt(value)));
			}),
			tuple2("-?[0-9]+\\.[0-9]*", function(value) {
				return Const(Number(Std.parseFloat(value)));
			}),
			tuple2("-?\\.[0-9]+", function(value) {
				return Const(Number(Std.parseFloat(value)));
			}),
			tuple2("-?[1-9][0-9]*", function(value) {
				return Const(Integer(Std.parseInt(value)));
			}),
			tuple2("\\.[a-zA-Z0-9\\-\\_]*", function(value){
				return Const(ClassName(value));
			}),
			tuple2("#[a-zA-Z0-9\\-\\_]*", function(value){
				return Const(Ident(value));
			}),
			tuple2(":[a-zA-Z0-9\\-\\_\\(\\)]*", function(value){
				return Const(Accessor(value));
			}),
			tuple2("[a-zA-Z0-9\\-\\_]*", function(value) {
				return Const(Tag(value));
			})
		].toList();
	}

	public function hasNext() : Bool {
		return _index < _source.length;
	}

	public function next() : Token {
		return if (this.hasNext()) {
			var substr = _source.substr(_index++);

			var token = None;
			_patterns.find(function(tuple) {
				var ereg = new EReg("^" + tuple._1(), "");

				var result = false;
				if(ereg.match(substr)) {
					var matched = ereg.matched(0);

					if (matched.length > 0) {
						_index += matched.length - 1;

						token = tuple._2()(matched).toOption();
						result = true;
					}

				}
				return result;
			});
			token.getOrElse(function() {
				return Unknown;
			});
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

	public function execute() : List<Expr> {
		var list = Nil;
		while(_lexer.hasNext()) {
			list = list.append(ELine(matchToken(next())));
		}
		return list;
	}

	private function next() : Option<Token> {
		return if (_lexer.hasNext()) {
			Some(_lexer.next());
		} else {
			None;
		}
	}

	private function matchToken(opt : Option<Token>) : Value {
		return switch (opt) {
			case Some(token):
				switch(token){
					case Const(const):
						switch (const) {
							case Accessor(value): VAccessor(value, matchToken(next()));
							case ClassName(value): VClassName(value, matchToken(next()));
							case Ident(value): VIdent(value, matchToken(next()));
							case Integer(value): VInteger(value);
							case Number(value): VNumber(value);
							case Tag(value): VTag(value, matchToken(next()));
						}
					case Gt: VDesender(matchToken(next()));
					case WhiteSpace: matchToken(next());
					case SemiColon: null;
					case Eof: null;
					case Unknown: Funk.error(IllegalOperationError("Unknown token"));
				}
			case None: null;
		}
	}
}

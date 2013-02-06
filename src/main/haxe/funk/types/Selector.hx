package funk.types;

import funk.Funk;
import funk.collections.immutable.List;
import funk.types.Function1;
import funk.types.Option;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.Lists;
using funk.collections.immutable.extensions.ListsUtil;
using funk.types.extensions.Anys;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class Selector {

	public static function query(selector : String) : List<Expr> {
		var lexer = new Lexer(selector);
		var parser = new Parser(lexer);
		return parser.execute();
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
	Comma;
	Const(value : Constant);
	Plus;
	SemiColon;
	Tilde;
	WhiteSpace;
	Unknown;
}

enum Expr {
	ELine(expr : Expr);
	EProp(value : Value);
	EPropBlock(value : Value, expr : Expr);
}

enum Value {
	VAccessor(value : String);
	VClassName(value : String);
	VChild;
	VInteger(value : Int);
	VIdent(value : String);
	VNext;
	VNumber(value : Float);
	VSibling;
	VTag(value : String);
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
			tuple2(",", function(value){
				return Comma;
			}),
			tuple2(";", function(value){
				return SemiColon;
			}),
			tuple2("\\~", function(value){
				return Tilde;
			}),
			tuple2("\\+", function(value){
				return Plus;
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

	private function hasNext() : Bool {
		return _lexer.hasNext();
	}

	private function next() : Option<Token> {
		return if (_lexer.hasNext()) {
			Some(_lexer.next());
		} else {
			None;
		}
	}

	private function matchToken(opt : Option<Token>) : Expr {
		var fold = function (value : Value) {
			var token = if (hasNext()) {
				matchToken(next());
			} else {
				null;
			}
			return token.toBool() ? EPropBlock(value, token) : EProp(value);
		};

		return switch (opt) {
			case Some(token):
				switch(token){
					case Const(const):
						switch (const) {
							case Accessor(value): fold(VAccessor(value));
							case ClassName(value): fold(VClassName(value));
							case Ident(value): fold(VIdent(value));
							case Integer(value): EProp(VInteger(value));
							case Number(value): EProp(VNumber(value));
							case Tag(value): fold(VTag(value));
						}
					case Gt: fold(VChild);
					case Comma: null;
					case Plus: fold(VNext);
					case SemiColon: null;
					case Tilde: fold(VSibling);
					case WhiteSpace: matchToken(next());
					case Unknown: Funk.error(IllegalOperationError("Unknown token"));
					case Eof: null;
				}
			case None: null;
		}
	}
}

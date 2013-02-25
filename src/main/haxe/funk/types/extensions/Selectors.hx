package funk.types.extensions;

import funk.types.Selector;

class Selectors {

	public static function toString(expr : Expr) : String {
		return extractExpr(expr);
	}

	private static function extractExpr(expr : Expr) : String {
		return switch(expr) {
			case ELine(e): extractExpr(e);
			case EProp(v): extractValue(v);
			case EPropBlock(v, e): '${extractValue(v)} ${extractExpr(e)}';
			case ESub(e): extractExpr(e);
		};
	}

	private static function extractValue(value : Value) : String {
		return switch(value) {
			case Accessor(v): ':${v}';
			case All: "*";
			case ClassName(v): '.${v}';
			case Child: ">";
			case Integer(v): Std.string(v);
			case Ident(v): '#${v}';
			case Next: "+";
			case Number(v): Std.string(v);
			case Sibling: "~";
			case Tag(v): v;
			case Word(v): v;
		}
	}

}
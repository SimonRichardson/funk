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
			case EPropBlock(v, e): Std.format("${extractValue(v)} ${extractExpr(e)}");
			case ESub(e): extractExpr(e);
		};
	}

	private static function extractValue(value : Value) : String {
		return switch(value) {
			case Accessor(v): Std.format(":${v}");
			case All: "*";
			case ClassName(v): Std.format(".${v}");
			case Child: ">";
			case Integer(v): Std.string(v);
			case Ident(v): Std.format("#${v}");
			case Next: "+";
			case Number(v): Std.string(v);
			case Sibling: "~";
			case Tag(v): v;
			case Word(v): v;
		}
	}

}
package funk.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class WildcardMacro {
	
	@:macro
	public static function build() : Array<Field> {
		var position:Position = Context.currentPos();
        var fields:Array<Field> = Context.getBuildFields();
		var localClass:Null<Ref<ClassType>> = Context.getLocalClass();
		
		var methodName = "method";
		var method = Std.format("function $methodName(wildcard:funk.Wildcard, dyn:Dynamic):Dynamic {
									return Reflect.getProperty(dyn, \"$methodName\");
								 }");
								 
		var block : Expr = Context.parse("{" + method + "}", position);
        switch (block.expr) {
            case EBlock(exprs):
                switch (exprs[0].expr) {
                    case EFunction(name, f):
                        fields.push({
                            name: methodName,
                            doc: null,
                            access: [AStatic, APublic],
                            kind: FFun(f),
                            pos: f.expr.pos,
                            meta: []
                        });
                    default:
                }
            default:
        }
		
		return fields;
	}
}

package funk.wildcard;

#if macro
import funk.macro.IMacroBuilder;
import funk.macro.MacroFunctionBuilder;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class WildcardMacro {
	
	@:macro
	public static function build() : Array<Field> {
		
		var position:Position = Context.currentPos();
        var fields:Array<Field> = Context.getBuildFields();
		
		var methodName : String = "method";
		var code : String = Std.format("public static function $methodName(wildcard:funk.wildcard.Wildcard, v:Dynamic):Dynamic {
											return Reflect.getProperty(v, \"$methodName\");
										}");
		
		var builder:IMacroBuilder = new MacroFunctionBuilder(code, position);
		var builderFields:Array<Field> = builder.build();
		
		return fields.concat(builderFields);
	}
}
#end
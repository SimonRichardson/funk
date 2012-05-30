package funk.macro;

#if macro
import haxe.macro.Expr;

interface IMacroBuilder {
	
	function build():Array<Field>;
}
#end

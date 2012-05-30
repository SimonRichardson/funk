package funk.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

class MacroFunctionBuilder implements IMacroBuilder {
	
	private var _code : String;
	
	private var _position : Position;
	
	public function new(code : String, ?position : Position){
		_code = code;
		_position = null == position ? Context.currentPos() : position;
	}
	
	public function build(): Array<Field> {
		var data = parse(_code);
		var code = data.code;
		
		var fields = new Array<Field>();
		var block = Context.parse(Std.format("{$code}"), _position);
		
		switch (block.expr) {
            case EBlock(exprs):
                for (expr in exprs) {
                    switch (expr.expr) {
                        case EFunction(name, f):
                            fields.push({
                                name: data.name,
                                doc: null,
                                access: data.accessors,
                                kind: FFun(f),
                                pos: f.expr.pos,
                                meta: []
                            });
                        default:
                    }
                }
            default:
        }
		
		return fields;
	}
	
	private function parse(code:String): {code:String, name:String, accessors:Array<Access>} {
		var buffer = new StringBuf();
		var accessors = new Array<Access>();
		var range = _code.indexOf("(");
		
		var until = true;
		var name = "";
		
		var i = 0;
		while(true) {
			var c = _code.charCodeAt(i);
			var buf = new StringBuf();
			
			do {
				buf.addChar(c);
				c = _code.charCodeAt(++i);
			} while((c >= 65 && c <= 90 || c >= 97 && c <= 122) && i < range);
			
			var part = buf.toString();
			var accessor = switch(part) {
				case "public": APublic;
                case "private": APrivate;
                case "static": AStatic;
                case "override": AOverride;
                case "dynamic": ADynamic;
                case "inline": AInline;
			}
			
			name = part;
			
			if(accessor != null) {
				accessors.push(accessor);
			} else {
				buffer.add(part);
				buffer.add(" ");
			}
			
			if(i >= range) {
				break; 
			}
			
			i += 1;
		}
		
		buffer.add(_code.substr(range));
		return {
					code: buffer.toString(), 
					name: name,
					accessors: accessors
				};
	}
}
#end
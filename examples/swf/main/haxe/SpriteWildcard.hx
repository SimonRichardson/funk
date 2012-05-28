package ;

import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import funk.Wildcard;

class SpriteWildcardType {
	
	public static function graphics(wildcard : Wildcard, s : Sprite) : Graphics {
		return s.graphics;
	}
	
	public static function addChild(wildcard : Wildcard, d : DisplayObjectContainer) : Sprite -> Void {
		return function(s : Sprite) : Void {
			d.addChild(s);
		}
	}
}

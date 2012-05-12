package funk.util;

enum RequireRange {
	requireRange(index : Int);
}

class RequireType {
	
	inline public static function toBeLessThan(req : RequireRange, end : Int) : Void {
		switch(req) {
			case requireRange(index): 
				if(index < 0 || index >= end) {
					throw new RangeError(Std.format("Index $index is out of range."));
				}
		}
	}
	
	inline public static function toBe(req : RequireRange, end : Int, start : Int) : Void {
		switch(req) {
			case requireRange(index): 
				if(index < start || index >= end) {
					throw new RangeError(Std.format("Index $index is out of range."));
				}
		}
	}
}


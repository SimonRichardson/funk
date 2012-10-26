package funk.signal;

interface IPrioritySignal extends ISignal {

}

class PrioritySignal implements IPrioritySignal {

	public function new() {
		super();
	}

	override private function get_productPrefix() : String {
		return "PrioritySignal";
	}
}

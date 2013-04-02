package funk.actors.routing;

import funk.actors.routing.Routing;

class RandomRouter extends AccessRouter {

    public function new(nrOfInstances : Int) {
        super(nrOfInstances);
    }

    override private function access(offset : Int, size : Int) : Int {
        return Math.floor(Math.random() * size);
    }
}
